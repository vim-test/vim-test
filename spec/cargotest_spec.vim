source spec/support/helpers.vim

describe "Cargo"

  before
    cd spec/fixtures/cargo
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view src/lib.rs
    TestFile
    Expect g:test#last_command == 'cargo test ''tests::'''

    view src/somemod.rs
    TestFile
    Expect g:test#last_command == 'cargo test ''somemod::tests::'''

    view src/nested/mod.rs
    TestFile
    Expect g:test#last_command == 'cargo test ''nested::tests::'''

    view src/too/nested.rs
    TestFile
    Expect g:test#last_command == 'cargo test ''too::nested::tests::'''
  end

  it "runs nearest test on lib.rs"
    view +5 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::first_test'' -- --exact'

    view +13 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::third_test'' -- --exact'

    view +7 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::second_test'' -- --exact'
  end

  it "runs nearest test on modules"
    view +5 src/somemod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''somemod::tests::first_test'' -- --exact'

    view +13 src/somemod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''somemod::tests::third_test'' -- --exact'

    view +7 src/somemod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''somemod::tests::second_test'' -- --exact'

    view +5 src/nested/mod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''nested::tests::first_test'' -- --exact'

    view +13 src/nested/mod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''nested::tests::third_test'' -- --exact'

    view +7 src/nested/mod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''nested::tests::second_test'' -- --exact'

    view +5 src/too/nested.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''too::nested::tests::first_test'' -- --exact'

    view +13 src/too/nested.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''too::nested::tests::third_test'' -- --exact'

    view +7 src/too/nested.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''too::nested::tests::second_test'' -- --exact'
  end

  it "runs test suites"
    view src/lib.rs
    TestSuite
    Expect g:test#last_command == 'cargo test'

    view src/somemod.rs
    TestSuite
    Expect g:test#last_command == 'cargo test'

    view src/nested/mod.rs
    TestSuite
    Expect g:test#last_command == 'cargo test'

    view src/too/nested.rs
    TestSuite
    Expect g:test#last_command == 'cargo test'
  end

end

