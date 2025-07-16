#include <iostream>

struct Foo;
struct Bar;

struct Foo {
  Foo() {}

  //Foo(const Bar& ) { std::cout << "ctor Bar -> Foo" << std::endl; }
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