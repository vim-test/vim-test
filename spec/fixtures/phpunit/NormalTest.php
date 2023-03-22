<?php

namespace Tests;

use PHPUnit_Framework_TestCase;

class NormalTest extends PHPUnit_Framework_TestCase
{
    public function testShouldAddTwoNumbers()
    {
        $this->assertEquals(2, 1+1);
    }

    public function testShouldSubtractTwoNumbers()
    {
        $this->assertEquals(2, 4-2);
    }

    public function additionProvider()
    {
        return [
            [2, 4, 6],
            [4, 2, 6]
        ];
    }

    /**
     * @dataProvider additionProvider
     */
    public function testShouldAddToExpectedValue($a, $b, $expected)
    {
        $this->assertEquals($expected, $a + $b);
    }

    /**
     * @test
     */
    public function aTestMarkedWithTestAnnotation()
    {
        $this->assertEquals(2, 4-21);
    }

    /**
     * Possible comments
     *
     * @someOtherAnnotation
     * @test
     * @param foo bar
     */
    public function aTestMarkedWithTestAnnotationAndCrazyDocblock()
    {
        $this->assertEquals(2, 4-21);
    }

    public function testWithAnAnonymousClass()
    {
        $anonymousClass = new class() {
            public function foo(): void
            {
            }
        };

        $this->assertTrue(true);
    }

    /**
     * @test
     */
    public function aTestMakedWithTestAnnotationAndWithAnAnonymousClass()
    {
        $anonymousClass = new class() {
            public function foo(): void
            {
            }
        };

        $this->assertTrue(true);
    }

    /** @test */
    public function aTestMarkedWithTestAnnotationOnOneLine()
    {
        $this->assertEquals(2, 4-21);
    }

    #[Test]
    public function aTestMarkedWithTestAttributeOnOneLine()
    {
        $this->assertEquals(2, 4-21);
    }

    #[Test,TestWith([2, 4-21])]
    public function aTestMarkedWithTestAttributeInGroupOnOneLine(int $expected, int $value)
    {
        $this->assertEquals($expected, $value);
    }

    #[
        Test,
        TestWith([2, 4-21]),
    ]
    public function aTestMarkedWithTestAttributeInGroupOnMultipleLines(int $expected, int $value)
    {
        $this->assertEquals($expected, $value);
    }
}
