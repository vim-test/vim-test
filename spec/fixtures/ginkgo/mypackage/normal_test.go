package mypackage_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("posts API", func() {

	Context("when the request is authenticated", func() {

		It("should return list of posts owned by the user", func() {

		})

		It("should paginate the result", func() {

		})

	})

	Context("when the request is not authenticated", func() {

		It("should deny access", func() {

		})
	})

})
