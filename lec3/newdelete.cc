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

  delete[] s; // terybly wrong!!!!!
}

