package org.vimtest.calc

import org.junit.Assert.assertEquals
import org.junit.Test

class NestedTest {
    @Test fun testAdd() {
        assertEquals(1 + 1, 2)
    }

    @Nested
    inner class MultiLineNestedContext {
        @Test
        fun `sum of values (multi line annotation)`() {
            assertEquals(1 + 1, 2)
        }

        @Test fun `sum of values (single line annotation)`() {
            assertEquals(1 + 1, 2)
        }
    }

    @Nested inner class OneLineNestedContext {
        @Test
        fun `sum of values (multi line annotation)`() {
            assertEquals(1 + 1, 2)
        }

        @Test fun `sum of values (single line annotation)`() {
            assertEquals(1 + 1, 2)
        }
    }
}
