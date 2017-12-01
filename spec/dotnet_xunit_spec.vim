source spec/support/helpers.vim

function! s:remove_path(cmd)
  return substitute(a:cmd, '\/.*\/spec\/fixtures\/dotnet-xunit\/', '', '')
endfunction

describe "xUnit"

  before
    cd spec/fixtures/dotnet-xunit
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +5 Tests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -class Namespace.Tests'

    view +10 Tests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -method Namespace.Tests.TestAsync'

    view +16 Tests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -method Namespace.Tests.Test'
  end

  it "runs nearest nested tests"
    view +5 NestedTests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -class Namespace.Parent'

    view +7 NestedTests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -class Namespace.Parent.NestedTests'

    view +10 NestedTests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -method Namespace.Parent.NestedTests.TestAsync'

    view +18 NestedTests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -method Namespace.Parent.NestedTests.Test'
  end

  it "runs nearest tests when there is fixture in the same file"
    view +18 TestsWithFixture.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -class Namespace.TestsWithFixture'

    view +20 TestsWithFixture.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -method Namespace.TestsWithFixture.TestAsync'

    view +26 TestsWithFixture.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -method Namespace.TestsWithFixture.Test'
  end

  it "runs current file if nearest test couldn't be found"
    view +1 Tests.cs
    normal O
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -class Namespace.Tests'
  end

  it "runs current file tests"
    view Tests.cs
    TestFile

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -class Namespace.Tests'

    view NestedTests.cs
    TestFile

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -class Namespace.Parent'

    view TestsWithFixture.cs
    TestFile

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo -class Namespace.TestsWithFixture'
  end

  it "runs test suites"
    view Tests.cs
    TestSuite

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet xunit -nologo'
  end

end
