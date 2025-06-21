defmodule ViblogWeb.AboutLive do
  use ViblogWeb, :live_view

  alias Viblog.About

  @impl true
  def mount(_params, _session, socket) do
    topic = "blog"

    if connected?(socket) do
      ViblogWeb.Endpoint.subscribe(topic)
      
      {:ok, _} = ViblogWeb.Presence.track(self(), topic, socket.id, %{
        joined_at: System.system_time(:second),
        page: "about"
      })
    end

    sections = About.all_sections()
    
    # Add SEO data
    seo_data = ViblogWeb.SEO.about_seo_data()
    
    {:ok, assign(socket, 
      sections: sections, 
      page_title: seo_data.page_title,
      meta_description: seo_data.meta_description,
      canonical_path: seo_data.canonical_path
    )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="brutal-container">
      <h1>ABOUT ME</h1>

      <div class="brutal-nav-cards">
        <.link navigate={~p"/about/courses"} class="brutal-card">
          <h3>📚 LEARN</h3>
          <p>Favorite courses, books, and learning resources that shaped my journey</p>
        </.link>

        <.link navigate={~p"/about/projects"} class="brutal-card">
          <h3>🛠️ BUILD</h3>
          <p>Current projects I'm working on and experiments in progress</p>
        </.link>

        <.link navigate={~p"/about/tech-stack"} class="brutal-card">
          <h3>⚡ STACK</h3>
          <p>Technologies, tools, and frameworks I use for development</p>
        </.link>

        <.link navigate={~p"/about/misc"} class="brutal-card">
          <h3>🎯 MISC</h3>
          <p>Random stuff about me beyond programming and work</p>
        </.link>

        <.link navigate={~p"/blog"} class="brutal-card">
          <h3>✍️ BLOG</h3>
          <p>Technical posts, experiments, and thoughts on software development</p>
        </.link>

        <.link navigate={~p"/blog-index"} class="brutal-card">
          <h3>🔍 INDEX</h3>
          <p>Search and filter all blog posts by tags, date, and content</p>
        </.link>
      </div>

      <%= for section <- @sections do %>
        <div class="brutal-post">
          <h2>{section.title}</h2>
          {raw(section.content)}
        </div>
      <% end %>
    </div>
    """
  end
end