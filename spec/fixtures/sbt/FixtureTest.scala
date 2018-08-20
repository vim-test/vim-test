package fixture

import org.scalatest.FunSuite


import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class FixtureTestSuite extends FunSuite {

  trait TestMath{
    val valueIntOne: Int = 3
    val valueIntTwo: Int = 5
    val valueDoubleOne: Double = 8.0
    val valueDoubleTwo: Double = 13.0
    val valueStringOne = "a"
    val valueStringTwo = "b"
  }

  test("Assert 'add' works for Int and returns Int") {
    new TestMath{
      val intUnderTest = SimpleMath.add(valueIntOne, valueIntTwo)
      assert(8 == intUnderTest)
      assert(intUnderTest.isInstanceOf[Int])
    }
  }

  test("Assert 'add' works for Double and returns Double") {
    new TestMath{
      val doubleUnderTest = SimpleMath.add(valueDoubleOne, valueDoubleTwo)
      assert(21.0 == doubleUnderTest)
      assert(doubleUnderTest.isInstanceOf[Double])
    }
  }

  test("Assert 'mul' works for Int and returns Int") {
    new TestMath{
      val intUnderTest = SimpleMath.mul(valueIntOne, valueIntTwo)
      assert(15 == intUnderTest)
      assert(intUnderTest.isInstanceOf[Int])
    }
  }

  test("Assert 'mul' works for Double and returns Double") {
    new TestMath{
      val doubleUnderTest = SimpleMath.mul(valueDoubleOne, valueDoubleTwo)
      assert(104.0 == doubleUnderTest)
      assert(doubleUnderTest.isInstanceOf[Double])
    }
  }

  test("Assert neither 'add' nor 'mul' work on String") {
    new TestMath{
      assertThrows[IllegalArgumentException] {
        SimpleMath.add(valueStringOne, valueStringTwo)
      }
      assertThrows[IllegalArgumentException] {
        SimpleMath.mul(valueStringOne, valueStringTwo)
      }
    }
  }

}
