defmodule LeetLang.Runner do
  alias AstDriver.Astdriver

  def run_code(file_name) do
    file = File.read!(file_name)
    execute_program(file)
  end

  defp execute_program(input) do
    ret = Astdriver.execute_program(to_charlist(input))
    IO.puts("Result: #{inspect(ret)}")
  end

end
