defmodule Viblog.Blog do
  alias Viblog.Blog.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:viblog, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_eex, :makeup_html]

  # The @posts variable is first defined by NimblePublisher.
  # Let's further modify it by sorting all posts by descending date.
  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  # Let's also get all tags
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  # And finally export them
  def all_posts, do: @posts
  def all_tags, do: @tags

  def recent_posts(num \\ 5), do: Enum.take(all_posts(), num)

  defmodule NotFoundError, do: defexception([:message, plug_status: 404])

  def get_post_by_id!(id) do
    Enum.find(all_posts(), &(&1.id == id)) ||
      raise NotFoundError, "post with id=#{id} not found"
  end

  def get_posts_by_tag!(tag) do
    case Enum.filter(all_posts(), &(tag in &1.tags)) do
      [] -> raise NotFoundError, "posts with tag=#{tag} not found"
      posts -> posts
    end
  end

  def get_related_posts(current_post, limit \\ 3) do
    all_posts()
    |> Enum.reject(&(&1.id == current_post.id))
    |> Enum.map(fn post ->
      shared_tags = MapSet.intersection(MapSet.new(current_post.tags), MapSet.new(post.tags))
      {post, MapSet.size(shared_tags)}
    end)
    |> Enum.filter(fn {_post, shared_count} -> shared_count > 0 end)
    |> Enum.sort_by(fn {_post, shared_count} -> shared_count end, :desc)
    |> Enum.map(fn {post, _shared_count} -> post end)
    |> Enum.take(limit)
  end
end
