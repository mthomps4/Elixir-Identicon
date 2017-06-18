defmodule Identicon do
  @moduledoc """
  Creates an Identicon based on hashed input. \n
  Identicons are mirrored down the center. \n
  We use the first 15 values to determine a 5x5 square.
  ```
  [ 1, 2, 3, 2, 1]
  [ 4, 5, 6, 5, 4]
  [ 7, 8, 9, 8, 7]
  [10,11,12,11,10]
  [13,14,15,14,15]
  ```
  If value is even color the square... First three values also determine RGB color.
  """

  @doc """
  Main pipes all Identicon methods together and outputs Identicon.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  @doc """
  `hash_input` takes an input and returns a md5 binary hash.
  That hash is then passed into the %Identicon.Image defstruct `hex:`

  ## Examples

      iex> Identicon.hash_input("banana")
      %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}

  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |>:binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  @doc """
    recieves `%Identicon.Image{hex: ...}` and used the first three values to return a RGB value.
    `| _tail` say's I know there is more .. ignore the rest.

  ## Examples

      iex> Identicon.pick_color(%Identicon.Image{hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]})
      %Identicon.Image{color: {145, 46, 200}, hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]}

  """
  # Notes for ref
  # def pick_color(image) do
  #   # %Identicon.Image{hex: hex_list} = image
  #   # [r, g, b | _tail ] = hex_list
  #   # [r, g, b]
  #
  #   %Identicon.Image{hex: [r, g, b | _tail ]} = image
  #   %Identicon.Image{image | color: {r, g, b}}
  # end
  # Shorthand
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail ]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

end
