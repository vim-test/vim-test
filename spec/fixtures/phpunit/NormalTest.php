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
}
