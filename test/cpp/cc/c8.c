#include <functional>
#include <iostream>

// Actual code uses Lua, but for simplification
// I'll hide it in this example.
typedef void lua_State;

class widget
{
public:
    enum class TYPE
    {
        BEGIN = 0,
        WINDOW = BEGIN,
        BUTTON,
        SCROLL,
        PROGRESS,
        END
    };

    static const char* to_cstring(const TYPE value)
    {
        switch (value)
        {
        case TYPE::WINDOW: return"window";
        case TYPE::BUTTON: return"button";
        case TYPE::SCROLL: return"scroll";
        case TYPE::PROGRESS: return"progress";
        default: break;
        }
        return nullptr;
    }
};

class shader
{
public:
    enum class FUNC
    {
        BEGIN = 0,
        TRANSLATE = BEGIN,
        ROTATE,
        SCALE,
        COLOR,
        COORD,
        END
    };

    enum class WAVEFORM
    {
        BEGIN = 0,
        SINE = BEGIN,
        SQUARE,
        TRIANGLE,
        LINEAR,
        NOISE,
        END
    };

    static const char* to_cstring(const FUNC value)
    {
        switch (value)
        {
        case FUNC::TRANSLATE: return"translate";
        case FUNC::ROTATE: return"rotate";
        case FUNC::SCALE: return"scale";
        case FUNC::COLOR: return"color";
        case FUNC::COORD: return"coord";
        default: break;
        }
        return nullptr;
    }

    static const char* to_cstring(const WAVEFORM value)
    {
        switch (value)
        {
        case WAVEFORM::SINE: return"sine";
        case WAVEFORM::SQUARE: return"square";
        case WAVEFORM::TRIANGLE: return"triangle";
        case WAVEFORM::LINEAR: return"linear";
        case WAVEFORM::NOISE: return"noise";
        default: break;
        }
        return nullptr;
    }
};

// Increment an enum value.
// My compiler (g++ 4.6) doesn't support type_traits for enumerations, so
// here I just static_cast the enum value to int... Something to be fixed
// later...
template < class E >
E& enum_increment(E& value)
{
    return value = (value == E::END) ? E::BEGIN : E(static_cast<int>(value) + 1);
}

widget::TYPE& operator++(widget::TYPE& e)
{
    return enum_increment< widget::TYPE >(e);
}

shader::FUNC& operator++(shader::FUNC& e)
{
    return enum_increment< shader::FUNC >(e);
}

shader::WAVEFORM& operator++(shader::WAVEFORM& e)
{
    return enum_increment< shader::WAVEFORM >(e);
}


// Register the enumeration with Lua
template< class E >
void register_enum(lua_State* L, const char* table_name, std::function< const char* (E) > to_cstring)
{
    (void)L; // Not used in this example.
    // Actual code creates a table in Lua and sets table[ to_cstring( i ) ] = i
    for (auto i = E::BEGIN; i < E::END; ++i)
    {
        // For now, assume to_cstring can't return nullptr...
        const char* key = to_cstring(i);
        const int value = static_cast<int>(i);
        std::cout << table_name << "." << key << " =" << value << std::endl;
    }
}

int main(int argc, char** argv)
{
    (void)argc; (void)argv;

    lua_State* L = nullptr;

    // Only one to_cstring function in widget class so this works...
    register_enum< widget::TYPE >(L, "widgets", widget::to_cstring);

    // ... but these don't know which to_cstring to use.
    register_enum< shader::FUNC >(L, "functions", shader::to_cstring);
    //register_enum< shader::WAVEFORM >( L,"waveforms", shader::to_cstring );

    return 0;
}