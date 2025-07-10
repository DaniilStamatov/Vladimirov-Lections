#include <iostream>

int main() {
    int ai[20] = {0};
    int *api[20] = {nullptr};
    int (*pai)[20] = &ai;
    int (&rai)[20] = ai;

    std::cout << api << " + 1 = " << api + 1<< std::endl;
    std::cout << pai << " + 1 = " << pai + 1 << std::endl;
}