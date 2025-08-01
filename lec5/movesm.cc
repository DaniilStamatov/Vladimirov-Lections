#include <iostream>

int main () {
    int x = 4;
    int &&y = x + 1;
    
    std::cout << &x << " " << &y << std::endl;
    std::cout << x << " " << y << std::endl;

    int &&z = std::move(x);
    int& i = x;
    z = z + 1;
    i = i + 1;
    y = y + 1;
    std::cout << z << std::endl;
    std::cout << x << " " << i << " " << y << std::endl;
}