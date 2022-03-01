source spec/support/helpers.vim

function! s:remove_path(cmd)
  return substitute(a:cmd, '\/.*\/spec\/fixtures\/dotnet\/', '', '')
endfunction

describe "DotnetTest"

  before
    cd spec/fixtures/dotnet
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests for file namespace"
    view +6 FileNamespaceTests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet test Tests.csproj --filter FullyQualifiedName=Namespace.Tests.TestAsyncWithTaskReturn'
  end

  it "runs nearest tests"
    view +3 Tests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet test Tests.csproj --filter FullyQualifiedName~Namespace.Tests'

    view +8 Tests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet test Tests.csproj --filter FullyQualifiedName=Namespace.Tests.TestAsync'

    view +14 Tests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet test Tests.csproj --filter FullyQualifiedName=Namespace.Tests.Test'

    view +20 Tests.cs
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet test Tests.csproj --filter FullyQualifiedName=Namespace.Tests.TestAsyncWithTaskReturn'
  end

  it "runs file test if nearest test couldn't be found"
    view +2 Tests.cs
    normal O
    TestNearest

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet test Tests.csproj --filter FullyQualifiedName~Namespace'
  end

  it "runs test suites"
    view Tests.cs
    TestSuite

    let actual = s:remove_path(g:test#last_command)
    Expect actual == 'dotnet test Tests.csproj'
  end

end
