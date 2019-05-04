let s:line_start = '\v^\s*'
let s:optional_test_decorator = '%(\zs\@Test\s+\ze)?'
let s:optional_public_modifier = '%(\zspublic\s+\ze)?'
let s:function_def = 'void\s+(\w+)'
let s:class_def = 'class\s+(\w+)'

let test#java#patterns = {
  \ 'test':      [  s:line_start
                    \.s:optional_test_decorator
                    \.s:optional_public_modifier
                    \.s:function_def
                    \],
  \ 'namespace': [  s:line_start
                    \.s:optional_public_modifier
                    \.s:class_def
                    \],
  \}

