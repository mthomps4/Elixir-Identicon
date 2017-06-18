defmodule Identicon.Image do

  @moduledoc """
  Creates a struct to hold all of our applicaions data.
  _(List of hash values, color, etc)_
  """

  @doc """
    Creates a struct with the following properties:

    - `hex` to hold list of hash values
    - `color` to store the RGB value
    - `grid` to store even hexed values at index
    - `pixel_map` to store the built 50px block map squared from `grid` 
    ```
    %Identicon.Image{color: ..., hex: ..., grid: ...}
    ```
  """
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil

end
