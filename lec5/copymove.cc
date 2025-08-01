#include <iostream>
class HeavyObject {
    public:
    HeavyObject(int data) : data_(data) {std::cout << "Default" << '\n';}
    HeavyObject(const HeavyObject& rhs) : data_(rhs.data_) {
        std::cout << "Copy" << '\n';
    }
    HeavyObject(HeavyObject&& rhs) : data_(rhs.data_) {
        std::cout << "Move" << '\n';
    }
private:
    int data_;
};


void GetDo(HeavyObject&& obj) {
    auto temp = std::move(obj);
    
}
int main () {
    GetDo(1);
    return 0;
}


