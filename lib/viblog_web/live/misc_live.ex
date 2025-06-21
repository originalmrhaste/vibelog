defmodule ViblogWeb.MiscLive do
  use ViblogWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    topic = "blog"

    if connected?(socket) do
      ViblogWeb.Endpoint.subscribe(topic)
      
      {:ok, _} = ViblogWeb.Presence.track(self(), topic, socket.id, %{
        joined_at: System.system_time(:second),
        page: "misc"
      })
    end

    {:ok, assign(socket, page_title: "Misc")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="brutal-container">
      <div class="brutal-nav-section">
        <h1>🎯 MISC STUFF</h1>
        <.link navigate={~p"/about"} class="brutal-back">← ABOUT</.link>
      </div>

      <div class="brutal-post">
        <h2>SPORTS & ACTIVITIES</h2>
        
        <div class="course-list">
          <div class="course-item">
            <h3>Padel</h3>
            <p>I love playing padel - it's the perfect mix of strategy and athleticism.</p>
          </div>
          
          <div class="course-item">
            <h3>Gym & Natty Sphere</h3>
            <p>I go to gym and follow the noble natty sphere. Check out <a href="https://www.youtube.com/@GeoffreyVeritySchofield" target="_blank">Geoffrey Verity Schofield</a> for solid advice.</p>
          </div>
          
          <div class="course-item">
            <h3>Fencing History</h3>
            <p>I was 3rd in city in foil fencing as a kid :shocker:</p>
          </div>
        </div>
      </div>

      <div class="brutal-post">
        <h2>FOOD & DRINK</h2>
        
        <div class="course-list">
          <div class="course-item">
            <h3>Home Cooking</h3>
            <p>I love experimenting with different cuisines at home - always trying new recipes and techniques.</p>
          </div>
          
          <div class="course-item">
            <h3>Craft Beer</h3>
            <p>I love craft beer and exploring different styles and breweries.</p>
          </div>
        </div>
      </div>

      <div class="brutal-post">
        <h2>FANDOMS</h2>
        
        <div class="course-list">
          <div class="course-item">
            <h3>Sports Teams</h3>
            <p>Arsenal fan in football, Partizan fan in general (mostly follow basketball) - yes, I enjoy suffering.</p>
          </div>
          
          <div class="course-item">
            <h3>League of Legends</h3>
            <p>League of Legends enjoyer who thinks he understands the game on a very high level.</p>
          </div>
        </div>
      </div>

      <div class="brutal-post">
        <h2>MUSICAL PAST</h2>
        
        <div class="course-list">
          <div class="course-item">
            <h3>Double Bass</h3>
            <p>I used to play double bass as a kid - those were some heavy lifting days!</p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end