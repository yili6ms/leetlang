defmodule LeetlangTest do
  use ExUnit.Case
  doctest Leetlang

  @tag :lex_test
  test "simple lex_test" do
    input = ~c"let a = 2"

    :leetlang_lex.string(input)
    |> IO.inspect()
  end

  @tag :lex_test
  test "simple lex_test2" do
    input = ~c"if (a>1) { a = a + 1} else{b = b -1}"

    :leetlang_lex.string(input)
    |> IO.inspect()
  end

  @tag :parser_test
  test "simple parser_test" do
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

  @tag :ast_driver_test
  test "simple ast driver test" do
    input = ~c"program abc {
      let a = 4 + 1
      let b = 2 - 1 + 1
      let c = a * b -1
      let d = 1 + 2 * c
    }"
    AstDriver.Astdriver.execute_program(input)
  end
end
