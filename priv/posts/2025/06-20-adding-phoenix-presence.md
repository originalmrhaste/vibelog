%{
  title: "Adding Real-Time User Presence to Phoenix Blog",
  author: "Bozidar Mitrovic",
  tags: ~w(phoenix elixir liveview presence real-time claude-code ai-written),
  description: "Converting from Phoenix controllers to LiveView and implementing Phoenix Presence for real-time user tracking"
}
---

After building this blog with traditional Phoenix controllers, I decided to add some real-time magic by implementing **Phoenix Presence** to show how many users are currently reading. This required converting to LiveView and implementing proper presence tracking - and the results are pretty cool!

## What is Phoenix Presence?

Phoenix Presence is Phoenix's built-in solution for tracking process information across a distributed system. It's perfect for features like:
- **"X users online"** counters
- **Real-time user avatars** in chat applications  
- **Live collaboration** indicators
- **Activity feeds** and notifications

The best part? It has **no single point of failure**, requires **no external dependencies**, and **self-heals** across cluster nodes.

## The Challenge

My blog was built using traditional Phoenix controllers with HTTP requests. Presence works best with persistent WebSocket connections, so I needed to convert to LiveView and implement proper real-time presence tracking.

**Before:** Static pages with HTTP requests  
**After:** Interactive LiveView pages with real-time presence counters

## Implementation

### Step 1: Generate Presence Module

Phoenix makes this incredibly easy with a built-in generator:

```bash
mix phx.gen.presence
```

This creates `lib/viblog_web/channels/presence.ex`:

```elixir
defmodule ViblogWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.
  """
  use Phoenix.Presence,
    otp_app: :viblog,
    pubsub_server: Viblog.PubSub
end
```

### Step 2: Add to Supervision Tree

Add the Presence module to your application's supervision tree in `lib/viblog/application.ex`:

```elixir
children = [
  ViblogWeb.Telemetry,
  {DNSCluster, query: Application.get_env(:viblog, :dns_cluster_query) || :ignore},
  {Phoenix.PubSub, name: Viblog.PubSub},
  {Finch, name: Viblog.Finch},
  ViblogWeb.Presence,  # <- Add this line
  ViblogWeb.Endpoint
]
```

**Important:** Presence must come after PubSub and before the Endpoint!

### Step 3: Create LiveView with Presence

I converted from controllers to LiveView and implemented presence tracking. The key insight was to use a **single shared topic** with metadata to track which page each user is on.

**Blog Index LiveView:**

```elixir
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
end
```

**Individual Post LiveView:**

```elixir
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
      
      send(self(), :after_join)
    end

    online_users = if connected?(socket) do
      count_readers_for_post(id)
    else
      0
    end
    
    {:ok, assign(socket, post: post, id: id, online_users: online_users, topic: topic)}
  end

  defp count_readers_for_post(post_id) do
    "blog"
    |> ViblogWeb.Presence.list()
    |> Enum.count(fn {_user_id, %{metas: metas}} ->
      Enum.any?(metas, fn meta -> meta.page == post_id end)
    end)
  end
end
```

### Step 4: Update Router

Replace controller routes with LiveView routes:

```elixir
scope "/", ViblogWeb do
  pipe_through :browser

  live "/", BlogLive
  get "/about", AboutController, :index
  live "/blog", BlogLive  
  live "/blog/:id", BlogShowLive
end
```

## Key Architecture Decisions

### Single Topic with Metadata

Instead of separate topics for each page, I use one shared `"blog"` topic with metadata:
- **Blog index**: `page: "index"`
- **Individual posts**: `page: post_id`

This approach allows:
- **Total readers**: Count all users in the `"blog"` topic
- **Per-post readers**: Filter by `page` metadata
- **Automatic cross-page updates**: All pages subscribe to the same topic

### Proper Lifecycle Management

Following Phoenix Presence patterns:
- Only track presence when `connected?(socket)` is true
- Use `send(self(), :after_join)` for initial state
- Let Phoenix Presence handle automatic cleanup when processes terminate
- Handle `presence_diff` events for real-time updates

## The Results

Now the blog shows real-time user counts:
- **"5 readers online"** on the main blog page (total across all pages)
- **"2 reading now"** on individual posts (specific to that post)
- **Instant updates** when users arrive or leave
- **No database required** - it's all in-memory
- **Works across multiple servers** in a distributed setup

## Development Experience with Claude Code

This entire feature was implemented in collaboration with Claude Code. While it wasn't a one-shot implementation - it required several iterations to get the presence tracking and PubSub patterns right - the AI assistant was invaluable for maintaining code consistency, handling edge cases, and ensuring proper Phoenix conventions were followed throughout the conversion.

## What's Next?

Some ideas for extending this further:
- **User avatars** showing who's currently reading
- **Recent activity** feeds showing page visits  
- **Presence in comments** for real-time discussion
- **Analytics dashboard** using presence data

Phoenix Presence opens up a world of real-time possibilities - and once you understand the proper patterns, it's surprisingly straightforward to implement!

## Try It Yourself

Want to see it in action? Open this blog post in multiple browser tabs and watch the counter update in real-time. The presence system is working right now as you read this!