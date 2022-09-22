package mypackage

import "testing"

func TestNumbers(t *testing.T) {
	// assertions

	t.Run("adding two numbers", func(t *testing.T) {
		// sub test assertions
	})

	t.Run("[].*+?|$^()", func(t *testing.T) {
		// sub test assertions
	})

	t.Run("this is", func(t *testing.T) {
		t.Run("nested", func(t *testing.T) {
			// nested test assertions
		})
	})
}

func Testテスト(*testing.T) {
	// assertions
}

func ExampleSomething() {
	// Output:
}

func Something() {
}

type TestSomeTestifySuite struct{}

func (suite *TestSomeTestifySuite) TestSomethingInASuite() {
	// assertions
}
