defmodule ViblogWeb.CoursesLive do
  use ViblogWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    topic = "blog"

    if connected?(socket) do
      ViblogWeb.Endpoint.subscribe(topic)
      
      {:ok, _} = ViblogWeb.Presence.track(self(), topic, socket.id, %{
        joined_at: System.system_time(:second),
        page: "courses"
      })
    end

    {:ok, assign(socket, page_title: "Courses & Books")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="brutal-container">
      <div class="brutal-nav-section">
        <h1>📚 COURSES & BOOKS</h1>
        <.link navigate={~p"/about"} class="brutal-back">← ABOUT</.link>
      </div>

      <div class="brutal-post">
        <h2>COURSES WORTH TAKING</h2>
        <p>Online courses I found useful and would recommend.</p>
        
        <div class="course-list">
          <div class="course-item">
            <h3>Programming Languages</h3>
            <p><strong>By:</strong> Dan Grossman (University of Washington) - <a href="https://www.coursera.org/learn/programming-languages" target="_blank">Coursera</a></p>
            <p>I took the SML part twice and got halfway through the Racket section. This is <strong>the course that opened my eyes to functional programming</strong> and completely changed how I view software. The way Dan explains language concepts, type systems, and functional thinking is unparalleled. This is the course I recommend to everyone who wants to truly understand programming. I'm definitely planning to complete the remaining parts when I get the chance.</p>
          </div>

          <div class="course-item">
            <h3>Learning Phoenix LiveView</h3>
            <p><strong>By:</strong> George Arrowsmith - <a href="https://learnphoenixliveview.com/" target="_blank">learnphoenixliveview.com</a></p>
            <p>A really good text-based course that teaches LiveView concepts step by step with practical examples.</p>
          </div>

          <div class="course-item">
            <h3>Pragmatic Studio Elixir Courses</h3>
            <p><strong>By:</strong> Pragmatic Studio - <a href="https://pragmaticstudio.com/" target="_blank">pragmaticstudio.com</a></p>
            <p>Both the <strong>Fullstack Phoenix</strong> and <strong>Elixir & OTP</strong> courses are excellent for switching to Elixir from other programming languages. They do a great job explaining the Elixir mindset and practical patterns you need to be productive.</p>
          </div>
        </div>
      </div>

      <div class="brutal-post">
        <h2>BOOKS I LIKED</h2>
        <p>Some books that were helpful along the way.</p>
        
        <div class="course-list">
          <div class="course-item">
            <h3>Fluent Python</h3>
            <p><strong>By:</strong> Luciano Ramalho</p>
            <p>Deep dive into Python's features and idioms. Goes way beyond the basics to show how Python really works.</p>
          </div>
          
          <div class="course-item">
            <h3>The Little Schemer</h3>
            <p><strong>By:</strong> Daniel P. Friedman & Matthias Felleisen</p>
            <p>A unique approach to learning recursion and functional thinking through questions and answers.</p>
          </div>
        </div>
      </div>

      <div class="brutal-post">
        <h2>YOUTUBE CHANNELS</h2>
        <p>Channels I follow for learning and keeping up with tech.</p>
        
        <div class="course-list">
          <div class="course-item">
            <h3>Anthony Writes Code</h3>
            <p><strong>Links:</strong> <a href="https://www.youtube.com/@anthonywritescode" target="_blank">YouTube</a> & <a href="https://www.twitch.tv/anthonywritescode" target="_blank">Twitch</a></p>
            <p>Python-focused content with practical coding sessions and code reviews.</p>
          </div>
          
          <div class="course-item">
            <h3>Code and Stuff</h3>
            <p><strong>Link:</strong> <a href="https://www.youtube.com/@CodeAndStuff" target="_blank">YouTube</a></p>
            <p>Diverse programming content covering various languages and concepts. He's been doing more Elixir and Phoenix recently.</p>
          </div>
          
          <div class="course-item">
            <h3>Daniel Bergholz</h3>
            <p><strong>Link:</strong> <a href="https://www.youtube.com/@DanielBergholz" target="_blank">YouTube</a></p>
            <p>Elixir and Phoenix content with tutorials and live coding sessions.</p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end