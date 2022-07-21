
source spec/support/helpers.vim

describe "Gradle Runner"
  before
    cd spec/fixtures/gradle/java
  end

  after
    cd -
  end

  describe "when test#java#runner is not set"
    it "should use gradletest if the file 'settings.gradle' is found"
      view gradle_multi_module/sample_module/src/test/java/MathTest.java
      TestFile
      Expect g:test#last_command =~# '\v^gradle'
    end
  end

  describe "when test#java#runner is set"
    it "should respect test#java#runner"
      for runner in ["maventest", "gradletest"]
        let g:test#java#runner = runner
        Expect test#determine_runner("gradle_multi_module/sample_module/src/test/java/MathTest.java") == 'java#'.runner
      endfor
    end
  end


