defmodule ViblogWeb.BlogLive do
  use ViblogWeb, :live_view

  alias Viblog.Blog

  @impl true
  def mount(_params, _session, socket) do
    topic = "blog"

    if connected?(socket) do
      ViblogWeb.Endpoint.subscribe(topic)
      
      {:ok, _} = ViblogWeb.Presence.track(self(), topic, socket.id, %{
        joined_at: System.system_time(:second),
        page: "index"
      })
      
      # Send initial presence state
      send(self(), :after_join)
    end

    posts = Blog.all_posts()
    online_users = if connected?(socket) do
      topic |> ViblogWeb.Presence.list() |> map_size()
    else
      0
    end

    {:ok, assign(socket, posts: posts, online_users: online_users, topic: topic)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    online_users = socket.assigns.topic |> ViblogWeb.Presence.list() |> map_size()
    {:noreply, assign(socket, online_users: online_users)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _diff}, socket) do
    online_users = "blog" |> ViblogWeb.Presence.list() |> map_size()
    {:noreply, assign(socket, online_users: online_users)}
  end

  defp reader_text(1), do: "reader"
  defp reader_text(_), do: "readers"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="brutal-container">
      <div class="brutal-nav-section">
        <h1>VIBELOG</h1>
        <.link navigate={~p"/blog/adding-phoenix-presence"} class="brutal-meta-inline" title="How does this work?">
          {@online_users} {reader_text(@online_users)} online
        </.link>
      </div>

      <%= for post <- @posts do %>
        <div id={post.id} class="brutal-post">
          <h2>
            <.link navigate={~p"/blog/#{post.id}"}>{post.title}</.link>
          </h2>

          <div class="brutal-meta">
            <time>{post.date}</time> by {post.author}
          </div>

          <div class="brutal-tags">
            TAGGED: {Enum.join(post.tags, " • ")}
          </div>

          <%= if "ai-written" in post.tags or "claude-code" in post.tags do %>
            <div class="brutal-caution">
              ⚠️ CAUTION! This article and code were written with AI assistance ⚠️
            </div>
          <% end %>

          {raw(post.description)}
        </div>
      <% end %>
    </div>
    """
  end
end
