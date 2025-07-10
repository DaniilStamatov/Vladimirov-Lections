
struct S {
int foo(int) __attribute((noinline));  
};

int foo(S*p, int x) {return p->foo(x); } // _Z3fooP1Si
int foo(int x) {{return x;}} // _Z3fooi

int S::foo(int x) {return x;} // _ZN1S3fooEi
extern "C" int bar(int x) {return x;}// WE CANT OVERLOAD FOO