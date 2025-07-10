#include <cassert>

int main() {
  int x, y;
int& xref = x;
xref = y;
assert(x == y);

int* xptr = &xref;
assert(xptr == &x);

//int&* xptrref = &xref;
int *& xrefptr = xptr;
return 0;
}
