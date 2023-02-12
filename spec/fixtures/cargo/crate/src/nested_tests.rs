mod tests {
    #[test]
    fn first_test() {
    }

    mod nested_once {
        #[test]
        fn second_test() {
        }

        mod nested_twice {
            #[test]
            fn third_test() {
            }
        }
    }
}
