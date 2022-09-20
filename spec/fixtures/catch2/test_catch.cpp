#include "catch.hpp"
using namespace std;

// NOTE: can only use this file if linking with Catch CMake targets
unsigned int Factorial( unsigned int number ) {
    return number <= 1 ? number : Factorial(number-1)*number;
}

class IApple{
public:
    virtual int apple() = 0;
};

TEST_CASE( "Factorials are computed", "[factorial]" ) {
    REQUIRE( Factorial(1) == 1 );
    REQUIRE( Factorial(2) == 2 );
    REQUIRE( Factorial(3) == 6 );
    REQUIRE( Factorial(10) == 3628800 );
}

#include <stack>

class VectorFixture {
    protected:
        std::stack<int> data;
        const int max_value {5};
    public:
        VectorFixture() : data() {
            for (int i = 1; i <= max_value; ++i)
                data.push(i);
        };
};

TEST_CASE_METHOD(VectorFixture, "sum", "[stack]") {
    int sum {0};
    while (!data.empty()) {
        sum += data.top();
        data.pop();
    REQUIRE( sum == max_value*(max_value + 1)/2 );
    }
}
