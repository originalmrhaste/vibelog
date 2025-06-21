defmodule ViblogWeb.TechStackLive do
  use ViblogWeb, :live_view

  alias Viblog.About

  @impl true
  def mount(_params, _session, socket) do
    topic = "blog"

    if connected?(socket) do
      ViblogWeb.Endpoint.subscribe(topic)
      
      {:ok, _} = ViblogWeb.Presence.track(self(), topic, socket.id, %{
        joined_at: System.system_time(:second),
        page: "tech-stack"
      })
    end

    # Get the tech-stack section content
    sections = About.all_sections()
    tech_section = Enum.find(sections, &(&1.title == "TECH STACK"))
    
    {:ok, assign(socket, tech_section: tech_section, page_title: "Tech Stack")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="brutal-container">
      <div class="brutal-nav-section">
        <h1>⚡ TECH STACK</h1>
        <.link navigate={~p"/about"} class="brutal-back">← ABOUT</.link>
      </div>

      <%= if @tech_section do %>
        <div class="brutal-post">
          <h2>{@tech_section.title}</h2>
          {raw(@tech_section.content)}
        </div>
      <% else %>
        <div class="brutal-post">
          <h2>CURRENT STACK</h2>
          <p>Technologies and tools I'm currently using for development.</p>
          
          <h3>Backend</h3>
          <ul>
            <li><strong>Elixir/Phoenix:</strong> Primary backend framework</li>
            <li><strong>Phoenix LiveView:</strong> Real-time user interfaces</li>
            <li><strong>PostgreSQL:</strong> Database of choice</li>
          </ul>
          
          <h3>Frontend</h3>
          <ul>
            <li><strong>Phoenix LiveView:</strong> Real-time user interfaces</li>
            <li><strong>Tailwind CSS:</strong> Utility-first styling</li>
            <li><strong>HEEx:</strong> Phoenix template language</li>
          </ul>
          
          <h3>Development</h3>
          <ul>
            <li><strong>Claude Code:</strong> AI-assisted development</li>
            <li><strong>Vim bindings:</strong> Wherever I go</li>
            <li><strong>Git/GitHub:</strong> Version control</li>
            <li><strong>Fly.io:</strong> Deployment platform</li>
          </ul>
        </div>
      <% end %>
    </div>
    """
  end
end