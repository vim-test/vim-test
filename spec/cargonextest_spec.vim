source spec/support/helpers.vim

describe "CargoNextest"

  before
    let g:test#rust#runner = 'cargonextest'
    cd spec/fixtures/cargo/crate
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests"
    view src/lib.rs
    TestFile
    Expect g:test#last_command == 'cargo nextest run '''''

    view src/main.rs
    TestFile
    Expect g:test#last_command == 'cargo nextest run '''''

    view src/somemod.rs
    TestFile
    Expect g:test#last_command == 'cargo nextest run ''somemod::'''

    view src/nested/mod.rs
    TestFile
    Expect g:test#last_command == 'cargo nextest run ''nested::'''

    view src/too/nested.rs
    TestFile
    Expect g:test#last_command == 'cargo nextest run ''too::nested::'''
  end

  it "runs nearest test on lib.rs"
    view +5 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''tests::first_test'''

    view +13 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''tests::third_test'''

    view +7 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''tests::second_test'''
  end


  it "runs nearest test on modules with mod as test"
    view +5 src/somemod_test.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''somemod_test::test::first_test'''

    view +13 src/somemod_test.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''somemod_test::test::third_test'''

    view +7 src/somemod_test.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''somemod_test::test::second_test'''
  end

  it "runs nearest test without mod"
    view +2 src/nomod.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''nomod::first_test'''

    view +10 src/nomod.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''nomod::third_test'''

    view +6 src/nomod.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''nomod::second_test'''
  end

  it "runs nearest test on modules"
    view +5 src/somemod.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''somemod::tests::first_test'''

    view +13 src/somemod.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''somemod::tests::third_test'''

    view +7 src/somemod.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''somemod::tests::second_test'''

    view +5 src/nested/mod.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''nested::tests::first_test'''

    view +13 src/nested/mod.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''nested::tests::third_test'''

    view +7 src/nested/mod.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''nested::tests::second_test'''

    view +5 src/too/nested.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''too::nested::tests::first_test'''

    view +13 src/too/nested.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''too::nested::tests::third_test'''

    view +7 src/too/nested.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''too::nested::tests::second_test'''
  end

  it "runs test suites"
    view src/lib.rs
    TestSuite
    Expect g:test#last_command == 'cargo nextest run'

    view src/somemod.rs
    TestSuite
    Expect g:test#last_command == 'cargo nextest run'

    view src/nested/mod.rs
    TestSuite
    Expect g:test#last_command == 'cargo nextest run'

    view src/too/nested.rs
    TestSuite
    Expect g:test#last_command == 'cargo nextest run'
  end

  it "supports async tokio tests"
    view +15 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''tests::tokio_async_test'''
  end

  it "supports async actix rt tests"
    view +26 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''tests::test_actix_rt'''
  end

  it "supports rstest tests"
    view +22 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo nextest run ''tests::rstest_test'''
  end

  it "runs file tests in workspaces"
    cd ..
    view crate/src/lib.rs
    TestFile
    Expect g:test#last_command == 'cargo nextest run --package vim-test '''''
    cd -
end
