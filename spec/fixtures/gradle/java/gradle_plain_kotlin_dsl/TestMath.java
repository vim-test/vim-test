package org.vimtest.math;

import org.vimtest.calc.Calculation;

import junit.framework.TestCase;

public class TestMath extends TestCase {

	private int value1;

	private int value2;

	public TestMath(String testName) {
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
}
