Nonterminals Program Prg_name ProgramBody ProgramLines ProgramLine Let_stmt Val_expr FuncLine FuncLines
Val_expr_all FuncReturn  RetStmt Call_ParamList Call_Param Val_expr1 Val_expr2 Variant Term Factor BoolExpr BoolTerm BoolFactor CmpExpr Func_def Let_fn_stmt ParaList RetType Param Formalization Type. 

Terminals eq  ne  assign  ge  le  gt  lt  '{'  '}'  '('  ')'  
and_sym  or_sym  not_sym fn_sym plus_sym  minus_sym  mult_sym  div_sym arrow_sym 
if_sym  else_sym  while_sym  let_sym  return_sym let_fn_sym program_sym  void_sym  int_sym bool_sym atom  digital  chars
true_sym false_sym dot_call.

Rootsymbol Program.

Program -> program_sym Prg_name '{' ProgramBody '}' : {'program', '$2', '$4'}.

Prg_name -> chars : {'prg_name', '$1'}.

ProgramBody -> ProgramLines : {'program_body', '$1'}.

ProgramLines -> ProgramLine ProgramLines  : {'program_lines', '$1', '$2'}.

ProgramLines -> ProgramLine : {'program_lines', '$1'}.

ProgramLine -> Let_stmt : {'program_line', '$1'}.

ProgramLine -> Let_fn_stmt : {'program_line', '$1'}.

ProgramLine -> if_sym '(' BoolExpr ')' '{' FuncLines '}' else_sym '{' FuncLines '}' : {'stmt_if_else', '$3', '$6', '$10'}.

ProgramLine -> if_sym '(' BoolExpr ')' '{' FuncLines '}' : {'stmt_if', '$3', '$6'}.

ProgramLine -> while_sym '(' BoolExpr ')' '{' FuncLines '}' : {'stmt_while', '$3', '$6'}.

Let_stmt -> let_sym chars assign Val_expr_all : {'let_stmt', '$2', '$4'}.

Let_fn_stmt -> let_fn_sym chars assign Func_def: {'let_fn_stmt', '$2', '$4'}.

Func_def -> '(' ParaList ')' arrow_sym RetType '{' RetStmt '}' : {'func_def1', '$2', '$5', '$7'}.
Func_def -> '(' ParaList ')' arrow_sym RetType '{' FuncLines RetStmt'}' : {'func_def2', '$2', '$5', '$7', '$8'}.
Func_def -> '(' ')' arrow_sym RetType '{' FuncLines RetStmt '}' : {'func_def_no_parm2', '$4', '$6', '$7'}.
Func_def -> '(' ')' arrow_sym RetType '{' RetStmt '}' : {'func_def_no_parm1', '$4', '$6'}.

RetStmt -> return_sym Val_expr_all : {'ret_stmt', '$2'}.

FuncLines -> FuncLine FuncLines : {'func_lines', '$1', '$2'}.
FuncLines -> FuncLine : {'func_lines', '$1'}.


FuncLine -> Let_stmt : {'func_line', '$1'}.
FuncLine -> if_sym '(' BoolExpr ')' '{' FuncLines '}' else_sym '{' FuncLines '}' : {'stmt_if_else', '$3', '$6', '$10'}.
FuncLine -> if_sym '(' BoolExpr ')' '{' FuncLines '}' : {'stmt_if', '$3', '$6'}.
FuncLine -> while_sym '(' BoolExpr ')' '{' FuncLines '}' : {'stmt_while', '$3', '$6'}.

ParaList -> Param : {'para_list', '$1'}.
ParaList -> Param  ParaList : {'para_list', '$1', '$2'}.

Param -> Formalization arrow_sym Type : {'param', '$1', '$3'}.

Formalization -> chars : {'formalization_name', '$1'}.

Type -> int_sym : {'type_int', '$1'}.
Type -> bool_sym : {'type_boolean', '$1'}.

RetType -> Type : {'ret_type', '$1'}.

Variant -> chars : {'val_expr_chars', '$1'}.

Val_expr_all -> Val_expr : {'val_expr', '$1'}.
Val_expr_all -> BoolExpr : {'val_expr_boolean', '$1'}.
Val_expr_all -> FuncReturn : {'val_expr_func', '$1'}.

FuncReturn -> chars dot_call '(' Call_ParamList ')' : {'val_expr_func_with_parm', '$1', '$4'}.
FuncReturn -> chars dot_call '(' ')' : {'val_expr_func_wo_parm', '$1'}.

Call_ParamList -> Call_Param : {'call_param_list', '$1'}.
Call_ParamList -> Call_Param  Call_ParamList : {'call_param_list', '$1', '$2'}.
Call_Param -> Val_expr_all : {'call_param', '$1'}.

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





