# leetlang

A Toy Language Impl

The motivation of implementing this toy language is for fun :).
The grammar of this language is very simple, but combines with several interesting features.

The only entry point is program, now it supports four arithmetic operations, boolean expression, if-else statement, while loop, function definition and function call.

Supported type is just int, boolean, array and void.

Execution is based on AST, and the AST is generated by parser, which is implemented by leex and yecc.

Later will add JIT support and LLVM integration.

## Grammer

Declearation:
let a = 1
let b = a > 1
let_fn func1 = (n -> int) -> int { return n + 1 }

if-else:
if (a > 1) {
  return 1
} else {
  return 2
}

while:
let cnt = 0
while (cnt < 10) {
  let cnt = cnt + 1
}

function call:
let a = func1.(1)
let b = func1.(a1 + 1)

See example to explore more...

## How to run?
./leetlang "path to source code", if you're in windows, run escript to generate executable file again

## Todo list
- [x] Lexer
- [x] Parser
- [x] AST
- [x] Interpreter
- [x] Built-in list support
- [ ] LLVM integration
- [ ] JIT support/Optimization
- [ ] Simple type inference
- [ ] Readonly closure support
- [ ] Coroutine support
- [ ] Language server support
[ ] ...



Example code:

```leetlang
program abc
{
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
}
```

```
Output: 55
```


```leetlang
program abc
{
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
}
```
```
Output: [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `leetlang` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:leetlang, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/leetlang>.
