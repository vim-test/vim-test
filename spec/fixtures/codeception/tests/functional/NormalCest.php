<?php


class NormalCest
{
    public function _before(FunctionalTester $I)
    {
    }

    public function _after(FunctionalTester $I)
    {
    }

    // tests
    public function tryToTest(FunctionalTester $I)
    {
        $I->wantTo('perform actions and see result');
    }

    public function tryToTestSomethingElse(FunctionalTester $I)
    {
        $I->wantTo('perform another actions and see result');
    }
}
