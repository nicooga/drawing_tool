ExUnit.start()

defmodule ValidateAndConvertText do
  use ExUnit.Case

  test "when value is a valid string" do
    assert ValidateAndConvert.validate_and_convert("123") == { :ok, 123 }
  end

  test "when value is an invalid string" do
    assert ValidateAndConvert.validate_and_convert("asdf1234") == { :error, "String \"asdf1234\" can't be parsed into an integer." }
  end

  test "when value is a valid integer" do
    assert ValidateAndConvert.validate_and_convert(123) == { :ok, 123 }
  end

  test "when value is an invalid integer" do
    assert ValidateAndConvert.validate_and_convert(151) == { :error, "Integer 151 is out of bounds. It should be greater than 18 and less than 150." }
  end
end