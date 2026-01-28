// Test file that has structs and impls inside mod tests
// This reproduces a bug where brace counting incorrectly
// removes the 'tests' module from the path

pub fn production_code() -> i32 {
    42
}

#[cfg(test)]
mod tests {
    use super::*;

    struct TestHelper {
        value: i32,
    }

    impl TestHelper {
        fn new(value: i32) -> Self {
            Self { value }
        }

        fn get(&self) -> i32 {
            self.value
        }
    }

    #[test]
    fn test_with_helper() {
        let helper = TestHelper::new(42);
        assert_eq!(helper.get(), production_code());
    }

    #[test]
    fn another_test() {
        assert_eq!(42, 42);
    }
}
