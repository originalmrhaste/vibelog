defmodule ViblogWeb.SitemapController do
  use ViblogWeb, :controller

  alias Viblog.Blog

  def index(conn, _params) do
    posts = Blog.all_posts()
    
    sitemap_xml = generate_sitemap_xml(posts)
    
    conn
    |> put_resp_content_type("application/xml")
    |> text(sitemap_xml)
  end

  defp generate_sitemap_xml(posts) do
    base_url = "https://vibelog.fly.dev"
    
    static_pages = [
      %{url: "#{base_url}/", changefreq: "weekly", priority: "1.0", lastmod: most_recent_post_date(posts)},
      %{url: "#{base_url}/blog", changefreq: "daily", priority: "0.9", lastmod: most_recent_post_date(posts)},
      %{url: "#{base_url}/blog-index", changefreq: "weekly", priority: "0.8", lastmod: most_recent_post_date(posts)},
      %{url: "#{base_url}/about", changefreq: "monthly", priority: "0.7", lastmod: nil},
      %{url: "#{base_url}/about/courses", changefreq: "monthly", priority: "0.6", lastmod: nil},
      %{url: "#{base_url}/about/projects", changefreq: "weekly", priority: "0.6", lastmod: nil},
      %{url: "#{base_url}/about/tech-stack", changefreq: "monthly", priority: "0.5", lastmod: nil},
      %{url: "#{base_url}/about/misc", changefreq: "monthly", priority: "0.5", lastmod: nil}
    ]
    
    blog_posts = Enum.map(posts, fn post ->
      %{
        url: "#{base_url}/blog/#{post.id}",
        changefreq: "monthly", 
        priority: "0.8",
        lastmod: Date.to_iso8601(post.date)
      }
    end)
    
    all_urls = static_pages ++ blog_posts
    
    url_entries = Enum.map_join(all_urls, "", &generate_url_entry/1)
    
    """<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
#{url_entries}</urlset>"""
  end

  defp generate_url_entry(%{url: url, changefreq: changefreq, priority: priority, lastmod: lastmod}) do
    lastmod_tag = if lastmod, do: "    <lastmod>#{lastmod}</lastmod>", else: ""
    
    """  <url>
    <loc>#{url}</loc>#{if lastmod_tag != "", do: "\n#{lastmod_tag}", else: ""}
    <changefreq>#{changefreq}</changefreq>
    <priority>#{priority}</priority>
  </url>
"""
  end

  defp most_recent_post_date(posts) do
    case Enum.max_by(posts, & &1.date, Date, fn -> nil end) do
      nil -> nil
      post -> Date.to_iso8601(post.date)
    end
  end
end