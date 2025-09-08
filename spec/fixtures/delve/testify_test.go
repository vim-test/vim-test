package mypackage

import (
	"testing"

	. "github.com/stretchr/testify/assert"
	. "github.com/stretchr/testify/suite"
)

type CalculatorTestSuite struct {
	suite.Suite
}

func (suite *CalculatorTestSuite) TestSum() {
	result := 2 + 3
	assert.Equal(suite.T(), 5, result)
}

func TestCalculatorTestSuite(t *testing.T) {
	suite.Run(t, new(CalculatorTestSuite))
}
