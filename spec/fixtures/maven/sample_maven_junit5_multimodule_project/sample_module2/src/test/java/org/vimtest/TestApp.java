package org.vimtest;

import org.vimtest.App;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Assertions;


public class TestApp 
{
    @Test void test_testdecorator_void()
    {
        Assertions.assertEquals(true, true);
    }

    @Test public void test_testdecorator_public_void()
    {
        Assertions.assertEquals(true, true);
    }

    @Test
    void test_void()
    {
        Assertions.assertEquals(true, true);
    }

    @Test
    public void test_public_void()
    {
        Assertions.assertEquals(true, true);
    }

    @Nested
    class Test_NestedTestClass
    {
        @Test
        public void test_nested_test()
        {
            Assertions.assertEquals(true, true);
        }
    }
}
