#include <iostream>
template<typename T>
class ScopedPointer{
    T* ptr_;
    public:
        ScopedPointer(T* ptr = nullptr ) : ptr_(ptr) {}

        ScopedPointer(const ScopedPointer& rhs) {
            if (rhs.ptr_) {
                ptr_ = new T(*rhs.ptr_); 
            } else {
                ptr_ = nullptr;
            }
            std::cout << "Copy\n";
        }

        ScopedPointer(ScopedPointer&& rhs) noexcept : ptr_(rhs.ptr_) {
            rhs.ptr_ = nullptr;
            std::cout << "Move" << std::endl;
        }

        ~ScopedPointer() {
            delete ptr_;
        }

};

int main () {
   const ScopedPointer<int> y{new int(10)};
   auto b{y};
   auto z = std::move(y);
}
