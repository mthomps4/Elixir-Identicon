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
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_grid
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

  @doc """
    `build_grid` takes the hex values and chuncks them into "rows" of 3.
    Those "rows" are then mapped over and the function `mirror_row` is referenced return the new mirrored "row" as the mapping occurs.
    The list is then flattend and indexes are added for future use.

  ## Examples

      iex(13)> Identicon.build_grid(%Identicon.Image{hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]})
      %Identicon.Image{color: nil, grid: [{145, 0}, {46, 1}, {200, 2}, {46, 3}, {145, 4}, {3, 5}, {178, 6}, {206, 7}, {178, 8}, {3, 9}, {73, 10}, {228, 11}, {165, 12}, {228, 13}, {73, 14}, {65, 15}, {6, 16}, {141, 17}, {6, 18}, {65, 19}, {73, 20}, {90, 21}, {181, 22}, {90, 23}, {73, 24}], hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]}

  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      #&mirror_row/1 -- & to reference function -- If more than one mirror_row function exists find the one with an airity of 1.
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    `mirror_row` takes a row, finds the first and second falue of the row and appends to the list using `++`

  ## Examples

      iex> Identicon.mirror_row([146, 2, 4])
      [146, 2, 4, 2, 146]

  """
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @doc """
    filter_odd_squares takes each "square" out of grid and filters the odd values out.

  ## Examples

      iex> Identicon.filter_odd_squares(%Identicon.Image{color: nil, grid: [{145, 0}, {46, 1}, {200, 2}, {46, 3}, {145, 4}, {3, 5}, {178, 6}, {206, 7}, {178, 8}, {3, 9}, {73, 10}, {228, 11}, {165, 12}, {228, 13}, {73, 14}, {65, 15}, {6, 16}, {141, 17}, {6, 18}, {65, 19}, {73, 20}, {90, 21}, {181, 22}, {90, 23}, {73, 24}], hex: nil})
      %Identicon.Image{color: nil, grid: [{46, 1}, {200, 2}, {46, 3}, {178, 6}, {206, 7}, {178, 8}, {228, 11}, {228, 13}, {6, 16}, {6, 18}, {90, 21}, {90, 23}], hex: nil}

  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn({code, _index}) ->
        rem(code, 2) == 0 # remainder
      end)

    %Identicon.Image{image | grid: grid}
  end


  @doc """
    `build_pixel_grid` ...

  ## Examples

      iex> Identicon.build_pixel_grid(%Identicon.Image{color: nil, grid: [{46, 1}, {200, 2}, {46, 3}, {178, 6}, {206, 7}, {178, 8}, {228, 11}, {228, 13}, {6, 16}, {6, 18}, {90, 21}, {90, 23}], hex: nil})
      [{{50, 0}, {100, 50}}, {{100, 0}, {150, 50}}, {{150, 0}, {200, 50}}, {{50, 50}, {100, 100}}, {{100, 50}, {150, 100}}, {{150, 50}, {200, 100}}, {{50, 100}, {100, 150}}, {{150, 100}, {200, 150}}, {{50, 150}, {100, 200}}, {{150, 150}, {200, 200}}, {{50, 200}, {100, 250}}, {{150, 200}, {200, 250}}]

  """
  def build_pixel_grid(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn({_code, index}) ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

end
