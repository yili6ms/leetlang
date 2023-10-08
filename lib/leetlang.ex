defmodule Leetlang do
  alias LeetLang.Runner
  def main(_) do
    parsed =
      System.argv()
      |> OptionParser.parse(strict: [source: :string])

    with {_, [path], []} <- parsed do
      Runner.run_code(path)
    else
      _ ->
        IO.inspect("not supported...")
        System.halt(1)
    end
  end

end
