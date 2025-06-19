defmodule Viblog.About do
  alias Viblog.About.Section

  use NimblePublisher,
    build: Section,
    from: Application.app_dir(:viblog, "priv/about/*.md"),
    as: :sections

  # Sort sections by order
  @sections Enum.sort_by(@sections, & &1.order)

  # Export them
  def all_sections, do: @sections
end
