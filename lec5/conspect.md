# RAII и перемещение

## Владение ресурсом.

```cpp

S *p = new S;
foo(p);

delete p;

```

Что может быть не так в этом коде? например, foo(p) может удалить указатель  на p. 

### Забавный пример

```cpp

template <typename T> int foo(int n) {
    S *p = new S(n);
    // code here
    if(condition) {
        delete p;
        return FAIL;
    }

    // code here
    delete p;
    return SUCCESS;
}

```

Как избежать подобных конструкций? 
напрмиер через goto

В официальном coding style из linux kernel говорится о том, что нужно в таких случаях использовать goto

### А что плохого в goto?

Потому что goto может например перейти в точку до объявления объекта.
goto делает из программы произвольный граф. 

Если мы не используем goto наша программа выглядит как дерево.


### Социально приемлемое goto
 
```cpp


template <typename T> int foo(int n) {
    S *p = new S(n);
    int result = SUCCESS;
    do {
        if(condition) {
            result = FAIL;
            break;
        }
        // some code here
    } while (0);


    // code here
    delete p;
    return SUCCESS;
}

```

По сути в данном случае - break - это goto маскирующая конструкция

Что вы думаете о таком коде? 
```cpp
struct X {
  int smth = 42;
};

int foo(int cond) {
    switch(cond){ 
        case 0: X x;
        case 1: return x.smth; // 42? no. compilation error.
    }
}
```
Нельзя перепрыгнуть в case 1: мимо инициализации переменной x из case 0: — это опасно по стандарту C++"

## RAII resource acquisition is initialization

Чтобы не писать goto можно спроектировать класс, в котором конструктор захватывает владение, а дестьруктор освобождает ресурс


```cpp

template<typename T> int foo(int n) {
    ScopedPointer<T> sp {new T(n);} // ownership passed

    /// code here

    if(condition) {
        return FAIL; // dtor called
    }

    // code here

    return SUCESS; // dtor called
}

```
Пример на двоечку

```cpp

template<typename T>
class ScopedPointer {
  public:
  ScopedPointer(T* ptr = nullptr) : ptr_(ptr){}
  ~ScopedPointer() {delete ptr;}
  private:
    T* ptr_;
};

```

В чём могут быть проблемы с этим классом? Что по копированию?

```cpp

template<typename T>
class ScopedPointer {
  public:
  ScopedPointer(T* ptr = nullptr) : ptr_(ptr){}
  ScopedPointer(const ScopedPointer& rhs) : ptr_(new T{*rhs.ptr_}) {}
  ScopedPointer& operator=(const ScopedPointer& rhs);
  ~ScopedPointer() {delete ptr;}

  T& access() { return *ptr_; }
  const T& access() { return *ptr_; } // для того чтобы можно было вызвать у cv объекта
  T& operator*() { return *ptr_; } // не путать с умножением. у умножения был бы аргумент.
  const T& operator*() { return *ptr_; }
  private:
    T* ptr_;
};

```

Уже лучше, но хотелось бы еще стрелочку. Что должна возвращать стрелочка? Что она должна брать как аргумент? 

```cpp
template<typename T>
class ScopedPointer {
  public:
  ScopedPointer(T* ptr = nullptr) : ptr_(ptr){}
  ScopedPointer(const ScopedPointer& rhs) : ptr_(new T{*rhs.ptr_}) {}
  ScopedPointer& operator=(const ScopedPointer& rhs);
  ~ScopedPointer() {delete ptr;}

  T& access() { return *ptr_; }
  const T& access() { return *ptr_; } // для того чтобы можно было вызвать у cv объекта
  T& operator*() { return *ptr_; } // не путать с умножением. у умножения был бы аргумент.
  const T& operator*() const { return *ptr_; }

  T* operator->() { return ptr_; }// ЧЕГО? почему мы возвращаем указатель? 
  const T* operator->() const { return ptr_; }// ЧЕГО? почему мы возвращаем указатель? 
  private:
    T* ptr_;
};

```

T* operator->() { return ptr_; }// ЧЕГО? почему мы возвращаем указатель? 

p->x = (p.operator->())->x и так сколько угодно раз. Благодаря Drilldown поведению, мы можем получить только конкретное поле класса

Drill-down механизм operator->:

Когда вы пишете obj->x, компилятор ведёт себя так:

    Вызывает obj.operator->()

        Если он возвращает указатель (T*), то просто применяет ->x к нему (работает как обычный указатель).

        Если возвращает объект, у которого тоже есть operator->, то компилятор повторяет процесс для этого объекта.

    Продолжает "копать" (drill-down), пока не получит указатель

        Это может быть цепочка из множества вызовов operator->.

        Как только встречается T*, компилятор останавливается и применяет ->x к нему.



```cpp
struct client {
    int z;
};

struct proxy1 {
    client* target;
    client* operator->() const {
        return target;
    } 
};

struct proxy2 {
    proxy1* target;
    proxy1& operator->() {
        return *target;
    }
};
int main () {

client x {3};
proxy1 y {&x};
proxy2 y2 {&y};
y2->z = 42;
std::cout << x.z << y->z << y2->z;
}

// y->z = (y.operator())->z
// y2->z = ((y.operator()).operator->())->z

```

Итак, мы решили проблему копирования и присваивания. И даже доступ через `->`

Хорош ли получившийся ScopedPointer? Подумайте вот о чём

```cpp

S *a = new S(1), *b = new S(2); // raw pointers

std::swap(a, b); // что происходит здесь? Копирование указателя во временный указатель, потом 2 копирования указателей

ScopedPointer<S> x{new S(1)}, y{new S(2)};

std::swap(x, y); // а что здесь? А здесь получается происходит 1) копи конструктор 2 присваивания и 3 дорогущих освобождения

```

# Семантика перемещения

Итак, у последовательности битов в памяти может быть концепция имени. Она же концепция lvalue ссылки
У последовательнсоти битов в памяти трактуемых как какой-то тип, может быть имя, может даже не одно, если у нас есть ссылка

И мы сказали, что  lvalue это что-то у чего есть location

НО также есть rvalue. Это выражение, которое мы можем получить из lvalue

Операция "взять выражение, связать выражение с именем и в этот же момент материализовать объект выражения" называется "ссылкой на rvalue"

int x = 0;
int&& y = x + 1; // y как выражение - lvalue, но при этом связана она с rvalue

rvalue референс по сути даёт жизнь любому объекту (как будто продляет жизнь выражению из lvalue)

## std::move
#include <iostream>

int main () {
    int x = 4;
    int &&y = x + 1;
    
    std::cout << &x << " " << &y << std::endl;
    std::cout << x << " " << y << std::endl;

    int &&z = std::move(x);
    int& i = x;
    z = z + 1;
    i = i + 1;
    y = y + 1;
    std::cout << z << std::endl;
    std::cout << x << " " << i << " " << y << std::endl;
}

что конкретно здесь произошло? 

`y` связался с rvalue объектом x + 1. ему присвоено значение 5
`z` связался с lvalue, теперь он является rvalue ref на x, в данном случае он ведёт себя схожим образом с int& однако есть несколько моментов
1) если бы x был бы сложным объектом - произошло бы перемещение (если бы был доступен конструктор перемещения)
2) невозможно было написать int&& z = x; только временный объект или приведение к правой ссылке через std::move 

## Кросс связывание

int x = 1; // OK
int &&y = x + 1; // OK
int && b = x; // FAIL, не rvalue

int& c = x  + 1; // FAIL. неконстантная ссылка не может быть связана с  rvalue

const int& d = x + 1;// ok продлила время жизни

int &&e = y; // FAIL. y не rvalue. правая ссылка создает себе адрес и имя и является lvalue

int& f = y; // ok

Идея очень тонкая, но она позволяет нам определять объекты которых нам жалко или не жалко

## Методы над rvalues
```cpp
struct S{
    int n = 0;
    int& access() { return n; }
};

S x;
int& y = x.access(); // ok.
int& z = S{}.access(); // dangling reference. this is parrot no more

```

Причем есть большой шанс, что это будет работать без ошибок(до определенного момента пока n не сотрётся со стека)

Какой у нас вариант? 

если мы хотим вернуть & то const int& не подойдёт

struct S {
    int foo() &;// 1
    int foo() &&;// 2
};

extern S bar(); // возвращает временный S  объект

S x {};

x.foo();// 1
bar().foo(); // 2

```cpp
struct S{
    int n = 0;
    int& access() & { return n; }
};

S x;
int& y = x.access(); // ok.
int& z = S{}.access(); // Ошибка компиляции 'this' argument to member function 'access' is an rvalue, but function has non-const lvalue ref-qualifierclang(member_function_call_bad_ref)

```


если мы хотим вернуть rvalue ref то аннотировать его & 

```cpp
#include <vector>
using std::vector;
class X {
 vector<char> data_;

 public:
 X() = default;
 vector<char> const & data() const & { return data_; }
 vector<char>&& data() && { return std::move(data_); }
};


X obj;
vector<char> a = obj.data(); // copy
const auto& x = obj.data();
auto& z = obj.data();
vector<char>& y = obj.data();
const vector<char>& s = obj.data();
vector<char> b = X().data(); // move

```

int& foo(int& x) { return x; } // ok
const int& bar(const int& x) { return x; }// когда как

int&& buz(int&& x) {return std::move(x); } // DANGLE

мы обычно не хотим возвращать && если у нас не &&- аннотированный метод

в каком случае у нас может завснуть ссылка при const int&?

при этом int& bat(int&& x) {return x;} //снова когда как

Если из вашего метода вы возвращаете && то либо он && аннотирован
либо вы пишете std::forward, move, declval или вы ошибаетесь

```cpp
template <typename T> class ScopedPointer {
  T* ptr_;

  public:
    ScopedPointer(const ScopedPointer& rhs) : ptr_(rhs.ptr_) {

    }

    ScopedPointer(ScopedPointer&& rhs) : ptr_(rhs.ptr_) {
        rhs.ptr_ = nullptr;
    }
};

```


## Перемещающее присваивание
1й вариант

```cpp
ScopedPointer& operator=(ScopedPointer&& rhs) {
    if(this == &rhs) return *this;

    delete ptr_;
    ptr_ = rhs.ptr_;
    rhs.ptr_ = nullptr;
    return *this;
}

```

2й вариант

```cpp

ScopedPointer& operator=(ScopedPointer&& rhs) {
    if(this == &rhs) return *this;
    std::swap(ptr_, rhs.ptr_);
    return *this;
}

```

После перемещения объект находится в консистентном но не обязательно предсказуемом состоянии

    
Обязательна ли здесь if(this == &rhs) return *this; эта проверка? up to you

новый swap

template <typename T> void swap(T& x, T& y) {
    T tmp = std::move(x);
    x = std::move(y);
    y = std::move(tmp);
}

Если у нас в классе нет мув конструктора, то  T tmp = std::move(x); это по сути копи конструктор


## Аккуратнее с move on result

T foo(some arguments) {
    T x = some expression;
    // more code

    return std::move(x); // не ошибка, но зачем? 
}

* Функция, возвращающая by value это rvalue и таким образом всё равно делает move в точке вызова
* При этом использование std::move может сделать вещи хуже, убив RVO
* Ограничте mpve on result случаями возврата ссылки(так как мы не хотим возращать rvalue ref никогда, то и мув возвращать не стоит никогда)

int x = 1;
int a = std::move(x);
assert(x == a); // выполнится или нет? я думаю да, потому что std::move от простого объекта по сути делает тот жзе объект

ScopedPointer y {new int(10)};
ScopedPointer b = std::move(y);
assert (y == b); // ?

```cpp

template <typename T> class SillyPointer{ 
    T* ptr_;

    public:
      SillyPointer(T* ptr = nullptr) : ptr_(ptr) {}
      ~SillyPointer() { delete ptr_};
};

template <typename T> void swap(T& lhs, T& rhs) {
    T tmp = std::move(lhs);
    lhs = std::move(rhs);
    rhs = std::move(tmp);
} // UB(probably segfault)

```
Почему так? потому что перемещение по умолчанию перемещает все поля класса, то есть произойдёт побитовое копирование указателя и потенциально 2ное или даже 3е освобождение памяти

Очень важно в мув конструкторе занулять старое состояние


# Правило пяти

Классическая идиома проектирования rule of five утверждает, что:

Если ваш класс требует нетривиального определения хотя бы одного из этих методов

1) копирующего конструктора
2) копирующего присваивания
3) перемещающего конструктора
4) перемещающего присваивания
5) деструктора
   
то лучше бы нетривиально переопределить все пять.

Очевидно, что SillyPointer нарушает эту идиому

Если класс RAII класс - он должен определить все 5 методов
или например запретить! (= delete)

Правило пяти отличное, но оно противорeчит SRP, если его неправильно использовать

Если ваш класс управляет ресурсом и делает ещё что-то, то эт неверно


# Правило нуля

Если ваш класс требует нетривиального определения, то:
* В нём не должно быть других методов

Написание любого из 5 методов - это экстрим.

# Краевой случай

const ScopedPointer<int> y{new int (10)};

ScopedPointer<int> b = std::move(y); // копирование.

std::move приведёт y к const rvalue ref. Константная правая ссылка  ближе к левой ссылке. 
Поэтому в данном случае мы будем копировать.

* Поэтому константные правые ссылки приводятся к константным левым.

# Двумерные массивы.

RAM модель памяти в принципе одномерна, поэьтому с двумерными массивами начинаются сложности

1001000001110011 - 0000 это a[1][0] или a[0][1] 
Это a[0][1] тк мы делаем отступ в 1 инт, если бы это был a[1][0], то мы бы отступили на 4 инта

row-major order это значит что первым изменяется самый внешний индекс

int one[7] - 7 столбцов
int two[1][7] - 1 строка 7 столбцов
int three[1][1][7] - 1 слой 1 строка 7 столбцов

Почему row-major?

int a[7][9] - 9 столбцов 7 строк
int e = a[2][3] - 3 столбец 2 строка

* Непрерывный массив
int cont[10][10];
foo(cont);
cont[1][2] = 1; // ? 1 * 10 + 2

* Массив указателей 
int *jagged[10];
bar(jagged);
jagged[1][2] = 1; // ? 

* Функция берущая указатель на массив
void foo(int (*pcont)[10]) {
    pcont[1][2] = 1; // 1 * 10 + 2
}

* Функция берущая указатель на массив указателей
void bar(int ** pjag) {
    pjag[1][2] = 1;
}

Самый интересный вопрос, как во всех этих случаях вычисляется доступ к элементу


# Вычисление адресов

* Массиво подобное
int first[FX][FY];
first[x][y] = 3; // *(&first[0][0] + x * FX + y) = 3

int (*second)[SY];
first[x][y] = 3; // *(&second[0][0] + x * SY + y) = 3;

* Указателе подобное

int *third[SX];
third[x][y] = 3; // *(*(third + x) + y) = 3;

int ** fourth;
fourth[x][y] = 3; // *(*(fourth + x) + y) = 3;


float flt[2][3] = {{1.0, 2.0, 3.0}, {4.0, 5.0}}// ok? Да, третий элемент второй строки будет заполнен нулём
float flt[][3] = --/-- // ok? Да, нам важен только внешний символ

float flt[][] = не окей


очень просто запомнить

Массивы гниют изнутри

float func(float flt[][3][6]); // ok, float *flt[3][6];

extern int* a;
extern int b[]; -> где-то есть массив b какой-то длины

i = a[5] // ? *(a + 5)
i = b[5] // ? *(b + 5)

