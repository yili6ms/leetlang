Nonterminals Program Prg_name ProgramBody ProgramLines ProgramLine Let_stmt Val_expr
Val_expr_all Val_expr1 Val_expr2 Variant Term Factor BoolExpr BoolTerm BoolFactor CmpExpr. 

Terminals eq  ne  assign  ge  le  gt  lt  '{'  '}'  '('  ')'  
and_sym  or_sym  not_sym  plus_sym  minus_sym  mult_sym  div_sym  if_sym  else_sym  while_sym  let_sym  program_sym  void_sym  int_sym  atom  digital  chars
true_sym false_sym.

Rootsymbol Program.

Program -> program_sym Prg_name '{' ProgramBody '}' : {'program', '$2', '$4'}.

Prg_name -> chars : {'prg_name', '$1'}.

ProgramBody -> ProgramLines : {'program_body', '$1'}.

ProgramLines -> ProgramLine ProgramLines  : {'program_lines', '$1', '$2'}.

ProgramLines -> ProgramLine : {'program_lines', '$1'}.

ProgramLine -> Let_stmt : {'program_line', '$1'}.

Let_stmt -> let_sym chars assign Val_expr_all : {'let_stmt', '$2', '$4'}.

Variant -> chars : {'val_expr_chars', '$1'}.

Val_expr_all -> Val_expr : {'val_expr', '$1'}.
Val_expr_all -> BoolExpr : {'val_expr_boolean', '$1'}.

Val_expr -> Val_expr plus_sym Term : {'val_expr', '$1', '$2', '$3'}.
Val_expr -> Val_expr minus_sym Term : {'val_expr', '$1', '$2', '$3'}.
Val_expr -> Term : {'val_expr', '$1'}.

Term -> Term mult_sym Factor : {'val_expr_mult', '$1', '$3'}.
Term -> Term div_sym Factor : {'val_expr_div', '$1', '$3'}.
Term -> Factor : {'factor', '$1'}.

Factor -> chars : {'val_expr_chars', '$1'}.
Factor -> digital : {'val_expr_digital', '$1'}.
Factor -> '(' Val_expr ')' : {'val_expr', '$2'}.

BoolExpr -> BoolTerm or_sym BoolTerm : {'bool_term', '$1', '$2', '$3'}.
BoolExpr -> BoolTerm : {'bool_term', '$1'}.

BoolTerm -> BoolFactor and_sym BoolFactor : {'bool_factor_and', '$1', '$2', '$3'}.
BoolTerm -> BoolFactor : {'bool_factor', '$1'}.

BoolFactor -> not_sym BoolFactor : {'bool_factor_not', '$1', '$2'}.
BoolFactor -> '(' BoolExpr ')' : {'bool_factor', '$2'}.
BoolFactor -> true_sym : {'bool_factor_true', '$1'}.
BoolFactor -> false_sym : {'bool_factor_false', '$1'}.
%BoolFactor -> CmpExpr : {'bool_factor', '$1'}.

BoolFactor -> Val_expr eq Val_expr : {'bool_factor', '$1', '$2', '$3'}.
BoolFactor -> Val_expr ne Val_expr : {'bool_factor', '$1', '$2', '$3'}.
BoolFactor -> Val_expr ge Val_expr : {'bool_factor', '$1', '$2', '$3'}.
BoolFactor -> Val_expr le Val_expr : {'bool_factor', '$1', '$2', '$3'}.
BoolFactor -> Val_expr gt Val_expr : {'bool_factor', '$1', '$2', '$3'}.
BoolFactor -> Val_expr lt Val_expr : {'bool_factor', '$1', '$2', '$3'}.




