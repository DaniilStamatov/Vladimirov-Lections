

## 📘 Оглавление
- [Context and Encapsulation](#context-and-encapsulation)
- [`malloc` vs `new` — Object Lifetime](#malloc-vs-new--object-lifetime)
- [`new` and `new[]`](#new-and-new)
  - [How `new[]` Works Internally](#how-new-works-internally)
- [Object Lifetime](#object-lifetime)
  - [Temporary object lives to the end of fully statement](#temporary-object-lives-to-the-end-of-fully-statement)
  - [DONT use member of class or struct unless you exactly know what you are doing](#dont-use-member-of-class-or-struct-unless-you-exactly-know-what-you-are-doing)
- [Literal is always rvalue](#literal-is-always-rvalue)
- [Decaying](#decaying)
- [Lvalue \& rvalue](#lvalue--rvalue)
  - [Is it right for C++?](#is-it-right-for-c)
  - [Sleeping test](#sleeping-test)
- [CDECL](#cdecl)
    - [Alternative to typedef : using](#alternative-to-typedef--using)
- [BOOOKS](#boooks)
- [MANGLING](#mangling)
  - [Discussion](#discussion)
  - [Resolving overloadings](#resolving-overloadings)
  - [Rules of resolving overloadings](#rules-of-resolving-overloadings)
  - [Constructor overloading](#constructor-overloading)
  - [Shortly about namespaces](#shortly-about-namespaces)
  - [meanings of "using" keyword](#meanings-of-using-keyword)
    - [anonimous namespaces](#anonimous-namespaces)
- [Tone of voice](#tone-of-voice)
  - [Correct Hello, world!](#correct-hello-world)

# Context and Encapsulation

1. Module  
2. Class/Struct  
3. Function  
4. Private member

**Context can encapsulate data within itself.**

Examples:

- A `static` variable inside a function is **not visible** to anything outside this function.
- A variable local to a module (especially if `static`) is **not accessible** outside the module.
- A `private` member of a class is **not accessible** outside that class.

> 🔒 "Visible" here means "accessible by name." Technically, in C++ we can still access memory directly (due to linear memory model), but it's unsafe and not recommended.

**Encapsulation (concealment)** is a mechanism of abstraction.  
It's used to **maintain invariants** — i.e., to ensure the internal state of an object remains valid throughout its lifetime.

> ⚠️ If an invariant is violated, it may lead to **undefined behavior (UB).**

---

# `malloc` vs `new` — Object Lifetime

`malloc` and `free` do **not** know anything about constructors or destructors.  
So when you allocate memory with `malloc`, the object is created in an **inconsistent state**:

- The object's lifetime has begun.
- But its fields are uninitialized or "stateless."

In contrast, **C++ provides the `new` and `delete` keywords** for object creation and destruction.

---

# `new` and `new[]`

There are two types of `new` in C++:

1. `new T` — creates a single object  
2. `new T[]` — creates an array of objects

## How `new[]` Works Internally

When allocating an array with `new[]`, the compiler typically allocates **a little extra memory** to store the number of elements.  
This number is used later by `delete[]` to know **how many destructors to call**.

Example:
```cpp
int* t = new Widget[5]; // 5 constructors called
delete[] t;             // 5 destructors called


#include <iostream>

struct MySmallClass {
  int t = 1;
  MySmallClass() { std::cout << "small ctor" << std::endl; }
  ~MySmallClass() { std::cout << "small dtor" << std::endl; }
};

struct MyBigClass {
  int t = 1, p = 2, q = 3;
  MyBigClass() { std::cout << "big ctor" << std::endl; }
  ~MyBigClass() { std::cout << "big dtor" << std::endl; }
};

int main () {
  MyBigClass* S = new MyBigClass;
  MySmallClass* s = new MySmallClass;
  MyBigClass* pS = new MyBigClass[5];
  MySmallClass* ps = new MySmallClass[5];

  delete[] s; // ❌ TERRIBLY WRONG!
}
```
# Object Lifetime

<details>
  <summary> Press to see code examples </summary>
The lifetime of a variable is the time during which its state is valid.
```cpp
int main() {
  int a = a; // ❌ UB — a is declared but uninitialized!
}
```

```cpp
int a = 2;

void foo () {
  int b = a + 3;
  int* pc;

  if (b > 5) {
    int c = (a + b) / 2;
    pc = &c; // c goes out of scope here — pointer pc becomes dangling!
  }

  b += *pc; // ❌ UB — using a dangling pointer!
}
```
```cpp
int* p = new int[5];
int& x = p[3];
delete[] p;
x += 1; // ❌ UB — using a reference to a deleted object!

```
```cpp
int& foo() {
  int x = 42;
  return x; // ❌ returning reference to local variable — UB
}

int x = foo(); // x refers to expired object
```
</details>

## Temporary object lives to the end of fully statement

```cpp
struct S {
  int x;
  const int &y;
};
int main () {
S x{1, 2}; // ok! lifetime extended not temporary but permanent object

S *p  = new S{1, 2}; // ⚠️ this is a late parrot! because S(on the right) is a temporary object

const int& i = 2;
// So in this case 
// int __temp = 2; 
// S x;
// x.x = 1;
// x.y = __temp; 
}

```
## DONT use member of class or struct unless you exactly know what you are doing

```cpp

int foo(int &x); 
foo(1); // ❌  compilation error //Non-const lvalue reference to type 'int' cannot bind to a temporary of type 'int'c

int& x = 1; // ❌ Non-const lvalue reference to type 'int' cannot bind to a temporary of type 'int'c

```

# Literal is always rvalue

# Decaying
```cpp
int foo ( const int& t) {
  return t;
}
```
Reference to an object in expressions acts like an object itself!
We met something like this before
``` cpp
void foo(int *);
int arr[5];
int *t = arr + 3; // ok (arr acts like rvalue)
foo(arr); // ok
arr = t; // ❌  fail (arr acts like lvalue!)
```

# Lvalue & rvalue

In c lang lvalue meant left-hand-side value
```cpp
y = x;
//here y is lvalue x rvalue
```

## Is it right for C++? 

```cpp 
int& foo();
foo() = x; // ok!!! 
```

In C++ lvalue is more like "location value"

In c++11 there is glvalue(later on our lectures)

## Sleeping test

```cpp 
int* x[20];  // x here is array of 20 pointers on int
int(*y)[20]; // y is pointer on array (*y) go right nothing, go left pointer, go up, go right on array
```

What is the difference? 

```cpp
#include <iostream>

int main() {
    int ai[20] = {0};
    int *api[20] = {nullptr};
    int (*pai)[20] = &ai; // pointer to array of 20 ints
    int (&rai)[20] = ai; // reference to array of 20 ints
    int (&prai)[20] = *pai; // reference to an array of 20 ints that has been created by dereferencing a pointer to an array of 20 ints
    std::cout << api << " + 1 = " << api + 1<< std::endl;
    std::cout << pai << " + 1 = " << pai + 1 << std::endl;

    rai[2] = 40;
    (*pai)[2] += 2;

    std::cout << "ai[2]: " << ai[2] << std::endl;
    std::cout << "ai[2]: " << prai[2] << std::endl;
}
output
0x7ffffaf67c20 + 1 = 0x7ffffaf67c28 // sizeof(int*)
0x7ffffaf67bd0 + 1 = 0x7ffffaf67c20 // 20 * sizeof(int)
ai[2]: 42
```


# CDECL
```cpp
char *(*(&c)[10])(int *&p); // reference to an array on 10 pointers on a function that takes reference to pointer and returning pointer to char
void (*bar(int x, void (*func)(int&))) (int&); 

typedef void (*ptr_to_fref)(int&);
ptr_to_fref bar(int x, ptr_to_fref func);

same as

using ptr_to_fref = void(*)(int&);
ptr_to_fref bar(int x, ptr_to_fref func);
```

### Alternative to typedef : using

using ptr_to_fref = void (*) (int&);
template<typename T> 
using ptr_to_fref = void (*) (T&);

we get here later on but now we discuss literature:

# BOOOKS

1. [CC11] ISO/IEC 14882 - "Information technology - Programming languages - C++" , 2011
2. [BS] Bjarne Stroustrup - The C++ Programming Language (4th Edition), 2014
3. [GB] Grady Booch - Object-Oriented Analysis and Design with applications, 2007 
4. [GCT] Eberly, Schneider - Geometric Tools for Computer Graphics, 2002
5. [GS] Gilbert Strang - Introduction to Linead Algebra, Fifth Edition, 2016
6. [BB] Ben Saks - Back to Basics: Pointers and Memory, CppCon, 2020


# MANGLING
In C Language when we create a name we give the guarantie on the names. It means that we cannot overload functions
* Mangling is the process of transformation a name in assembler to provide unique name of variable *

So C++ does not give guaranties to the names except cases of extern "C" so it will be the same as C style

C language gives 2 guaranties. 1st is about names and 2nd is that in c there is nothing implicit

BUT this 2 guaranties cant provide us overloding. Or give methods of class.

If we take C and remove from it guarantie to the names and adding anything that we get from removing it -> we get C++ 

```cpp

struct S {
int foo(int) __attribute((noinline));  
};

int foo(S*p, int x) {return p->foo(x); } // _Z3fooP1Si
int foo(int x) {{return x;}} // _Z3fooi

int S::foo(int x) {return x;} // _ZN1S3fooEi
extern "C" int bar(int x) {return x;}// WE CANT OVERLOAD FOO
```

## Discussion
```cpp
extern "C" template <typename T> void foo(T x); // cant do cause have no templates
struct S { extern "C" void foo();} // cant do because of S is struct and contains invisible (this) in the point of instansing
```

## Resolving overloadings

float sqrt(float x);
double sqrt(double x);

after parsing we get name resolution. And this process is interesting;

What do we get when:
sqrt(42); 
What function will it choose? 

<details>
  <summary>Press to get answer</summary>

  It will lead to a compilation error, because `int` is equally far away from `float` and `double`.  
  (Especially since there's one implicit cast needed to either `float` or `double`.)
</details>

## Rules of resolving overloadings
1. Exact match (int -> int, int -> const int&, etc)
2. Exact match with template( int -> T)
3. Standard transformations ( int -> char, float -> unsigned short, etc)
4. Variable count of arguments
5. Wrong bounded references(literal -> int&, etc)
   
We will return to it later

<details>
<summary> Click to see the code </summary>

```cpp
#include <iostream>
//
// Example of overload 
// Compile with g++ overload.cc -DN1 ... -DN15
// (example) g++ overload.cc -DN0 -DN1 -DN10 -DN11 -DN12 -DN2 
//
#ifndef N0
int foo(int x) { return 0;}
#endif

#ifndef N1
int foo(const int& x) { return 1;}
#endif

#ifndef N2
template <typename T> T foo(T x) {return x;}
#endif

#ifndef N10
int foo(char x){ return 10;}
#endif

#ifndef N11
int foo(short x) { return 11; }
#endif

#ifndef N12
int foo(const char& x) {return 12; }
#endif

#ifndef N13
int foo(double x) { return 13; }
#endif

#ifndef N14
int foo(...) {return 21;}
#endif

#ifndef N15
int foo (int& x) { return 31; }
#endif 

int main () {
    std::cout << "result : " << foo(10) << std::endl;
}
```
g++ overload.cc -DN0 -DN1 -DN10 -DN11 -DN12 -DN2 -DN13 -DN15 -DN14
Leads to compilation error
</details>

## Constructor overloading
class line_t { 
  float a_ = -1.0f, b_ = 1.0f, c_ = 0.0f;

  public:
    line_t() {} // default

    line_t(const point_t& p1, const point_t& p2); // from two points

    line_t(float a, float b, float c); // params 
};

## Shortly about namespaces

int x;

int foo() {
  return ::x; // global namespace
}


namespace Containers {
  struct List {
    struct Node{

    };
  };
}


Containers::List::Node n;

We need namespaces to ensure that Containers is not a type!

IF IN OUR PROGRAM THERE IS NO OBJECT OF TYPE -> THERE IS NO TYPE!

namespace X {
  int foo();
}

namespace Y {
  int foo();
}

using std::vector;

using namespace X;

vector<int> v;
v.push_back(foo());
Mangling sucess;


## meanings of "using" keyword

1. adds alias to the type
2. adds name to the current namespace // using std::vector -> now it is vector in our namespace
3. take all namespace (using namespace X)


### anonimous namespaces

namespace {
  int foo() {
    return 42;
  }
}

int bar { return foo() ;}
so it means * Create namespace with complex name and instantly make using namespace *

Why we need it ? For swapping static functions. it helps us to incapsulate in module. because no one can use extern


# Tone of voice
* Do not put garbage in std namespace
* never writing using namespace in header files
* use anonimous namespaces instead static functions
* do not use anonimous namespaces in header files (because anonimous namespace is unique for translation unit)

## Correct Hello, world!

<details>
<summary> Click to see this magic </summary>

```cpp

#include <iostream>

namespace {
  const char* const helloworld = "Hello, World!";
}

int main {
  std::cout << helloworld << "\n";
}
```

</details>