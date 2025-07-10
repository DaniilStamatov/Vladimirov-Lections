#include <cassert>
int main () {
  int z;
  int &y = z;
  assert(y == z);
  int x[2] = {10, 20};
int& xref = x[1];
int* xptr =&x[0];
xref += 1;
xptr += 1;

assert(x[1] == 21);
assert(*xptr == 21);
assert(xptr == &x[1]);

  return 0;
}
