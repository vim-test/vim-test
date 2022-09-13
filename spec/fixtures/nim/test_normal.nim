import unittest
import clock

suite "Clock addition":
  test "add minutes":
    check add((10, 0), 3).toStr == "10:03"
