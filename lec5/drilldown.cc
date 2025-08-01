#include <iostream>
struct Inner {
    int x;
    Inner* operator->() { return this; } // Возвращает указатель на себя
};

struct Wrapper {
    Inner inner;
    Inner operator->() { return inner; } // Возвращает объект Inner (не указатель)
};


struct Out {
    int x;
    Out* operator->() { return this; }
};
struct In {
    Out x;
    Out operator->() {return x; }
};

struct Wrap {
    In inner;
    In operator->() { return inner; }
};


struct client {
    int z;
};

struct proxy1 {
    client* target;
    client* operator->() const {
        return target;
    } 
};

struct proxy2 {
    proxy1* target;
    proxy1& operator->() {
        return *target;
    }
};
int main () {

client x {3};
proxy1 y {&x};
proxy2 y2 {&y};
y2->z = 42;

std::cout << x.z << y->z << y2->z;
}

// y->z = (y.operator())->z
// y2->z = ((y.operator()).operator->())->z

