#include <set>
#include <string>
#include <iostream>
template <typename C, typename T>
int range_query(const C& s, T first, T second) {
  using it = typename C::iterator;
  it start = s.lower_bound(first);
  it end = s.upper_bound(second);
  return std::distance(start, end);
}
int main () {
    std::set<int> tree;
    std::string cmd;
    int a, b;
    while(std::cin >> cmd) {
        if(cmd == "k") {
            std::cin >> a;
            tree.insert(a);
        }
        else if (cmd == "q") {
            std::cin >> a >> b;
            int dist = range_query(tree, a, b);
            std::cout << dist << std::endl;
        }
    }
}