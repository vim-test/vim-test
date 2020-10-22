mod tests {
    #[test]
    fn first_test () {
    }

    #[test]
    fn second_test () {
    }

    #[test]
    fn third_test () {
    }

    #[tokio::test]
    async fn tokio_async_test() {
    }

    #[rstest(input,
        case(1),
        case(2),
    )]
    fn rstest_test(_: u8) {
    }
}
