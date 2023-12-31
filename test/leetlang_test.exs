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
      let xx =  a == b || (a != b  && a == 2)
    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert Map.get(env_map, "a") == 1
    assert Map.get(env_map, "b") == 2
    assert Map.get(env_map, "c") == 3
    assert Map.get(env_map, "d") == true
  end

  @tag :ast_driver_test_if
  test "simple ast driver test if" do
    input = ~c"program abc {
      let a = 1
      let b = 2
      if (a > b)
      {
        let c = 3
      }
      else
      {
        let d = 4
        let a = 10
      }

      let a1 = 2
      let b2 = 3
      if (a1 < b2)
      {
        let c1 = 10
        if (a > b) {
          let d1 = 4
        }
        else
          {
            let d1 = 5
          }
      }

    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert Map.get(env_map, "a") == 10
    assert Map.get(env_map, "b") == 2
    assert Map.get(env_map, "c") == nil
    assert Map.get(env_map, "d") == 4
    assert Map.get(env_map, "a1") == 2
    assert Map.get(env_map, "b2") == 3
    assert Map.get(env_map, "c1") == 10
    assert Map.get(env_map, "d1") == 4
  end

  @tag :ast_driver_test_while
  test "simple ast driver test while" do
    input = ~c"program abc {
      let a = 1
      let b = 2
      let cnt = 0
      while (a<3)
      {
        if (a == 1)
        {
          let a = a + 1
          let cnt = cnt + a
        }
        else
        {
          let a = a + 10
          let cnt = cnt + a
        }

      }
    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert Map.get(env_map, "a") == 12
    assert Map.get(env_map, "b") == 2
    assert Map.get(env_map, "cnt") == 14
  end

  @tag :ast_driver_test_function
  test "simple ast driver test func01" do
    input = ~c"program abc {
      let_fn func01 = (a -> int b->int) -> int {
        let c = a + b
        let d = func02.()
        return c + d
      }

      let_fn func02 = () -> int {
        let a = 1
        let b = 2
        return a + b
      }

      let_fn func03 = () -> int{
        let a = func02.()
        let b = 1
        return a + b
      }
      let x = 1
      let y = 2
      let z = x + y
      let aaa = func01.(x z)
    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert Map.get(env_map, "x") == 1
    assert Map.get(env_map, "y") == 2
    assert Map.get(env_map, "z") == 3
    assert Map.get(env_map, "aaa") == 7
  end

  @tag :ast_driver_test_function_fib
  test "simple ast driver test func rec" do
    input = ~c"program abc {
      let_fn fib = (n -> int) -> int {
        let c = 1
        if (n >= 3) {
          let a =  fib.(n-1)
          let b = fib.(n-2)
          let c = a + b
        }
        return c
      }

      let ans = fib.(10)

    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert Map.get(env_map, "ans") == 55
  end

  @tag :ast_driver_test_function_fib_with_return
  test "simple ast driver test func rec2" do
    input = ~c"program abc {
      let_fn fib = (n -> int) -> int {
        let c = 1
        if (n >= 3) {
          let a =  fib.(n-1)
          let b = fib.(n-2)
          let c = a + b
        }
        return c
      }

      let ans = fib.(10)
      return ans

    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert env_map == 55
  end

  @tag :ast_driver_test_shadow
  test "simple ast driver test func shadowing" do
    input = ~c"program abc {
      let a = 1
      let b = 2
      let a = a + b
      let a = true
      return a
    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert env_map == true
  end

  @tag :ast_driver_test_array
  test "simple ast driver test array" do
    input = ~c"program abc {
      let a = [1,2,3] ++ [4,5,6] ++ [7,8,9]
      let b = :a -- [3,6,9]
      return b
    }"
    env_map = AstDriver.Astdriver.execute_program(input)
    assert env_map == [1,2,4,5,7,8]
  end

  @tag :ast_driver_test_array2
  test "simple ast driver test array2" do
    input = ~c"program abc {
      let_fn fib = (n -> int) -> int {
        let c = 1
        if (n >= 3) {
          let a =  fib.(n-1)
          let b = fib.(n-2)
          let c = a + b
        }
        return c
      }
      let a = []
      let cnt = 0
      while (cnt < 10)
      {
        let cnt = cnt + 1
        let a = :a ++ [fib.(cnt)]
      }
      return a
    }"
    env_map = AstDriver.Astdriver.execute_program(input) |> IO.inspect()
  end
end
