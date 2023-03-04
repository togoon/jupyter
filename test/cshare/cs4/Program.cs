using System;

namespace cs4
{

    [AttributeUsage(AttributeTargets.All)]
    public class HelpAttribute : System.Attribute
    {
        public readonly string Url;
        public string Topic
        {
            get { return Topic; }
            set { Topic = value; }

        }

        public HelpAttribute(string url)
        {
            this.Url = url;
        }

        private string topic;
    }

    [HelpAttribute("Infomation on the class MyClass")]
    class MyClass
    {

    }


    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello Reflect World!");

            System.Reflection.MemberInfo info = typeof(MyClass);
            object[] attribute = info.GetCustomAttributes(true);
            for (int i = 0; i < attribute.Length; i++)
            {
                System.Console.WriteLine(attribute[i]);
            }

            Console.ReadKey();
        }
    }
}
