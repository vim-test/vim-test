package org.vimtest.math;

import org.vimtest.calc.Calculation;

import junit.framework.TestCase;
import junit.framework.Test;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

public class MathJunit5Test {

	private int value1;

	private int value2;

	public MathJunit5Test(String testName) {
		super(testName);
	}

	protected void setUp() throws Exception {
		super.setUp();
		value1 = 3;
		value2 = 5;
	}

	protected void tearDown() throws Exception {
		super.tearDown();
		value1 = 0;
		value2 = 0;
	}

	public void testAdd() {
		int total = 8;
		int sum = Calculation.add(value1, value2);
		assertEquals(sum, total);
	}

	public void testFailedAdd() {
		int total = 9;
		int sum = Calculation.add(value1, value2);
		assertNotSame(sum, total);
	}

	public void testSub() {
		int total = 0;
		int sub = Calculation.sub(4, 4);
		assertEquals(sub, total);
	}


    @Nested
    @DisplayNameGeneration(DisplayNameGenerator.ReplaceUnderscores.class)
    class NestedClass {

        @Test
        public void testNested() {
            int total = 0;
            int sub = Calculation.sub(4, 4);
            assertEquals(sub, total);
        }

        @Test
        public void testNested2() {
            int total = 0;
            int sub = Calculation.sub(4, 4);
            assertEquals(sub, total);
        }

        @Nested
        class NestedNestedClass {

            @Test
            public void testNestedNested() {
                int total = 0;
                int sub = Calculation.sub(4, 4);
                assertEquals(sub, total);
            }
        }
    }

    @Nested
    class NestedParameterizedTestClass {

        public static Stream<Arguments> fooBarMethodSource() {
            return Stream.of(
                    Arguments.of("foo", "bar"));
        }

        @ParameterizedTest(name = "foo {0}, bar {1}") @MethodSource("fooBarMethodSource")
        public void testWithParams(String foo, String bar) {
            assertNotNull(foo);
            assertNotNull(bar);
        }

            @Test
            public void testNestedNestedNested() {
                int total = 0;
                int sub = Calculation.sub(4, 4);
                assertEquals(sub, total);
            }


    }
}
