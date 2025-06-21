defmodule ViblogWeb.ProjectsLive do
  use ViblogWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    topic = "blog"

    if connected?(socket) do
      ViblogWeb.Endpoint.subscribe(topic)
      
      {:ok, _} = ViblogWeb.Presence.track(self(), topic, socket.id, %{
        joined_at: System.system_time(:second),
        page: "projects"
      })
    end

    {:ok, assign(socket, page_title: "Current Projects")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="brutal-container">
      <div class="brutal-nav-section">
        <h1>🛠️ CURRENT PROJECTS</h1>
        <.link navigate={~p"/about"} class="brutal-back">← ABOUT</.link>
      </div>

      <div class="brutal-post">
        <h2>ACTIVE PROJECTS</h2>
        <p>Current experiments and projects I'm working on.</p>
        
        <div class="course-list">
          <div class="course-item">
            <h3>Vibelog - This Blog</h3>
            <p><strong>Tech:</strong> Phoenix LiveView, NimblePublisher, Tailwind CSS</p>
            <p>A neo-brutalist blog built with Phoenix LiveView featuring real-time presence tracking and syntax highlighting.</p>
            <p><strong>Status:</strong> Live and actively developing</p>
          </div>
        </div>
      </div>

      <div class="brutal-post">
        <h2>UPCOMING IDEAS</h2>
        <p>Projects on the horizon and ideas I'm exploring.</p>
        
        <div class="course-list">
          <div class="course-item">
            <h3>Better LoLPros</h3>
            <p><strong>Tech:</strong> TBD</p>
            <p>Website that monitors high elo League of Legends players and connects that data to live played matches on Twitch.</p>
            <p><strong>Status:</strong> Planning phase</p>
          </div>
          
          <div class="course-item">
            <h3>Improvement Center</h3>
            <p><strong>Tech:</strong> TBD</p>
            <p>Way to track your multiple account progress, reviews for serious League of Legends players.</p>
            <p><strong>Status:</strong> Idea stage</p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end