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

  def execute_ast({name, lhs, rhs}, current_env) when name == :let_stmt do
    l_variant = eval_str(lhs, current_env)
    r_expr = eval_expr(rhs, current_env)
    Map.put(current_env, l_variant, r_expr)
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
    Map.get(current_env, eval_str(id, current_env))
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
    eval_expr(lval, current_env) / eval_expr(rval, current_env)
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

  def eval_str({name, value}, current_env) when name == :prg_name do
    eval_str(value, current_env)
  end

  def eval_str({name, tl, value}, current_env) when name == :chars do
    value |> to_string()
  end

  def execute_ast(rest, current_env) do
    IO.inspect("unknown")
    IO.inspect(rest)
  end
end
