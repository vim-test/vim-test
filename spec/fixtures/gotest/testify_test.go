package mypackage

import (
	"testing"

	"github.com/stretchr/testify/suite"
)

type ExampleSuite struct {
	suite.Suite
}

func (s *ExampleSuite) TestList() {
	a := []int{1, 2, 3}
	s.NotEmpty(a)
}

func (s *ExampleSuite) SetupTest() {
}

func TestExampleTestSuite(t *testing.T) {
	suite.Run(t, new(ExampleSuite))
}
