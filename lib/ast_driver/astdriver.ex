defmodule AstDriver.Astdriver do
  # simple version use agent to simulate stack/frame
  def execute_program(source_code) do
    with {:ok, res, _} <- :leetlang_lex.string(source_code) do
      {_, parse_res} =
        res |> :leetlang_parser.parse()

      parse_res
      |> execute_ast(%{})
    else
      _ -> {:error, "Lexing failed"}
    end
  end

  def execute_ast({name, pgname, pgbody}, current_env) when name == :program do
    IO.inspect("starting executing program #{eval_str(pgname, %{})}")
    ret = execute_ast(pgbody, current_env)
    IO.inspect("environment table:")

    ret
    |> IO.inspect()
  end

  def execute_ast({name, program_body}, current_env) when name == :program_body do
    execute_ast(program_body, current_env)
  end

  def execute_ast({name, program_body, ret_stmt}, current_env) when name == :program_body do
    cur_env = execute_ast(program_body, current_env)
    eval_expr(ret_stmt, cur_env)
  end

  def execute_ast({name, program_line, program_lines}, current_env) when name == :program_lines do
    env1 = execute_ast(program_line, current_env)
    execute_ast(program_lines, env1)
  end

  def execute_ast({name, program_line}, current_env) when name == :program_lines do
    execute_ast(program_line, current_env)
  end

  def execute_ast({name, let_stmt}, current_env) when name == :program_line do
    execute_ast(let_stmt, current_env)
  end

  def execute_ast({name, func_line, func_lines}, current_env) when name == :func_lines do
    env1 = execute_ast(func_line, current_env)
    execute_ast(func_lines, env1)
  end

  def execute_ast({name, func_line}, current_env) when name == :func_lines do
    execute_ast(func_line, current_env)
  end

  def execute_ast({name, let_stmt}, current_env) when name == :func_line do
    execute_ast(let_stmt, current_env)
  end

  def execute_ast({name, lhs, rhs}, current_env) when name == :let_stmt do
    l_variant = eval_str(lhs, current_env)
    r_expr = eval_expr(rhs, current_env)
    Map.put(current_env, l_variant, r_expr)
  end

  def execute_ast({name, funcname, funcdef}, current_env) when name == :let_fn_stmt do
    l_variant = eval_str(funcname, current_env)
    Map.put(current_env, l_variant, funcdef)
  end

  def execute_ast({name, condition_expr, true_body, false_body}, current_env)
      when name == :stmt_if_else do
    with true <- eval_expr(condition_expr, current_env) do
      execute_ast(true_body, current_env)
    else
      _ -> execute_ast(false_body, current_env)
    end
  end

  def execute_ast({name, condition_expr, true_body}, current_env) when name == :stmt_if do
    with true <- eval_expr(condition_expr, current_env) do
      execute_ast(true_body, current_env)
    else
      _ -> current_env
    end
  end

  def execute_ast({name, condition_expr, exec_body}, current_env) when name == :stmt_while do
    new_env = process_while(name, condition_expr, exec_body, current_env)
  end

  def eval_expr({name, func}, current_env) when name == :val_expr_func do
    eval_expr(func, current_env)
  end

  def eval_expr({name, ret_val}, current_env) when name == :ret_stmt do
    eval_expr(ret_val, current_env)
  end

  def eval_expr({name, func_name}, current_env) when name == :val_expr_func_wo_parm do
    body = Map.fetch!(current_env, eval_str(func_name, current_env))
    eval_func(body, [], current_env)
  end

  def eval_expr({name, func_name, para_list}, current_env) when name == :val_expr_func_with_parm do
    arity = eval_expr(para_list, current_env)
    body = Map.fetch!(current_env, eval_str(func_name, current_env))
    eval_func(body, wrap_arity(arity), current_env)
  end



  def eval_expr({name, parm}, current_env) when name == :call_param_list do
    eval_expr(parm, current_env)
  end

  def eval_expr({name, parm, parmlist}, current_env) when name == :call_param_list do
    [eval_expr(parm, current_env)] ++ [eval_expr(parmlist, current_env)]
  end

  def eval_expr({name, parm}, current_env) when name == :call_param do
    eval_expr(parm, current_env)
  end




  def eval_expr({name, expr_boolean}, current_env) when name == :val_expr_boolean do
    eval_expr(expr_boolean, current_env)
  end

  def eval_expr({name, bool_expr}, current_env) when name == :bool_term do
    eval_expr(bool_expr, current_env)
  end

  def eval_expr({name, bool_expr, _, ya_bool_expr}, current_env) when name == :bool_term do
    eval_expr(bool_expr, current_env) or eval_expr(ya_bool_expr, current_env)
  end

  def eval_expr({name, bool_expr, _, ya_bool_expr}, current_env)
      when name == :bool_factor_and do
    eval_expr(bool_expr, current_env) and eval_expr(ya_bool_expr, current_env)
  end

  def eval_expr({name, val}, current_env) when name == :bool_factor do
    eval_expr(val, current_env)
  end

  def eval_expr({name, oper, val}, current_env) when name == :bool_factor_not do
    not eval_expr(val, current_env)
  end

  def eval_expr({name, _}, current_env) when name == :bool_factor_true do
    true
  end

  def eval_expr({name, _}, current_env) when name == :bool_factor_false do
    false
  end

  def eval_expr({name, lhs, {oper, _}, rhs}, current_env)
      when name == :bool_factor and oper == :eq do
    eval_expr(lhs, current_env) == eval_expr(rhs, current_env)
  end

  def eval_expr({name, lhs, {oper, _}, rhs}, current_env)
      when name == :bool_factor and oper == :ne do
    eval_expr(lhs, current_env) != eval_expr(rhs, current_env)
  end

  def eval_expr({name, lhs, {oper, _}, rhs}, current_env)
      when name == :bool_factor and oper == :ge do
    eval_expr(lhs, current_env) >= eval_expr(rhs, current_env)
  end

  def eval_expr({name, lhs, {oper, _}, rhs}, current_env)
      when name == :bool_factor and oper == :le do
    eval_expr(lhs, current_env) <= eval_expr(rhs, current_env)
  end

  def eval_expr({name, lhs, {oper, _}, rhs}, current_env)
      when name == :bool_factor and oper == :gt do
    eval_expr(lhs, current_env) > eval_expr(rhs, current_env)
  end

  def eval_expr({name, lhs, {oper, _}, rhs}, current_env)
      when name == :bool_factor and oper == :lt do
    eval_expr(lhs, current_env) < eval_expr(rhs, current_env)
  end

  def eval_expr({name, val}, current_env) when name == :val_expr_digital do
    eval_expr(val, current_env)
  end

  def eval_expr({name, term}, current_env) when name == :term do
    eval_expr(term, current_env)
  end

  def eval_expr({name, _, dval}, current_env) when name == :digital do
    dval
  end

  def eval_expr({name, factor}, current_env) when name == :factor do
    eval_expr(factor, current_env)
  end

  def eval_expr({name, id}, current_env) when name == :val_expr_chars do
    Map.fetch!(current_env, eval_str(id, current_env))
  end

  def eval_expr({name, lval, {oper, _}, rval}, current_env)
      when name == :val_expr and
             oper == :plus_sym do
    eval_expr(lval, current_env) + eval_expr(rval, current_env)
  end

  def eval_expr({name, lval, {oper, _}, rval}, current_env)
      when name == :val_expr and
             oper == :minus_sym do
    eval_expr(lval, current_env) - eval_expr(rval, current_env)
  end

  def eval_expr({name, lval, {oper, _}, rval}, current_env)
      when name == :val_expr and
             oper == :mult_sym do
    eval_expr(lval, current_env) * eval_expr(rval, current_env)
  end

  def eval_expr({name, lval, {oper, _}, rval}, current_env)
      when name == :val_expr and
             oper == :div_sym do
    div(eval_expr(lval, current_env), eval_expr(rval, current_env))
  end

  def eval_expr({name, term}, current_env) when name == :val_expr do
    eval_expr(term, current_env)
  end

  def eval_expr({name, lval, rval}, current_env) when name == :val_expr_mult do
    eval_expr(lval, current_env) * eval_expr(rval, current_env)
  end

  def eval_expr({name, lval, rval}, current_env) when name == :val_expr_div do
    eval_expr(lval, current_env) / eval_expr(rval, current_env)
  end

  def eval_expr({name, val}, current_env) when name == :factor do
    eval_expr(val, current_env)
  end

  def eval_expr(rest, current_env) do
    IO.inspect("unknown")
    IO.inspect(rest)
  end

  def eval_func({name, form_list, ret_type, ret_stmt}, arity, current_env) when name == :func_def1 do
    new_env = form_list
    |> extract_para
    |> Enum.zip(arity)
    |> Enum.reduce(%{}, fn({k,v}, acc) -> Map.put(acc, k, v) end)
    new_env2 = Map.merge(current_env, new_env)
    eval_expr(ret_stmt, new_env2)

  end

  def eval_func({name, form_list, ret_type, func_lines, ret_stmt}, arity, current_env) when name == :func_def2 do
    new_env = form_list
    |> extract_para
    |> Enum.zip(arity)
    |> Enum.reduce(%{}, fn({k,v}, acc) -> Map.put(acc, k, v) end)
    new_env3 = execute_ast(func_lines, Map.merge(current_env, new_env))
    IO.inspect(new_env3)
    eval_expr(ret_stmt, new_env3)
  end

  def eval_func({name, ret_type, ret_stmt}, arity, current_env) when name == :func_def_no_parm1 do
    eval_expr(ret_stmt, current_env)
  end

  def eval_func({name, ret_type, func_lines, ret_stmt}, arity, current_env) when name == :func_def_no_parm2 do
    new_env = execute_ast(func_lines, current_env)
    IO.inspect(new_env)
    eval_expr(ret_stmt, new_env)
  end

  @spec eval_str(
          {:prg_name,
           {:prg_name, {:prg_name, {any, any} | {any, any, any}} | {:chars, any, any}}
           | {:chars, any, any}}
          | {:chars, any, any},
          any
        ) :: binary
  def eval_str({name, value}, current_env) when name == :prg_name do
    eval_str(value, current_env)
  end

  def eval_str({name, tl, value}, current_env) when name == :chars do
    value |> to_string()
  end

  defp process_while(name, condition_expr, exec_body, current_env) do
    with true <- eval_expr(condition_expr, current_env) do
      new_env = execute_ast(exec_body, current_env)
      process_while(name, condition_expr, exec_body, new_env)
    else
      _ -> current_env
    end
  end

  def extract_para(form_list) do
    get_fname_para(form_list) |>
    Enum.map(& extract_func_para/1) |> Enum.map(& to_string(&1))
  end

  defp get_fname_para({name, para}) when name == :para_list do
    [para]
  end

  defp get_fname_para({name, para, paras}) when name == :para_list do
    [para] ++ get_fname_para(paras)
  end

  defp extract_func_para(param) do
    {_, {_, {_,_, name}}, _} = param
    name
  end

  defp wrap_arity(arity) do
    if is_list(arity) do
      arity
    else
      [arity]
    end
  end




  def execute_ast(rest, current_env) do
    IO.inspect("unknown")
    IO.inspect(rest)
  end
end
