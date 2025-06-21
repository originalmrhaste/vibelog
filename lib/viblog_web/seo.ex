defmodule ViblogWeb.SEO do
  @moduledoc """
  SEO helper functions for generating meta tags, Open Graph data, and structured data.
  """

  @default_description "Bozidar Mitrovic's blog about Elixir, Phoenix, and software development. Exploring AI-assisted development and building useful software."
  @default_image "/images/logo.svg"
  @site_name "Vibelog"
  @site_url "https://vibelog.fly.dev"

  def page_title(nil), do: @site_name
  def page_title(""), do: @site_name
  def page_title(title), do: "#{title} | #{@site_name}"

  def meta_description(nil), do: @default_description
  def meta_description(""), do: @default_description
  def meta_description(description), do: description

  def canonical_url(path), do: "#{@site_url}#{path}"

  def open_graph_data(assigns) do
    %{
      title: page_title(assigns[:page_title]),
      description: meta_description(assigns[:meta_description]),
      type: assigns[:og_type] || "website",
      url: canonical_url(assigns[:canonical_path] || "/"),
      image: assigns[:og_image] || "#{@site_url}#{@default_image}",
      site_name: @site_name
    }
  end


  def blog_post_seo_data(post) do
    %{
      page_title: post.title,
      meta_description: post.description,
      og_type: "article",
      canonical_path: "/blog/#{post.id}",
      og_image: "#{@site_url}#{@default_image}",
      article_data: %{
        author: post.author,
        published_time: Date.to_iso8601(post.date),
        tags: post.tags
      }
    }
  end

  def blog_index_seo_data do
    %{
      page_title: "Blog",
      meta_description: "Technical posts about Elixir, Phoenix, AI-assisted development, and software engineering experiments.",
      canonical_path: "/blog"
    }
  end

  def about_seo_data do
    %{
      page_title: "About",
      meta_description: "Software engineer focused on Elixir, Phoenix, and functional programming. Building useful software with AI assistance.",
      canonical_path: "/about"
    }
  end

  def generate_json_ld_blog_post(post) do
    %{
      "@context" => "https://schema.org",
      "@type" => "BlogPosting",
      "headline" => Phoenix.HTML.html_escape(post.title),
      "description" => Phoenix.HTML.html_escape(post.description),
      "author" => %{
        "@type" => "Person",
        "name" => Phoenix.HTML.html_escape(post.author),
        "url" => @site_url
      },
      "publisher" => %{
        "@type" => "Person",
        "name" => "Bozidar Mitrovic",
        "url" => @site_url
      },
      "datePublished" => Date.to_iso8601(post.date),
      "dateModified" => Date.to_iso8601(post.date),
      "url" => "#{@site_url}/blog/#{post.id}",
      "mainEntityOfPage" => %{
        "@type" => "WebPage",
        "@id" => "#{@site_url}/blog/#{post.id}"
      },
      "keywords" => Enum.join(post.tags, ", "),
      "articleSection" => "Technology"
    }
  end

  def generate_json_ld_website do
    %{
      "@context" => "https://schema.org",
      "@type" => "Website",
      "name" => @site_name,
      "description" => @default_description,
      "url" => @site_url,
      "author" => %{
        "@type" => "Person",
        "name" => "Bozidar Mitrovic",
        "url" => @site_url,
        "sameAs" => [
          "https://bsky.app/profile/bozidarmitrovic.bsky.social"
        ]
      },
      "potentialAction" => %{
        "@type" => "SearchAction",
        "target" => "#{@site_url}/blog-index?search={search_term_string}",
        "query-input" => "required name=search_term_string"
      }
    }
  end
end