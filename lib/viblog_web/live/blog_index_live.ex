defmodule ViblogWeb.BlogIndexLive do
  use ViblogWeb, :live_view

  alias Viblog.Blog

  @impl true
  def mount(_params, _session, socket) do
    topic = "blog"

    if connected?(socket) do
      ViblogWeb.Endpoint.subscribe(topic)
      
      {:ok, _} = ViblogWeb.Presence.track(self(), topic, socket.id, %{
        joined_at: System.system_time(:second),
        page: "blog_index"
      })
    end

    all_posts = Blog.all_posts()
    all_tags = Blog.all_tags()
    
    {:ok, assign(socket, 
      page_title: "Blog Index",
      all_posts: all_posts,
      filtered_posts: all_posts,
      all_tags: all_tags,
      selected_tag: nil,
      search_query: "",
      year_filter: nil,
      available_years: get_available_years(all_posts)
    )}
  end

  @impl true
  def handle_event("filter", %{"search_query" => query, "selected_tag" => tag, "year_filter" => year}, socket) do
    search_query = String.trim(query)
    selected_tag = if tag == "", do: nil, else: tag
    year_filter = if year == "", do: nil, else: String.to_integer(year)
    
    filtered_posts = apply_filters(socket.assigns.all_posts, selected_tag, search_query, year_filter)
    
    {:noreply, assign(socket, 
      search_query: search_query,
      selected_tag: selected_tag, 
      year_filter: year_filter,
      filtered_posts: filtered_posts
    )}
  end

  @impl true
  def handle_event("filter_by_tag", %{"tag" => tag}, socket) do
    selected_tag = if tag == "", do: nil, else: tag
    filtered_posts = apply_filters(socket.assigns.all_posts, selected_tag, socket.assigns.search_query, socket.assigns.year_filter)
    
    {:noreply, assign(socket, selected_tag: selected_tag, filtered_posts: filtered_posts)}
  end

  @impl true
  def handle_event("clear_filters", _params, socket) do
    {:noreply, assign(socket, 
      selected_tag: nil,
      search_query: "",
      year_filter: nil,
      filtered_posts: socket.assigns.all_posts
    )}
  end

  defp apply_filters(posts, tag, search_query, year) do
    posts
    |> filter_by_tag(tag)
    |> filter_by_search(search_query)
    |> filter_by_year(year)
  end

  defp filter_by_tag(posts, nil), do: posts
  defp filter_by_tag(posts, tag), do: Enum.filter(posts, &(tag in &1.tags))

  defp filter_by_search(posts, ""), do: posts
  defp filter_by_search(posts, query) do
    query_lower = String.downcase(query)
    Enum.filter(posts, fn post ->
      String.contains?(String.downcase(post.title), query_lower) or
      String.contains?(String.downcase(post.description), query_lower)
    end)
  end

  defp filter_by_year(posts, nil), do: posts
  defp filter_by_year(posts, year), do: Enum.filter(posts, &(&1.date.year == year))

  defp get_available_years(posts) do
    posts
    |> Enum.map(&(&1.date.year))
    |> Enum.uniq()
    |> Enum.sort(:desc)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="brutal-container">
      <div class="brutal-nav-section">
        <h1>📝 BLOG INDEX</h1>
        <.link navigate={~p"/about"} class="brutal-back">← ABOUT</.link>
      </div>

      <div class="brutal-post">
        <h2>SEARCH & FILTER</h2>
        
        <.form for={%{}} phx-change="filter" class="blog-filters">
          <div class="filter-group">
            <.input 
              type="text"
              name="search_query"
              value={@search_query}
              placeholder="Search titles and descriptions..."
              label="Search posts:"
              class="brutal-input"
              phx-debounce="300"
            />
          </div>

          <div class="filter-group">
            <.input 
              type="select"
              name="selected_tag"
              value={@selected_tag || ""}
              options={[{"All tags", ""} | Enum.map(@all_tags, &{&1, &1})]}
              label="Filter by tag:"
              class="brutal-select"
            />
          </div>

          <div class="filter-group">
            <.input 
              type="select"
              name="year_filter"
              value={@year_filter || ""}
              options={[{"All years", ""} | Enum.map(@available_years, &{to_string(&1), to_string(&1)})]}
              label="Filter by year:"
              class="brutal-select"
            />
          </div>

          <button type="button" phx-click="clear_filters" class="brutal-button">Clear All Filters</button>
        </.form>
      </div>

      <div class="brutal-post">
        <h2>POSTS ({length(@filtered_posts)})</h2>
        
        <%= if @filtered_posts == [] do %>
          <p>No posts found matching your filters.</p>
        <% else %>
          <div class="post-list">
            <%= for post <- @filtered_posts do %>
              <article class="post-item">
                <h3><.link navigate={~p"/blog/#{post}"} class="post-link">{post.title}</.link></h3>
                
                <div class="post-meta">
                  <time>{Calendar.strftime(post.date, "%B %d, %Y")}</time>
                  <%= if post.tags != [] do %>
                    <div class="post-tags">
                      <%= for tag <- post.tags do %>
                        <button phx-click="filter_by_tag" phx-value-tag={tag} class="tag-button">{tag}</button>
                      <% end %>
                    </div>
                  <% end %>
                </div>
                
                <p class="post-description">{post.description}</p>
              </article>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end