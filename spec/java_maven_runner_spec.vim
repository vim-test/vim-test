
source spec/support/helpers.vim

describe "Maven Runner"
  before
    cd spec/fixtures/maven
  end

  after
    cd -
  end

  describe "when test#java#runner is not set"
    it "should use maventest if 'pom.xml' is found"
      view sample_maven_junit5_multimodule_project/sample_module/src/test/java/org/vimtest/TestApp.java
      TestFile
      Expect g:test#last_command =~# '\v^mvn'
    end
  end

  describe "when test#java#runner is set"
    it "should respect test#java#runner"
      for runner in ["maventest", "gradletest"]
        let g:test#java#runner = runner
        Expect test#determine_runner("sample_maven_junit5_multimodule_project/sample_module/src/test/java/org/vimtest/TestApp.java") == 'java#'.runner
      endfor
    end
  end


