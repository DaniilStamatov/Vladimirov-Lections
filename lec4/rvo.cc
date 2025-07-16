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

