// struct X {
//   int smth = 42;
// };

// int foo(int cond) {
//     switch(cond){ 
//         case 0: X x;
//         case 1: return x.smth; // 42? no. compilation error.
//     }
// }
#include <vector>
using std::vector;
class X {
 vector<char> data_;

 public:
 X() = default;
 vector<char> const & data() const & { return data_; }
 vector<char>&& data() && { return std::move(data_); }
};


X obj;
vector<char> a = obj.data(); // copy
const auto& x = obj.data();
auto& z = obj.data();
vector<char>& y = obj.data();
const vector<char>& s = obj.data();
vector<char> b = X().data(); // move