using System;

namespace cs1
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            Console.WriteLine("\nWhat is your name?");
            var name = Console.ReadLine();
            Console.WriteLine($"\nHello {name}!");
        }
    }
}
