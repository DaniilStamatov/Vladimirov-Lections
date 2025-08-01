# Inicialization and copy

## 📘 Оглавление
- [Inicialization and copy](#inicialization-and-copy)
  - [📘 Оглавление](#-оглавление)
  - [Binary search tree](#binary-search-tree)
    - [Range queries](#range-queries)
  - [Start designing search tree](#start-designing-search-tree)
  - [Designing Node](#designing-node)
- [Lets talk about constructors](#lets-talk-about-constructors)
  - [Old initialization vs new](#old-initialization-vs-new)
  - [Double initialization](#double-initialization)
    - [Direct initialization](#direct-initialization)
  - [Two rules of initialization](#two-rules-of-initialization)
    - [Default params](#default-params)
  - [Constructor delegation](#constructor-delegation)
  - [Back to the Node](#back-to-the-node)
  - [So many squats](#so-many-squats)
  - [Ассиметрия инициализации](#ассиметрия-инициализации)
- [Волшебные очки.](#волшебные-очки)
  - [Копирование vs присванивание](#копирование-vs-присванивание)
    - [смотрим на класс Empty через волшебные очки](#смотрим-на-класс-empty-через-волшебные-очки)

## Binary search tree

Properties of binary search tree:
1. Any element of the right subtree is **greater** than any element in the left subtree.
2. Any key can be found from the root of the tree in time proportional to the tree’s height.
3. In the best case, a tree with **N** elements will have height of **logN**.
4. With the same set of elements all of the search operations are saving its **inorder** pass as sorted.

Why do we need search trees? 
* We can find any key by simply going left or right, comparing keys at each step..

### Range queries

**Task**
* Let the input consist of keys **(each key is an integer, and all keys are unique)**  
* TODO: For each query, return the number of keys strictly between the given left and right bounds.
* **Input**: k 10 k 20 q 8 31 q 6 9 k 30 k 40 q 15 40
* **Result**: 2 0 3

How could you solve this problem?
Use std::set to complete this task

<details>
<summary> Click to see the solution </summary>

```cpp

#include <set>
#include <string>
#include <iostream>
template <typename C, typename T>
int range_query(const C& s, T first, T second) {
  using it = typename C::iterator;
  it start = s.lower_bound(first); // first not less element
  it end = s.upper_bound(second); // first greater
  return std::distance(start, end); // (O(n))
}
int main () {
    std::set<int> tree;
    std::string cmd;
    int a, b;
    while(std::cin >> cmd) {
        if(cmd == "k") {
            std::cin >> a;
            tree.insert(a);
        }
        else if (cmd == "q") {
            std::cin >> a >> b;
            int dist = range_query(tree, a, b);
            std::cout << dist << std::endl;
        }
    }
}
```
</details>

## Start designing search tree

```cpp

namespace Trees {
    template <typename KeyT, typename Comp>
    class SearchTree {
        struct Node;
        using iterator = Node *;
        Node *top_;

    public: // selectors
        iterator lower_bound(KeyT key) const;
        iterator upper_bound(KeyT key) const;
        int distance(iterator fst, iterator snd) const;
    public: //modificators
        void insert(KeyT key);
    };
}

```
**Conclusion from this code**
1. Don’t be afraid to reopen the `public` or `private` sections — it helps to clarify what each part of the code is responsible for.
2. When we designed our tree like this we encounter the second invariant of this class(not only searching) and it is **Balance**

So how does std::set provide us O(log(n)) complexity in searching? By balancing. I strongly recommend that you look up how balancing is implemented.

And there are several strategies to contain invariants in **Node**:
1. We can use color(just like in RBTree)
2. We can use height(just like AVL tree)
3. etc.

## Designing Node

```cpp
struct Node {
    KeyT key_;
    Node* parent_, *left_, *right_;
    int height_; // AVL invariant
};

```

What is wrong with this node? Think about initialization. 

Look at `C style` initialization
```cpp

Node n = { key, nullptr, nullptr, nullptr, 0};
Node n = { key };
Node n {key}; // Rest  of fields is 0

```
What is wrong? if we add just one private field - we get crash. 

```cpp
struct Node {
    KeyT key_;
    Node* parent_, *left_, *right_;
    int balance_factor() const;
private:
    int height_; // AVL invariant
};

Node n { key }; // we can crash agregate here because Node  has private fields etc.

```

# Lets talk about constructors

```cpp

struct Node {
    KyeT key_;
    Node* parent = nullptr, *left = nullptr, *right = nullptr;
    int height_ = 0;

    Node(KeyT key) { key_ = key; }; // constructor
};

now we can initialize it like 

Node n(key); // old initialization
Node n{key}; // new syntax of initialization
Node k = key; // copy initialization

```

Node k = key; // copy initialization
This is not a copy. This is exactly copy initialization. just syntax for this(later we will discuss it)


## Old initialization vs new

Suggest we have a class that is cunstructed from two lists

```cpp
myclass_t m(list_t(), list_t()); // is it a constructor?
myclass_t m{list_t(), list_t()}; // is it a constructor? 


#include <iostream>
struct list_t {};

struct myclass_t {
    int x = 42;
    myclass_t(list_t, list_t) {}
};

int main () {
    myclass_t n(list_t(), list_t()); // this is function!
    myclass_t m{list_t(), list_t()};

    std::cout << n.x << std::endl; //Member reference base type 'myclass_t (list_t (*)(), list_t (*)())' is not a structure or union
    std::cout << m.x << std::endl;
}

```

So {} is a better way - but if we have constructor from initializaer list - beware of using it. In other cases - use {} 

## Double initialization

```cpp
struct  S{ 
  S() { std::cout << "default" << std::endl; }
  S(KeyT key) { std::cout << "direct\n"; }
};

struct Node {
    S key_; int val_;
    Node(KeyT key, int val) {key_ = key; val_ = val; } // after this we will see default and direct
}
```

So why it works like this? because  `S key_;` here we use default constructor. and after start of constructor of Node -> we get direct initialization.

How we can fix it? 

just by using initialization list.


```cpp
struct  S{ 
  S() { std::cout << "default" << std::endl; }
  S(KeyT key) { std::cout << "direct\n"; }
};

struct Node {
    S key_; int val_;
    Node(KeyT key, int val): key_(key), val_(val) {}
}
 
And now we see only "direct". I recommend you to use initialization list. 

```
### Direct initialization

Direct initialization is an initialization that goes with () and values  in (); Just like in code upper we can see key_(key) that is directly initialized

## Two rules of initialization

1. List of initialization compiles strongly in order that is defined in class(not how it is written in the list)

```cpp

struct Node {
    S key_; T key2_;
    Node(KeyT key, T key2) : key2_(key), key_(key) {} // S, T!
};
```

2. Initialization in the body of a class is invisibly included in the list of initialization

```cpp
struct Node {
    S key_ = 1; T key2_;
    Node(KeyT key) : key2_(key) {} // S, T
};
```
### Default params

```cpp
struct Node {
  S key_ = 1;
  Node() {} // key_(1)
  Node(KeyT key) : key_(key) {} // key_(key) // here S key_ = 1; will not be processed
};

Things like this are better to write this way

struct Node {
  S key_;
  Node(KeyT key = 1) : key_(key) {} // key_(key) // now it works like default constructor
};

```
## Constructor delegation
```cpp
struct  class_c {
  int max = 0, min = 0;

  class_c(int mymax) : max(mymax > 0 ? mymax : DEFAULT_MAX) {}
  class_c (int mymax, int mymin) : class_c(mymax), min(mymin > 0 : mymin : DEFAULT_MIN) {} // ONLY first in initialization list

};

```

## Back to the Node

```cpp
struct Node {
  KeyT key_;
  Node* parent_ = nullptr, *left = nullptr, *right = nullptr;
  int height = 0;
  Node(KeyT key) : key_(key) {}
  ~Node() {delete left_; delete right_;} // destructor? bomba
};
```

В чем может быть проблема с рекурсивным удалением ноды?
1. Переполнение стека по рекурсивному вызову
2. Не слишком ли много мы на себя берем уничтожая объект ноды. А что если эта нода была создана не с помощью new?? 

Как это решить? Задачу должен выполнять SearchTree.

```cpp

template<typename T, typename Comp>
~SearchTree() {delete top_;} // нужна ли здесь проверка на nullptr?? нет. потому что delete сам проверяет равен ли nullptr указатель

```

## So many squats

```cpp

public:
 ~myVector() {
    delete[] buf_;
    // buf_ = nullptr;
    // size_ = 0;
    // capacity_  = 0;
 }

 ``` 

 1. buf_ = nullptr - бесполезен  в данном случае, потому что после вызова delete[] buf_ перестаёт существовать
 2. size_ и capacity_ тоже лишние, потому что после вызова деструктора myVector перестанет существовать

Компилятор просто выбросит эти 3 строки.

## Ассиметрия инициализации

SearchTree s; // default init
SearchTree t {}; // default init

int n; // default init
int  m{}; // value init (m = 0) по сути 0 инициализация, здесь мы решаем чучуть заплатить за зануление, тк дефолт инициализация - это просто сдвиг стек поинтера. что лежало там(мусор) то и будет лежать

int* p = new int [5] {} // calloc(как маллок только зануляем все элементы)


# Волшебные очки.

class Empty {

};

Сколько занимает в памяти пустой класс? <details> 1 байт </details>
что мы можем сделать с объектом этого класса? <details> копировать, создать, присвоить, уничтожить </details>

## Копирование vs присванивание

Copyable a; // default
Copyable b(a), c{a}; // прямое конструирование
Copyable d = a; // Копирующее конструирование
 
a = b; // присваивание ( то есть перезапись старого объекта)

d = c = a = b; // присваивание цепочкой (правоассочиативное) => a = b, c = b, d = b

`Ergo:` копирование похоже на конструктор. Присваивание совсем не похоже.

Присваивание делается над УЖЕ существующим конструкторомю.

### смотрим на класс Empty через волшебные очки


class Empty {
**  Empty() = default;
    ~Empty(); // dtor
    Empty(const Empty&); // copy ctor
    Empty& operator=(const Empty&); // assignment**
};

Все эти функции компилятор создает за вас.

## Семантика копирования

* По умолчанию конструктор копирования и оператор присваивания реализуют
1. Побитовое копирование и присваивание для встроенных типов и агрегатов
2. Вызов конструктора копирования, если он есть

```cpp
template<typename T> struct Point2D {
  T x_, y_;
  Point2D() : default-init x_, default-init y_ {}
  ~Point2D() {} // does nothing here
  Point2D(const Point2D& other) : x_(other.x_), y_(other.y_) {} // copy ctor
  Point2D& operator=(const Point2D& other) {
    x_ = other.x_; y_ = other.y_; return *this;
  }

};

Зачем *this? Чтобы можно было составлять цепочки a = b = c = d; без копирования

Должны ли мы в таком случае писать copy constructors?
КВ считает, что нет и написание копирующего конструктора должно быть строго обосновано.

* Керниган и Ричи считают, что стоит писать копирующий конструктор в случаях, где класс полностью сам управляет своими ресурсами. В остальных случаях нужно доверить это компилятору.

```cpp

class Buffer {
  int* p;
  public:
  Buffer(int n) : p (new int[n]) {}
  ~Buffer() { delete [] p; }
  // Buffer(const Buffer& rhs) : p(rhs.p)  {}
  // Buffer& operator=(const Buffer& rhs) { p = rhs.p; }
};

В этом случае автоматически сгенерированныйь конструктор скопирует указатель и деструктор удалит указатель обоих объектов сразу.

```

Самое простое что можно сделать в случае, если мы не хотим написать копи конструктор - написать delete этого конструктора. 
Можно написать default, но есть редкие случаи когда нужно его написать. Об этом позже.

## Default и delete

```cpp
class Buffer {
  int* p;
  public:
  Buffer(int n) : p (new int[n]) {}
  ~Buffer() { delete [] p; }
  Buffer(const Buffer& rhs) = delete;
  Buffer& operator=(const Buffer& rhs) = delete;
};

```

если мы попробуем {Buffer  x; Buffer y = x; } -> мы получаем Compilation error

## Реализуем копирование

```cpp

class Buffer {
  int n_; int* p_;
  public:
  Buffer(int n) : n_(n), p_(new int [n]) {}
  ~Buffer() {delete[] p_; }
  Buffer(const Buffer& rhs) : n_(rhs.n_), p_(new int[n_]) {
    std::copy(p_, p_ + n_, rhs.p_);
  }

  Buffer& operator= (const Buffer& rhs) {
    if(this != &rhs) { 
      n_ = rhs.n_;
      delete [] p_;
      p_ = new int [n_];
      std::copy(p_, p_ + n_, rhs.p_);
    }
    return *this;
  }
};

* if(this != &rhs) 
Обязательно сравниваем именно так, потмоу что если у нас совпадают указатели - в этом случае мы можем освободить свою же память.
```
## Специальная семантика копирования и присваивания.

```cpp

#include <iostream>
using std::cout;
using std::endl;

struct foo {
    foo() { cout << "foo::foo()" << endl; }
    foo(const foo& rhs) { cout << "foo::foo(const foo& rhs)" << endl; }
    ~foo() { cout << "foo::~foo()" << endl; }
};

foo bar() {
    foo local_foo;
    return local_foo;
}

int main () {
    foo f = bar(); // here we can see rvo.
    return 0;
}

```

Спец семантика следующая -> объект после копирования эквивалентен тому, который копировали.

То есть в данном случае, в случае RVO может быть выброшен конструктор копирования.

Соответственно, если конструктор копирования это не просто функция, а у неё есть специальное значение, которое компилятор должен соблюдать
Чтобы компилятор расползнал конструктор копирования - у него должна быть одна из форм, предусмотренных стандартом. Основная форма - это константная ссылка.
```cpp
struct Copyable {
  Copyable(const Copyable& rhs);
};
```

Также там может быть значение, неконстантная ссылка или как угодно cv квалифицированные ссылку или значение
cv-квалифицирвоанная:
1. const — объект нельзя изменить (константа).
2. volatile — значение объекта может измениться "неожиданно" (например, из-за аппаратного прерывания или другого потока). 
* Что означает const для объекта? 
const int c = 34; 
<details> значение объекта инициализируется один раз и более неизменно </details>

* Что означает volatile для объекта? 
volatile int v;

<details> обозначает компилятору что значение объекта может измениться например, из-за внешних факторов, таких как аппаратные прерывания, изменения в памяти другим потоком или устройством. Компилятор отключает определенные оптимизации, такие как кэширование значения в регистрах, чтобы гарантировать, что каждое обращение к переменной действительно читает/записывает её значение в памяти., поэтому компилятор не будет применять к нему оптимизации </details>

* Что означает const volatile для объекта? 
const volatile int cv = 42;

<details> Переменная не может меняться через код, но она может измениться под воздействием внешних ресурсов </details>

* что означает const для метода? 
int S::foo() const { return 42; }
<details> 1. метод не может менять значения класса. 2. Метод может быть вызван, если объект const !!!!</details>

* что означает volatile для метода? 
int S::bar() volatile { return 42; }

<details> может быть вызван для volatile объекта </details>

* что означает const volatile для метода? 
int S::buz() const volatile { return 42; }
<details> этот метод может вызван для любого cv объекта </details>

Поскольку в стандартной библиотеке нет нет volatile классов, то мы не можем адекватно создать volatile std::vector<int> v

И вот какая особенность


## Недопустимые формы


```cpp
template <typename T> struct Copyable {
  Copyable(const Copyable& rhs){
    std::cout << "Hello\n"; 
  }
};

Copyable<void> a;
Copyable<void> b{a}; // на экране Hello

Здесь всё нормально. Класс шаблонный. А вот конструктор не шаблонный.

template<typename T> struct Copyable {
  template <typename U> Copyable(const Copyable<U>& c) {
    std::cout << "Hello\n"; 
  }
};

Copyable <void> a;
Copyable <void> b{a}; // на экране ничего.

Конструктор копирования никогда не может быть шаблонным.

```

## Спецсемантика инициализации

```cpp

struct MyString {
  char* buf_; size_t len_;
  MyString(size_t len) : buf_{new char[len]}, len_(len) {}
};

void foo(Mystring);

foo(42); // ok -> MyString implicitly constructed

```
Обычный конструктор определяет неявное преобразование типа. то есть 42 -> MyString(42)

Почти всегда это полезно. Но не всегда. Например со строкой мы не этого хотели. 

Для того чтобы заблокировать пользовательские преобразования, используем explicit
По большей части explicit не юзаем. 
### Direct vs copy
```cpp
struct  Foo {
  explicit Foo(int x) {} // блокирует неявные преобразования
}

Foo f{2}; // direct

Foo f = 2; // FAIL всё в целом логично, мы не можем же 2 привести к Foo без разрешения компилятора
```
В этом случае инициализация похожа больше на вызов функции. 


## Пользовательские преобразования.

```cpp
struct MyString {
  char* buf_; size_t len_;
  /* explicit ? */ operator const char* { return buf_; }  // оператор преобразования из нас в char* заметьте  что этот оператор превращает объект класса в другой тип
}
```

В таком случае мы наверное можем сделать оператор преобразования из FOO в Bar и наоборот.

```cpp
#include <iostream>

struct Foo;
struct Bar;

struct Foo {
  Foo() {}

  Foo(const Bar& ) { std::cout << "ctor Bar -> Foo" << std::endl; }
};

struct Bar {
    Bar () {}
    Bar(const Foo& ) { std::cout << "ctor Foo-> Bar" << std::endl; }
    void print() { std::cout << "Im bar" << std::endl; }
    operator Foo() {
        std::cout << "OP Bar -> Foo" << std::endl;
        return Foo();
    }
};


int main () {
    Bar b;
    Foo c1{b};
    Foo c = b;
}

```

Здесь очень забавный момент, потому что до 17 стандарта приоретет шёл в сторону конструктора, а теперь идёт в сторону оператора преобразования.

## Перегрузка

struct Foo { Foo(long x = 0) {}};

void foo(int x);
void foo(Foo x);
void bar(Foo x);
void bar(...);

long l; foo(l); // вызовет foo(int)

bar(1);

почему так? Пользовательское преобразование всегда проигрывает. От long до  int одно стандартное преобразование. а вот от long до Foo одно пользоватлеьское.

bar(l); вызовет bar(Foo) потому что `...` проигрывает Пользовательскому преобразованию. то есть `...` слабее чем Пользовательскому проеобразованию.

## Операторы присваивания и приведения выглядят непохоже

```cpp

struct Point2D {
  int x_, y_;
  Point2D& operator= (const Point2D& rhs) = default;
  operator int() { return x; }
};

```

В мире конструкторов спецсемантика есть тольбко у копирования и приведения
А в мире переопределенных операторов она есть везде. И она нас ждёт уже на следующей лекции.


# Домашняя работа

Со стандартного ввода приходят ключи(каждый ключ это целое число, все ключи разные) и запрос двух видов

* Запрос (m) на поиск k-го наименьшего элемента
* Запрос (n) на поиск количества элементов меньших чем заданный
* Ввод k 8 k 2 k -1 m 1 m 2 n 3
* Вывод -1 2 2
* Ключи могут быть как угодно перемешаны с запросами. Чтобы успешно пройти тесты, вы должны продумать такую балансировку дерева, чтобы оба вида запросов работали с логарифмической сложностью.

Подсказка. Не использовать std::set(или не полагаться на его методы.) Скорее всего нужно придумать своё дерево.


# Вопросы к лекции:

Раздел 1: Инициализация
* В чем разница между MyClass a; и MyClass a{}; для встроенных типов (int, float) и пользовательских классов?
* Почему myclass_t m(list_t(), list_t()); может не делать то, что ожидается? Как правильно?
* Что такое "двойная инициализация" и как её избежать?
* В каком порядке выполняются инициализации в списке инициализации конструктора?

Раздел 2: Конструкторы
* Когда нужно писать конструктор копирования вручную, а когда можно положиться на сгенерированный?
* В чем проблема с автоматически сгенерированным конструктором копирования для класса Buffer из лекции?
* Как правильно реализовать оператор присваивания с проверкой на самоприсваивание?
* Почему шаблонный конструктор вида template<typename U> MyClass(const U&) не считается конструктором копирования, даже если U = MyClass?
* Какие из этих методов всегда генерируются компилятором для пустого класса, даже если их не объявлять: конструктор по умолчанию, деструктор, конструктор копирования, оператор присваивания?
  
Раздел 3: Специальные методы
* Что делает = default и = delete при объявлении специальных методов?
* Какие методы генерируются компилятором по умолчанию для пустого класса?
* В чем разница между explicit и не-explicit конструкторами?
* Приведите пример использования operator Type() и объясните, когда компилятор будет вызывать это преобразование автоматически, а когда потребуется explicit приведение.?

Раздел 4: Деревья поиска
* Почему рекурсивное удаление в деструкторе Node может быть проблемой?
* Какие два основных инварианта должны соблюдаться в бинарном дереве поиска?
* Как эффективно реализовать запрос "количество элементов в диапазоне [L, R]"?
* Какие проблемы могут возникнуть при агрегатной инициализации Node из лекции, если в будущем добавить private-поле или invariant?

Раздел 5: Продвинутые темы
* Что такое RVO и как оно связано с конструкторами копирования?
* Как const volatile влияет на методы класса?
* В каких случаях пользовательское преобразование типов проигрывает стандартному?
* Почему в операторе присваивания нужно возвращать *this?


Ответы на вопросы:
<details>

Раздел 1: Инициализация
* для встроенных типов - MyClass a; это default инициализация, поля будут инициализированны мусором. MyClass a {} поля будут инициализированы нулями.  Для пользовательских типов будет вызван конструктор по умолчанию.
* Потому что myclass_t m(list_t(), list_t()) может компилятором восприниматься как функция m, принимающая два аргумента типа list_t, потому что с++ если может что-то посчитать за функцию, он будет это делать. для того чтобы избежать можно 1) list_t() поместить в скобки 2) определить переменные list_t до вызова этого метода и 3) myclass_t m{list_t(), list_t()}
* Двойная инициализация это побочный эффект, если не добавить в конструкторе лист инициализации
* В порядке объявления в полях конструктора.

Раздел 2: Конструкторы
* Конструктор копирования стоит почти всегда доверять компилятору за исключением ситуаций, где наш класс самостоятельно работает с ресурсами
* Всё та же проблема - конструктор копирования будет копировать и указатель, а значит - при удалении скопированного объекта - будет удалён и копируемый объект


Раздел 3: Специальные методы
* this == &rhs только, потмоу что в таком случае мы проверяем равен ли себе объект
* Потому что не подходит по спецсемантике, наверное потому что template<typename U> U не гарантированно подходит под cv семантику
* default доверяет написание компилятору. delete запрещает испоьзование

Раздел 4: Деревья поиска
* Потому что не факт что  Node была создана с помощью new. 
* Инвариант поиска и инвариант того, что в левом поддереве элементы всегда меньше чем в правом
* Скорее всего через std::distance? очень тупой ворпос, ты не мог лучше задать?


Раздел 5: Продвинутые темы
* RVO return value optimization. Обходит конструктор копировангия если может, назначая директную инициализацию
* const volatile метод может вызываться для любых объектов что const что volatile
* В любых случаях пользовательские преобразования проигрывают стандартному, если до стандартного одно преобразование.
* Потому что нам нужно выстраивать цепочку

</details>
