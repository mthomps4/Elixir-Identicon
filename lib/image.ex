defmodule Identicon.Image do

  @moduledoc """
  Creates a struct to hold all of our applicaions data.
  _(List of hash values, color, etc)_
  """

  @doc """
    Creates a struct with a property of `hex` with default value of nil to hold list of hash values and a property of `color` to store the RGB color. \n
    ```
    %Identicon.Image{color: {145, 46, 200}, hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]}
    ```
  """
  defstruct hex: nil, color: nil

end
