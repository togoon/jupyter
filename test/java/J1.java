class FreshJuice {
    enum FreshJuiceSize {
        SMALL, MEDIUM, LARGE
    }
    FreshJuiceSize size;
}


public class J1 {

    public static void main(String[] args){

        FreshJuice juice = new FreshJuice();
        juice.size = FreshJuice.FreshJuiceSize.MEDIUM;

        System.out.println("Hello Java 4 World");
        System.out.println(juice.size);
    }
}






