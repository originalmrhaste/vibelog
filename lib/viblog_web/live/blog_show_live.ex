defmodule ViblogWeb.BlogShowLive do
  use ViblogWeb, :live_view

  alias Viblog.Blog

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    post = Blog.get_post_by_id!(id)
    topic = "blog"

    if connected?(socket) do
      ViblogWeb.Endpoint.subscribe(topic)

      {:ok, _} = ViblogWeb.Presence.track(self(), topic, socket.id, %{
        joined_at: System.system_time(:second),
        page: id,
        post_title: post.title
      })
      
      # Send initial presence state
      send(self(), :after_join)
    end

    online_users = if connected?(socket) do
      count_readers_for_post(id)
    else
      0
    end
    
    {:ok, assign(socket, post: post, id: id, online_users: online_users, topic: topic)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    online_users = count_readers_for_post(socket.assigns.id)
    {:noreply, assign(socket, online_users: online_users)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _diff}, socket) do
    online_users = count_readers_for_post(socket.assigns.id)
    {:noreply, assign(socket, online_users: online_users)}
  end

  defp count_readers_for_post(post_id) do
    "blog"
    |> ViblogWeb.Presence.list()
    |> Enum.count(fn {_user_id, %{metas: metas}} ->
      Enum.any?(metas, fn meta -> meta.page == post_id end)
    end)
  end

  defp reader_text(1), do: "reader"
  defp reader_text(_), do: "readers"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="brutal-container">
      <div class="brutal-nav-section">
        <.link navigate={~p"/blog"} class="brutal-back">← ALL POSTS</.link>
        <.link navigate={~p"/blog/adding-phoenix-presence"} class="brutal-meta-inline" title="How does this work?">
          {@online_users} {reader_text(@online_users)} reading now
        </.link>
      </div>

      <h1>{@post.title}</h1>

      <div class="brutal-meta">
        <time>{@post.date}</time> by {@post.author}
      </div>

      <div class="brutal-tags">
        TAGGED: {Enum.join(@post.tags, " • ")}
      </div>

      <%= if "ai-written" in @post.tags or "claude-code" in @post.tags do %>
        <div class="brutal-caution">
          ⚠️ CAUTION! This article and code were written with AI assistance ⚠️
        </div>
      <% end %>

      {raw(@post.body)}
    </div>
    """
  end
end
