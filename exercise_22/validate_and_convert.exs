defmodule ValidateAndConvert do
  def validate_and_convert(string) do
    string
    |> convert
    |> and_maybe(&validate/1)
  end

  defp and_maybe({ :ok, value }, func), do: func.(value)
  defp and_maybe(anything_else, _func), do: anything_else

  defp convert(value) when is_binary(value) do
    case Integer.parse(value) do
      {int, _rest} -> {:ok, int}
      :error -> {:error, "String \"#{value}\" can't be parsed into an integer."}
    end
  end

  defp convert(value) when is_integer(value), do: { :ok, value }

  defp validate(value) when is_integer(value) and value > 18 and value < 150 do
    debug(value)
    { :ok, value } 
  end

  defp validate(value) when is_integer(value), do: { :error, "Integer #{value} is out of bounds. It should be greater than 18 and less than 150." } 

  defp debug(value) do
    IO.inspect(value)
    value
  end
end