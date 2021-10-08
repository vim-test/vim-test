#!/bin/sh

eval "$(shellspec - -c) exit 1"

Describe 'normal'
  one() { echo "1"; }
  two() { echo "2"; }

  It 'one'
    When call one
    The output should eq 1
  End

  It 'one not two'
    When call one
    The output should eq 1
  End

  It 'two'
    When call two
    The output should eq 2
  End
End
