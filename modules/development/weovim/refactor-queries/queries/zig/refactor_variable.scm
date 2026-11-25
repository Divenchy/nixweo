;; extends

(variable_declaration
  .
  (identifier) @variable.identifier
  "=" @variable.value_separator
  .
  (_) @variable.value) @variable.declaration
