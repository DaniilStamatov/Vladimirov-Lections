#include <iostream>
struct list_t {};

struct myclass_t {
    int x = 42;
    myclass_t(list_t, list_t) {}
};

int main () {
    myclass_t n(list_t(), list_t()); 
    myclass_t m{list_t(), list_t()};

    std::cout << n.x << std::endl;
    std::cout << m.x << std::endl;
}