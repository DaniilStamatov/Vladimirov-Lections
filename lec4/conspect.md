# Inicialization and copy

## 📘 Оглавление
- [Inicialization and copy](#inicialization-and-copy)
  - [📘 Оглавление](#-оглавление)
  - [Binary search tree](#binary-search-tree)
    - [Range queries](#range-queries)

## Binary search tree

Properties of binary search tree:
1. Any element of the right subtree is **greater** than any element in the left subtree.
2. Any key can be found from the root of the tree in time proportional to the tree’s height.
3. In the best case, a tree with **N** elements will have height of **logN**.
4. With the same set of elements all of the search operations are saving its **inorder** pass as sorted.

Why do we need search trees? 
* We can find any key by simply going left or right, comparing keys at each step..

### Range queries

**Task**
* Let the input consist of keys **(each key is an integer, and all keys are unique)**  
* TODO: For each query, return the number of keys strictly between the given left and right bounds.
* **Input**: k 10 k 20 q 8 31 q 6 9 k 30 k 40 q 15 40
* **Result**: 2 0 3

How could you solve this problem?
Use std::set to complete this task

<details>
<summary> Click to see the solution </summary>

```cpp

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
```
</details>