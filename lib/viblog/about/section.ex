defmodule Viblog.About.Section do
  @enforce_keys [:id, :title, :content, :order]
  defstruct [:id, :title, :content, :order]

  def build(filename, attrs, body) do
    [id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-1)
    struct!(__MODULE__, [id: id, content: body] ++ Map.to_list(attrs))
  end
end