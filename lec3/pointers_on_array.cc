#include <iostream>

int main() {
    int ai[20] = {0};
    int *api[20] = {nullptr};
    int (*pai)[20] = &ai; // pointer to array of 20 ints
    int (&rai)[20] = ai; // reference to array of 20 ints

    std::cout << api << " + 1 = " << api + 1<< std::endl;
    std::cout << pai << " + 1 = " << pai + 1 << std::endl;

    rai[2] = 40;
    (*pai)[2] += 2;

    std::cout << ai[2] << std::endl;
}