;; extends

(struct_declaration) @scope @scope.inside

(function_declaration
  (parameters) @scope
  body: (block
    (_)* @scope.inside) @scope)

(source_file) @scope @scope.inside

(while_statement
  body: (block
    (_)* @scope.inside)) @scope

(for_statement
  body: (block
    (_)* @scope.inside)) @scope

(if_statement
  (block) @scope @scope.inside)
