defmodule Identicon do
  @moduledoc """
  Methods for creating an Identicon based on hashed input
  Input retuns a list of 16.
  Identicons are mirrored down the center.
  Using the first 15 values to determine a 5x5 square.
  [1,2,3,2,1]
  [4,5,6,5,4]
  [7,8,9,8,7]
  [10,11,12,11,10]
  [13,14,15,14,15]
  If value is even color the square...
  First three values also determine RGB color. 
  """

  @doc """
    Main ...
  """
  def main(input) do
    input
    |> hash_input
  end

  @doc """
    `hash_input` takes an input and returns a md5 binary hash

  ## Examples

      iex> Identicon.hash_input("banana")
      [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]

  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |>:binary.bin_to_list
  end

  @doc """
    `dd`

  ## Examples

      iex> Identicon.hash_input("banana")
      [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]

  """
  def  do

  end

end
