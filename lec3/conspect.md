
# Context and Encapsulation

**Context** is a scope that can encapsulate data. It can be:

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
## Object Lifetime

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

## Temporary object lives to the end of fully statement

```cpp
struct S {
  int x;
  const int &y;
};
int main () {
S x{1, 2}; // ok! lifetime extended not temporary but permanent object

S *p  = new S{1, 2}; // this is a late parrot! because S(on the right) is a temporary object

const int& i = 2;
// So in this case 
// int __temp = 2; 
// S x;
// x.x = 1;
// x.y = __temp; 
}

```
# DONT use member of class or struct unless you exactly know what you are doing

```cpp

int foo(int &x); 
foo(1); // compilation error //Non-const lvalue reference to type 'int' cannot bind to a temporary of type 'int'c

int& x = 1; //Non-const lvalue reference to type 'int' cannot bind to a temporary of type 'int'c

```

## Literal is always rvalue

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
arr = t; // fail (arr acts like lvalue!)
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

