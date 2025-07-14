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

Сколько занимает в памяти пустой класс? <details> 0 байт </details>
что мы можем сделать с объектом этого класса? 