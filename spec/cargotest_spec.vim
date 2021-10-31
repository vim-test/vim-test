source spec/support/helpers.vim

describe "Cargo"

  before
    cd spec/fixtures/cargo/crate
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view src/lib.rs
    TestFile
    Expect g:test#last_command == 'cargo test '''''

    view src/main.rs
    TestFile
    Expect g:test#last_command == 'cargo test '''''

    view src/somemod.rs
    TestFile
    Expect g:test#last_command == 'cargo test ''somemod::'''

    view src/nested/mod.rs
    TestFile
    Expect g:test#last_command == 'cargo test ''nested::'''

    view src/too/nested.rs
    TestFile
    Expect g:test#last_command == 'cargo test ''too::nested::'''
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


  it "runs nearest test on modules with mod as test"
    view +5 src/somemod_test.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''somemod_test::test::first_test'' -- --exact'

    view +13 src/somemod_test.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''somemod_test::test::third_test'' -- --exact'

    view +7 src/somemod_test.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''somemod_test::test::second_test'' -- --exact'
  end

  it "runs nearest test without mod"
    view +2 src/nomod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''nomod::first_test'' -- --exact'

    view +10 src/nomod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''nomod::third_test'' -- --exact'

    view +6 src/nomod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''nomod::second_test'' -- --exact'
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

  it "supports async tokio tests"
    view +15 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::tokio_async_test'' -- --exact'
  end

  it "supports rstest tests"
    view +22 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::rstest_test'' -- --exact'
  end

  it "runs file tests in workspaces"
    cd ..
    view crate/src/lib.rs
    TestFile
    Expect g:test#last_command == 'cargo test --package crate '''''
    cd -
end
