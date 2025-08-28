let s:class_def = 'class\s+(\w+)'
let s:function_def = 'fun\s+(\w+|`.+`)'
let s:line_start = '\v^\s*'
let s:optional_class_inner_modifier = '%(\zsinner\s+\ze)?'
let s:optional_nested_annotation = '%(\zs\@Nested\s+\ze)?'
let s:optional_test_annotation = '%(\zs\@Test\s+\ze)?'

let test#kotlin#patterns = {
  \ 'test':      [  s:line_start
                    \.s:optional_test_annotation
                    \.s:function_def
                    \],
  \ 'namespace': [  s:line_start
                    \.s:optional_nested_annotation
                    \.s:optional_class_inner_modifier
                    \.s:class_def
                    \],
  \}
