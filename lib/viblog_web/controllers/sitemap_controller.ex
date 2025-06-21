defmodule ViblogWeb.SitemapController do
  use ViblogWeb, :controller

  alias Viblog.Blog

  def index(conn, _params) do
    posts = Blog.all_posts()
    
    xml_content = build_sitemap_xml(posts)
    
    conn
    |> put_resp_content_type("text/xml; charset=utf-8")
    |> send_resp(200, xml_content)
  end

  defp build_sitemap_xml(posts) do
    base_url = "https://vibelog.fly.dev"
    recent_date = get_most_recent_date(posts)
    
    # Static pages
    static_urls = [
      build_url_entry("#{base_url}/", recent_date, "weekly", "1.0"),
      build_url_entry("#{base_url}/blog", recent_date, "daily", "0.9"),
      build_url_entry("#{base_url}/blog-index", recent_date, "weekly", "0.8"),
      build_url_entry("#{base_url}/about", nil, "monthly", "0.7"),
      build_url_entry("#{base_url}/about/courses", nil, "monthly", "0.6"),
      build_url_entry("#{base_url}/about/projects", nil, "weekly", "0.6"),
      build_url_entry("#{base_url}/about/tech-stack", nil, "monthly", "0.5"),
      build_url_entry("#{base_url}/about/misc", nil, "monthly", "0.5")
    ]
    
    # Blog post URLs
    blog_urls = Enum.map(posts, fn post ->
      build_url_entry("#{base_url}/blog/#{post.id}", Date.to_iso8601(post.date), "monthly", "0.8")
    end)
    
    all_urls = static_urls ++ blog_urls
    
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" <>
    "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n" <>
    Enum.join(all_urls, "\n") <>
    "\n</urlset>"
  end

  defp build_url_entry(url, lastmod, changefreq, priority) do
    lastmod_tag = if lastmod, do: "    <lastmod>#{lastmod}</lastmod>\n", else: ""
    
    "  <url>\n" <>
    "    <loc>#{url}</loc>\n" <>
    lastmod_tag <>
    "    <changefreq>#{changefreq}</changefreq>\n" <>
    "    <priority>#{priority}</priority>\n" <>
    "  </url>"
  end

  defp get_most_recent_date(posts) do
    case Enum.max_by(posts, & &1.date, Date, fn -> nil end) do
      nil -> nil
      post -> Date.to_iso8601(post.date)
    end
  end
end