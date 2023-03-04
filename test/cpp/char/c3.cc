class IFACE {
};

class A {
public:
    A& operator<<(IFACE& other);
};


class B :IFACE {
};


class C :IFACE {
    static C factory() {
        C c;
        return c;
    }
};


int main() {
    A a;
    B b;
    C c;

    return 0;
}


