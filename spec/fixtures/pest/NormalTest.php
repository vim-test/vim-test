<?php

namespace Tests;

use PHPUnit_Framework_TestCase;

class NormalTest extends PHPUnit_Framework_TestCase
{
    /**
     * @test
     */
    public function should_add_two_numbers()
    {
        $this->assertEquals(2, 1 + 1);
    }

    /**
     * @test
     */
    public function should_subtract_two_numbers()
    {
        $this->assertEquals(2, 4 - 2);
    }

    public function additionProvider()
    {
        return [
            [2, 4, 6],
            [4, 2, 6],
        ];
    }

    /**
     * @dataProvider additionProvider
     *
     * @test
     */
    public function should_add_to_expected_value($a, $b, $expected)
    {
        $this->assertEquals($expected, $a + $b);
    }

    /**
     * @test
     */
    public function a_test_marked_with_test_annotation()
    {
        $this->assertEquals(2, 4 - 21);
    }

    /**
     * Possible comments
     *
     * @someOtherAnnotation
     *
     * @test
     *
     * @param foo bar
     */
    public function a_test_marked_with_test_annotation_and_crazy_docblock()
    {
        $this->assertEquals(2, 4 - 21);
    }

    /**
     * @test
     */
    public function with_an_anonymous_class()
    {
        $anonymousClass = new class
        {
            public function foo(): void {}
        };

        $this->assertTrue(true);
    }

    /**
     * @test
     */
    public function a_test_maked_with_test_annotation_and_with_an_anonymous_class()
    {
        $anonymousClass = new class
        {
            public function foo(): void {}
        };

        $this->assertTrue(true);
    }

    /** @test */
    public function a_test_marked_with_test_annotation_on_one_line()
    {
        $this->assertEquals(2, 4 - 21);
    }

    #[Test]
    public function aTestMarkedWithTestAttributeOnOneLine()
    {
        $this->assertEquals(2, 4 - 21);
    }

    #[Test,TestWith([2, 4 - 21])]
    public function aTestMarkedWithTestAttributeInGroupOnOneLine(int $expected, int $value)
    {
        $this->assertEquals($expected, $value);
    }

    #[
        Test,
        TestWith([2, 4 - 21]),
    ]
    public function aTestMarkedWithTestAttributeInGroupOnMultipleLines(int $expected, int $value)
    {
        $this->assertEquals($expected, $value);
    }
}
