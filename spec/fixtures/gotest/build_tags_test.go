// some comments are allowed before tags

//go:build foo && hello && world && !bar && (red || black)
// +build foo
// +build hello,world
// +build !bar
// +build red black

package mypackage

import "testing"

func TestNumbers(*testing.T) {
	// assertions
}
