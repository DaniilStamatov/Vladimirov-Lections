#include <iostream> 
int& get_number() {
    int x = 42;  // Локальная переменная
    return x;    // ОШИБКА: ссылка на умерший объект
}


int main () {
 
int *p = new int [5];
int & x = p[3];

delete [] p;

x += 1;
std::cout << x << std::endl;

int n = get_number();
std::cout << n << std::endl;
}
