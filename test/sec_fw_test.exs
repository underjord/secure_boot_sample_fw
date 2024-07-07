defmodule SecFwTest do
  use ExUnit.Case
  doctest SecFw

  test "greets the world" do
    assert SecFw.hello() == :world
  end
end
