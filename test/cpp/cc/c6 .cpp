#include <iostream>
#include <iomanip>
#include <string>
 
int main()
{
   std::string str;
   str.reserve(50); // 预留足够的存储空间以避免内存分配
   std::cout << std::quoted(str) << '\n'; // 空字符串
 
   str += "This";
   std::cout << std::quoted(str) << '\n';
 
   str += std::string(" is ");
   std::cout << std::quoted(str) << '\n';
 
   str += 'a';
   std::cout << std::quoted(str) << '\n';
 
   str += {' ','s','t','r','i','n','g','.'};
   std::cout << std::quoted(str) << '\n';
 
   str += 76.85; // 等价于 str += static_cast<char>(76.85) ，可能不合意图
   std::cout << std::quoted(str) << '\n';
}
 
