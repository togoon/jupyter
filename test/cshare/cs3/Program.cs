#define KK
using System;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using System.Diagnostics;

namespace cs3
{
    [AttributeUsage(AttributeTargets.All, AllowMultiple = true, Inherited = true)]
    public class SomethingAttribute : Attribute
    {
        private string name;
        private string date;
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public string Data
        {
            get { return Data; }
            set { Data = value; }
        }

        public SomethingAttribute(string name)
        {
            this.name = name;
            // this.Data = date;
        }

    }



    public class Myclass
    {
        [Conditional("DEBUG")]
        public static void Message(string msg)
        {
            Console.WriteLine(msg);
        }

        [Conditional("DEBUG")]
        public static void M1(string msg)
        {
            Console.WriteLine(msg);
        }

        [Conditional("DEBUG")]
        public static void M2(string msg)
        {
            Console.WriteLine(msg);
        }

        [Conditional("BUG")]
        public static void M3(string msg)
        {
            Console.WriteLine(msg);
        }

        [Conditional("KK")]
        public static void M4(string msg)
        {
            Console.WriteLine(msg);
        }
    }

    [Something("Amy", Data = "2018-06-18")]
    [Something("Jack", Data = "2018-05-18")]
    class Test { }

    class Program
    {

        static void function1()
        {
            Myclass.Message("In Funciton 1.");
            function2();
        }

        static void function2()
        {
            Myclass.Message("In Function 2.");
        }

        [Obsolete("Don't use OldMethod, NewMethod instead", true)]
        static void OldMethod()
        {
            Console.WriteLine("It is the old method.");
        }

        static void NewMethod()
        {
            Console.WriteLine("It is the new method.");
        }
        static void Main(string[] args)
        {
            Console.WriteLine("Hello AttributeUsage World!");
            Myclass.Message("In Main function.");
            function1();

            // OldMethod();
            NewMethod();

            Myclass.M1("1111");
            Myclass.M2("22222");
            Myclass.M3("33333");
            Myclass.M4("444");



            Type t = typeof(Test);
            var something = t.GetCustomAttributes(typeof(SomethingAttribute), true);
            foreach (SomethingAttribute each in something)
            {
                Console.WriteLine("Name:{0}", each.Name);
                Console.WriteLine("Data:{0}", each.Data);
            }

            Console.ReadKey();
        }
    }

}
