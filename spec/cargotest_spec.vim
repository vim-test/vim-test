source spec/support/helpers.vim

describe "Cargo"

  before
    let g:test#rust#runner = 'cargotest'
    cd spec/fixtures/cargo/crate
  end

  after
    call Teardown()
    cd -
  end

  it "runs lib file tests"
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

  it "runs bin file tests"
    view src/bin/somebin.rs
    TestFile
    Expect g:test#last_command == 'cargo test --bin somebin '''''

    view src/bin/nestedbin/main.rs
    TestFile
    Expect g:test#last_command == 'cargo test --bin nestedbin '''''

    view src/bin/nestedbin/somemod.rs
    TestFile
    Expect g:test#last_command == 'cargo test --bin nestedbin ''somemod::'''
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

  it "runs nearest test on bins"
    view +7 src/bin/somebin.rs
    TestNearest
    Expect g:test#last_command == 'cargo test --bin somebin ''tests::first_test'' -- --exact'

    view +11 src/bin/somebin.rs
    TestNearest
    Expect g:test#last_command == 'cargo test --bin somebin ''tests::second_test'' -- --exact'

    view +9 src/bin/nestedbin/main.rs
    TestNearest
    Expect g:test#last_command == 'cargo test --bin nestedbin ''tests::first_test'' -- --exact'

    view +13 src/bin/nestedbin/main.rs
    TestNearest
    Expect g:test#last_command == 'cargo test --bin nestedbin ''tests::second_test'' -- --exact'

    view +4 src/bin/nestedbin/somemod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test --bin nestedbin ''somemod::tests::first_test'' -- --exact'

    view +8 src/bin/nestedbin/somemod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test --bin nestedbin ''somemod::tests::second_test'' -- --exact'
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

    view src/bin/somebin.rs
    TestSuite
    Expect g:test#last_command == 'cargo test'

    view src/bin/nestedbin/main.rs
    TestSuite
    Expect g:test#last_command == 'cargo test'

    view src/bin/nestedbin/somemod.rs
    TestSuite
    Expect g:test#last_command == 'cargo test'
  end

  it "supports async tokio tests"
    view +15 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::tokio_async_test'' -- --exact'
  end

  it "supports async actix rt tests"
    view +26 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::test_actix_rt'' -- --exact'
  end

  it "supports rstest tests"
    view +22 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::rstest_test'' -- --exact'
  end

  it "run with cargotest test_options"
    let g:test#rust#cargotest#test_options = '-- --nocapture'

    view src/main.rs
    TestFile
    Expect g:test#last_command == 'cargo test '''' -- --nocapture'

    view src/too/nested.rs
    TestFile
    Expect g:test#last_command == 'cargo test ''too::nested::'' -- --nocapture'

    let g:test#rust#cargotest#test_options = ['--', '--nocapture --exact']

    view +7 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::second_test'' -- --nocapture --exact'

    view +5 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::first_test'' -- --nocapture --exact'

    let g:test#rust#cargotest#test_options = {'nearest': ['--', '--nocapture --exact']}

    view +7 src/somemod_test.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''somemod_test::test::second_test'' -- --nocapture --exact'

    view +13 src/somemod_test.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''somemod_test::test::third_test'' -- --nocapture --exact'

    let g:test#rust#cargotest#test_options = {'nearest': '-- --nocapture --exact'}

    view +6 src/nomod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''nomod::second_test'' -- --nocapture --exact'

    view +2 src/nomod.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''nomod::first_test'' -- --nocapture --exact'

    let g:test#rust#cargotest#test_options = {'nearest': '-- --nocapture --exact', 'file': []}

    view +7 src/too/nested.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''too::nested::tests::second_test'' -- --nocapture --exact'

    let g:test#rust#cargotest#test_options = {'nearest': '-- --nocapture --exact', 'file': ['-- --nocapture']}

    view src/too/nested.rs
    TestSuite
    Expect g:test#last_command == 'cargo test'
    let g:test#rust#cargotest#test_options = {'nearest': '-- --nocapture --exact', 'file': ['-- --nocapture']}
    view +15 src/lib.rs
    TestNearest
    Expect g:test#last_command == 'cargo test ''tests::tokio_async_test'' -- --nocapture --exact'

    unlet g:test#rust#cargotest#test_options
  end

  it "runs file tests in workspaces"
    let g:test#rust#cargotest#test_options = {'nearest': '-- --nocapture --exact', 'file': ''}
    cd ..
    view crate/src/lib.rs
    TestFile
    Expect g:test#last_command == 'cargo test --package vim-test '''''

    let g:test#rust#cargotest#test_options = {'nearest': '-- --nocapture --exact', 'file': ['-- --nocapture']}
    view crate/src/lib.rs
    TestFile
    Expect g:test#last_command == 'cargo test --package vim-test '''' -- --nocapture'
    unlet g:test#rust#cargotest#test_options
    cd -
  end

end
