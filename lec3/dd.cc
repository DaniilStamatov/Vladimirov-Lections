#include <iostream> 

int main () {
struct S {
  int x;
  const int &y;
};

S x{1, 2}; 

S *p  = new S{1, 2};

std::cout << p->x << p->y << std::endl;

const int& i = 2;

std::cout << i << std::endl;

struct Y {
  const int& y;
};

Y s{2}; 
Y *sp = new Y{2};
std::cout << s.y << std::endl;

int foo(int &x); 
foo(1); // compilation error

int& x = 1;
}
