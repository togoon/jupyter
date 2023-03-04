import java.util.ArrayList;
import java.util.List;

class Employee{
   // 这个实例变量对子类可见
   public String name;
   // 私有变量，仅在该类可见
   private double salary;
   //在构造器中对name赋值
   public Employee (String empName){
      name = empName;
   }
   //设定salary的值
   public void setSalary(double empSal){
      salary = empSal;
   }  
   // 打印信息
   public void printEmp(){
      System.out.println("名字 : " + name );
      System.out.println("薪水 : " + salary);
   }
 
   // public static void main(String[] args){
   //    Employee empOne = new Employee("RUNOOB");
   //    empOne.setSalary(1000.0);
   //    empOne.printEmp();
   // }
}



public class Puppy{
   int puppyAge;
   static int allClicks=0;
   String str = "Hello Java World";
   public Puppy(String name){
      // 这个构造器仅有一个参数：name
      System.out.println("小狗的名字是 : " + name ); 


   }
 
   public void setAge( int age ){
       puppyAge = age;
   }
 
   public int getAge( ){
       System.out.println("小狗的年龄为 : " + puppyAge ); 
       return puppyAge;
   }
  

   static boolean bool;
   static byte by;
   static char ch;
   static double dl;
   static float fl;
   static int in;
   static long lo;
   static short sh;
   static String stri;

   public static void main(String[] args){
      /* 创建对象 */
      Puppy myPuppy = new Puppy( "tommy" );
      /* 通过方法来设定age */
      myPuppy.setAge( 2 );
      /* 调用另一个方法获取age */
      myPuppy.getAge( );
      /*你也可以像下面这样访问成员变量 */
      System.out.println("var : " + myPuppy.puppyAge ); 
      System.out.println("str : " + myPuppy.str ); 
      
      int a, b, c;
      int d0 = 3, e = 4, f0 = 5;
      byte z = 22;
      String s = "runoob";
      double pi = 3.14159;
      char x = 'X';

      System.out.println(" d0 : " + d0 + ", e : " + e +", f0 : " + f0 +", \n z : " + z +", s : " + s +", x : " + x +", pi : " + pi  ); 

      Employee empOne = new Employee("RUNOOB");
      empOne.setSalary(1000.0);
      empOne.printEmp();

      byte b1 = 100,  b2 = -50;
      System.out.println( b1 + b2);

      short s1 = 1000,  s2 = -20000;
      System.out.println(s1 - s2);

      int i1 = 10000, i2 = -200000;
      System.out.println(i1 - i2);

      float f1 = 234.5f;
      System.out.println(f1);

      double d1  = 7D ;
      double d2  = 7.; 
      double d3  =  8.0; 
      double d4  =  8.D; 
      double d5  =  12.9867; 

      System.out.println(" d1 : " + d1 + ", d2 : " + d2 +", d3 : " + d3 +", \n d4 : " + d4 +", d5 : " + d5   ); 

      boolean bo1 = true;
      System.out.println(bo1);

      char c1 = 'A';
      System.out.println(c1);

        // byte  
      System.out.println("基本类型：byte 二进制位数：" + Byte.SIZE);  
      System.out.println("包装类：java.lang.Byte");  
      System.out.println("最小值：Byte.MIN_VALUE=" + Byte.MIN_VALUE);  
      System.out.println("最大值：Byte.MAX_VALUE=" + Byte.MAX_VALUE);  
      System.out.println();  

      // short  
      System.out.println("基本类型：short 二进制位数：" + Short.SIZE);  
      System.out.println("包装类：java.lang.Short");  
      System.out.println("最小值：Short.MIN_VALUE=" + Short.MIN_VALUE);  
      System.out.println("最大值：Short.MAX_VALUE=" + Short.MAX_VALUE);  
      System.out.println();  

      // int  
      System.out.println("基本类型：int 二进制位数：" + Integer.SIZE);  
      System.out.println("包装类：java.lang.Integer");  
      System.out.println("最小值：Integer.MIN_VALUE=" + Integer.MIN_VALUE);  
      System.out.println("最大值：Integer.MAX_VALUE=" + Integer.MAX_VALUE);  
      System.out.println();  

      // long  
      System.out.println("基本类型：long 二进制位数：" + Long.SIZE);  
      System.out.println("包装类：java.lang.Long");  
      System.out.println("最小值：Long.MIN_VALUE=" + Long.MIN_VALUE);  
      System.out.println("最大值：Long.MAX_VALUE=" + Long.MAX_VALUE);  
      System.out.println();  

      // float  
      System.out.println("基本类型：float 二进制位数：" + Float.SIZE);  
      System.out.println("包装类：java.lang.Float");  
      System.out.println("最小值：Float.MIN_VALUE=" + Float.MIN_VALUE);  
      System.out.println("最大值：Float.MAX_VALUE=" + Float.MAX_VALUE);  
      System.out.println();  

      // double  
      System.out.println("基本类型：double 二进制位数：" + Double.SIZE);  
      System.out.println("包装类：java.lang.Double");  
      System.out.println("最小值：Double.MIN_VALUE=" + Double.MIN_VALUE);  
      System.out.println("最大值：Double.MAX_VALUE=" + Double.MAX_VALUE);  
      System.out.println();  

      // char  
      System.out.println("基本类型：char 二进制位数：" + Character.SIZE);  
      System.out.println("包装类：java.lang.Character");  
      // 以数值形式而不是字符形式将Character.MIN_VALUE输出到控制台  
      System.out.println("最小值：Character.MIN_VALUE=" + (int) Character.MIN_VALUE);  
      // 以数值形式而不是字符形式将Character.MAX_VALUE输出到控制台  
      System.out.println("最大值：Character.MAX_VALUE=" + (int) Character.MAX_VALUE);  

      System.out.println("Bool :" + bool);
      System.out.println("Byte :" + by);
      System.out.println("Character:" + ch);
      System.out.println("Double :" + dl);
      System.out.println("Float :" + fl);
      System.out.println("Integer :" + in);
      System.out.println("Long :" + lo);
      System.out.println("Short :" + sh);
      System.out.println("String :" + stri);

      final double PI = 3.1415927;
      System.out.println("PI :" + PI);

      byte ba = 68;
      char ca = 'A';
      System.out.println("ba :" + ba);
      System.out.println("ca :" + ca);

      int decimal = 100;
      int octal = 0144;
      int hexa =  0x64;      
      System.out.println("decimal :" + decimal);
      System.out.println("octal :" + octal);
      System.out.println("hexa :" + hexa);

      char ua = '\u6101';
      String ub = "\u5801";
      System.out.println("ua :" + ua);
      System.out.println("ub :" + ub);

      char c7='a';//定义一个char类型
      int i7 = c7;//char自动类型转换为int
      System.out.println("char自动类型转换为int后的值等于 : "+i7);
      char c8 = 'A';//定义一个char类型
      int i8 = c8+1;//char 类型和 int 类型计算
      System.out.println("char类型和int计算后的值等于 : "+i8);

      int i9 = 123;
      byte b9 = (byte)i9;//强制类型转换为byte
      System.out.println("int强制类型转换为byte后的值等于 : " + b9);

      System.out.print("\n");

      int x1 = 10;
      while (x1 < 20) {
         System.out.print("value of x1 : " + x1);
         x1++;
         System.out.print("\n");
      }

      System.out.print("\n");

      do {
         System.out.print("value of x1 : " + x1 );
         x1++;
         System.out.print("\n");
      } while( x1 < 25 );      

      for (int x2 = 25; x2 < 30; x2 = x2 + 1) {
         System.out.print("value of x2 : " + x2);
         System.out.print("\n");
      }
 
      System.out.print("\n");

      int [] numbers = {10, 20, 30, 40, 50};

      for (int x3 : numbers) {

         if (x3 == 30) {
            continue;
         }

         if (x3 == 50) {
            break;
         }

         System.out.print(x3);
         System.out.print(",\t");
      }
      
      System.out.print("\n");
      String [] names ={"James", "Larry", "Tom", "Lacy"};
      for (String name : names) {
         System.out.print(name);
         System.out.print(",\t");
      }
      System.out.print("\n\n");

      for(int i=1; i<=3; i++){
         for(int n=1; n<=3; n++){
            //输出结果。。。。
            System.out.println("i = " + i + ", n = " + n);
         }
      }

      System.out.print("\n");

      for (int i = 1; i <= 9; i++) {
         for (int j = 1; j <= i; j++) {
            System.out.print(j + "*" + i + "=" + i * j + " ");
         }
         System.out.println();
      }
      
      System.out.print("\n");

      for(int i = 1;i < 6; i ++) //外循环控制行数，共打印五行
      {
         //左边打印倒直角三角形空格
         for (int j = 5; j > i; j--) //与外循环关联，初始值不变，表达式变化，控制打印的列数
         {
            System.out.print(" ");
         }
         //右边等腰三角形
         for (int q = 1; q < i * 2; q++) //与外循环关联，初始值不变，表达式变化，打印奇数列1，3，5，7，9
         {
            System.out.print("*");
         }
         System.out.println(); //换行
      }
      
      //打印菱形的下半部分，左边为直角三角形的空格，右边为倒的等腰三角形
      for(int i = 1; i < 5; i++) //外循环控制行数，共打印四行
      {
         //左边直角三角形空格
         for (int j = 1; j <= i; j++) { //与外循环关联，初始值不变，表达式变化，共打印五行
            System.out.print(" ");
         }
         //右边倒直角三角形
         for (int q = i * 2; q < 9; q++) { //与外循环关联，初始值变化，表达式不变，打印奇数列7，5，3，1
            System.out.print("*");
         }
         System.out.println(); //换行
      }
      
      System.out.print("\n");

      for(int i = 0; i < 10; i++){
         for(int j = 0; j < 10; j++){
            System.out.print("" + i + j +"  ");
         }
         System.out.println("\n-------------------------------------- \n");
      }
      System.out.println("输出完毕！\n");

      for(int i = 0; i < 10; i++){
         for(int j = 0; j < 10; j++){
            if(i * 10 + j > 29){
               break;
            }
            System.out.print("" + i + j +"  ");
         }
         System.out.println("\n-------------------------------------- \n");
      }
      System.out.println("输出完毕！\n");


      lable:
      for(int i = 0; i < 10; i++){
         for(int j = 0; j < 10; j++){
            if(i * 10 + j > 29){
               break lable;
            }
            System.out.print("" + i + j +"  ");
         }
         System.out.println("\n-------------------------------------- \n");
      }
      System.out.println("输出完毕！\n");

      // 方法一
      int sum1=1;
      for(int i=9;i>=1;i--){
         sum1=(sum1+1)*2;
      }        
      System.out.println("sum1=" + sum1);
      
      // 方法二
      int sum2=1;
      for (int i=1;i<=9;i++){
         sum2=(sum2+1)*2;            
      }
      System.out.println("sum2=" + sum2);
      
      System.out.println("\n");

      int x5 = 30;
      if( x5 < 20 ){
         System.out.print("这是 if 语句\n");
      } else if( x5 == 30 ){
         System.out.print("Value of X is 30");
      } else {
         System.out.print("这是 else 语句");
      }

      System.out.println("\n");


      char grade = 'C';
      System.out.println("你的等级是: " + grade);

      switch(grade)
      {
         case 'A' :
            System.out.println("优秀"); 
            break;
         case 'B' :
         case 'C' :
            System.out.println("良好");
            break;
         case 'D' :
            System.out.println("及格");
            break;
         case 'F' :
            System.out.println("再努力努力");
            break;
         default :
            System.out.println("未知等级");
      }

      System.out.println("\n");

      Integer x6 = 500;
      x6 = x6 + 10;

      Integer x7 = 510;

      System.out.println("Integer: x6 = " + x6 + "\n");
      System.out.println(x6==x7);
      System.out.println(x6.equals(x7)); 

      System.out.println("\n");

      System.out.println("90 度的正弦值：" + Math.sin(Math.PI/2));  
      System.out.println("0度的余弦值：" + Math.cos(0));  
      System.out.println("60度的正切值：" + Math.tan(Math.PI/3));  
      System.out.println("1的反正切值： " + Math.atan(1));  
      System.out.println("π/2的角度值：" + Math.toDegrees(Math.PI/2));  
      System.out.println(Math.PI);

      System.out.println("\n");

      double[] nums = { 1.4, 1.5, 1.6, -1.4, -1.5, -1.6 };   
      for (double num : nums) {
         System.out.println("Math.floor( " + num + " ) = " + Math.floor(num));
         System.out.println("Math.round( " + num + " ) = " + Math.round(num));
         System.out.println("Math.ceil( " + num + " ) = " + Math.ceil(num));
      }
      
      System.out.println("\n");

      System.out.println("访问\"java教程，字符串!\"\n");

      char ch1 = 'a';
      char uniChar = '\u039A'; 
      char[] charArray ={ '?', 'b', 'c', 'd', 'e' };
      Character ch2 = new Character('0');

      System.out.println(Character.isLetter(ch1));
      System.out.println(Character.isLetter(uniChar));
      System.out.println(Character.isLetter(charArray[0]));
      System.out.println(Character.isLetter(ch2));
      System.out.println(Character.isLetter(' '));
      System.out.println(Character.isLetter('5'));            

      String StrA="I am Tom.I am from China.";
      String StrB="";
      String StrC="";
      for(int i=0;i<StrA.length();i++){
         if(Character.isUpperCase(StrA.charAt(i)))
            StrB +=StrA.charAt(i)+"  ";
         if(Character.isLowerCase(StrA.charAt(i)))
            StrC +=StrA.charAt(i)+"  ";
      }
      System.out.println("字符串中大写字母有："+StrB);
      System.out.println("字符串中小写字母有："+StrC ) ;

      char[] helloArray = { 'h', 'e', 'l', 'l', 'o', '!'};
      String helloString = new String(helloArray);  
      System.out.println(helloString);

      System.out.println( "字符串长度 : " + helloString.length() );
      System.out.println("1、" + helloString + StrB.concat(StrC) ); 

      System.out.println("\n");

      String Strary[] = { "First", "Second", "Third" };
      String Stra1 = "Hello Java World";
      List<String> list = new ArrayList<String>();
      list.add(Stra1);
      System.out.println("数组Strary的长度为 : " + Strary.length);
      System.out.println("字符串Stra1的长度为 : " + Stra1.length());
      System.out.println("list中元素个数为 : " + list.size());

      System.out.println("\n");

      System.out.println(String.format("%1$,09d", -3123));
      System.out.println(String.format("%1$9d", -31));
      System.out.println(String.format("%1$-9d", -31));
      System.out.println(String.format("%1$(9d", -31));
      System.out.println(String.format("%1$#9x", 5689));

      System.out.println("\n");

      String str11 = "a".concat("b").concat("c");
      String str2 = "a"+"b"+"c";
      String str3 = "abc";
      String str4 = new String("abc");
      System.out.println(str11 == str2); //运行结果为false
      System.out.println(str11 == str3); //运行结果为false
      System.out.println(str2 == str3); //运行结果为ture
      System.out.println(str2 == str4); //运行结果为false
      System.out.println(str11.equals(str4)); //运行结果为true

      System.out.println("\n");


   }
}

