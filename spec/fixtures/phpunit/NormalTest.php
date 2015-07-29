<?php

namespace Tests;

use PHPUnit_Framework_TestCase;

class NormalTest extends PHPUnit_Framework_TestCase
{
    public function testShouldAddTwoNumbers()
    {
        $this->assertEquals(2, 1+1);
    }
}
