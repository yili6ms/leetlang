defmodule LeetlangTest do
  use ExUnit.Case
  doctest Leetlang

  @tag :lex_test
  test "simple lex test" do
    input = ~c"let a = 2"

    :leetlang_lex.string(input)
    |> IO.inspect()
  end

  @tag :lex_test
  test "simple lex test2" do
    input = ~c"if (a>1) { a = a + 1} else{b = b -1}"

    :leetlang_lex.string(input)
    |> IO.inspect()
  end

  @tag :parser_test
  test "simple parser test" do
    input = ~c"program abc {
      let a =1+2
    let b=2 +2
    let c = a+b
    }"
    {_, res, _} = :leetlang_lex.string(input)

    res
    |> :leetlang_parser.parse()
    |> IO.inspect()
  end

  @tag :parser_test_boolean
  test "simple parser test2" do
    input = ~c"program abc {
      let a = 1 > 2
    }"
    {_, res, _} = :leetlang_lex.string(input)
    IO.inspect(res)

    res
    |> :leetlang_parser.parse()
    |> IO.inspect()
  end

  @tag :ast_driver_test
  test "simple ast driver test" do
    input = ~c"program abc {
      let a = 4 + 1
      let b = 2 - 1 + 1
      let c = a * b -1
      let d = 1 + 2 * c
    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert Map.get(env_map, "a") == 5
    assert Map.get(env_map, "b") == 2
    assert Map.get(env_map, "c") == 9
    assert Map.get(env_map, "d") == 19
  end

  @tag :ast_driver_test
  test "simple ast driver test2" do
    input = ~c"program abc {
      let a = 4 + 1
      let b = 2 - 1 + 1
      let c = a * (b -1)
      let d = 1 + 2 * c
      let e = (a + 5) * (b-2) - ((c-2) * (d+1) )
    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert Map.get(env_map, "a") == 5
    assert Map.get(env_map, "b") == 2
    assert Map.get(env_map, "c") == 5
    assert Map.get(env_map, "d") == 11
    assert Map.get(env_map, "e") == -36
  end

  @tag :ast_driver_test2
  test "simple ast driver test3" do
    input = ~c"program abc {
      let a = 1
      let b = 2
      let c = a + b
      let d = c *2  == ( a + b ) * 2
      let e = f
    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert Map.get(env_map, "a") == 1
    assert Map.get(env_map, "b") == 2
    assert Map.get(env_map, "c") == 3
    assert Map.get(env_map, "d") == true
  end
end
