#include <iostream>

int foo () { return 42; }

int main() {
  int x;
  int& xref = x;
  const int& fooref = foo(); // cannot bind non const ref to rvalue reference!!!!!!!!!!!!!!!!!

  std::cout << &fooref << " "  << &x << " " << &xref  << std::endl;
}
