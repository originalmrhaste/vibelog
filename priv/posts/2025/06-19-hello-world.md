%{
  title: "Hello World! Creating a Blog with Claude Code",
  author: "Bozidar Mitrovic",
  tags: ~w(meta phoenix elixir claude-code ai-written),
  description: "The first post about creating this Phoenix blog with Claude Code"
}
---

Welcome to my new blog! This first post is a bit meta - it's about creating this very blog using **Claude Code**.

## The Journey

I decided to build a simple blog using Phoenix, Elixir's web framework. What made this interesting was using Claude Code as my development assistant throughout the entire process.

## What We Built

- **Phoenix 1.7.21** application without Ecto (no database needed for a simple blog)
- **File-based blog posts** stored in Markdown format under `/priv/posts/`
- **Organized by year** with the format `/priv/posts/YEAR/MONTH-DAY-ID.md`
- **Metadata system** using Elixir maps for post frontmatter
- **Modern stack** with LiveView, Tailwind CSS, and Heroicons
- **About section** using the same NimblePublisher pattern for modular content
- **Neo-brutalist design** with aggressive colors and bold typography
- **Syntax highlighting** for Elixir code blocks
- **Tag system** with automatic extraction and filtering
- **Custom navigation** and layouts replacing default Phoenix styling

## The Approach

I followed the excellent [Elixir School guide on NimblePublisher](https://elixirschool.com/en/lessons/misc/nimble_publisher#installing-nimblepublisher-2) to build this blog. The approach was simple: I would copy sections from the guide and paste them into Claude Code, which would then implement them in our Phoenix project.

## The Experience

Working with Claude Code was surprisingly smooth. It helped me:

1. Set up the Phoenix project structure correctly
2. Configure the development environment with proper Elixir/Erlang versions
3. Create a comprehensive `CLAUDE.md` file for future development sessions
4. Establish this blog post structure and organization
5. Implement the NimblePublisher integration following the guide step-by-step
6. Build the complete blog functionality (posts, tags, about sections)
7. Create the neo-brutalist design when I asked for something more aggressive
8. Fix layout issues and make it deployment-ready


## The Styling

When the blog was first running, it looked pretty bland with default Phoenix styling. I asked Claude Code to make it styled in "neo-brutalism" - and wow, did it deliver! 

The result is an aggressive, in-your-face design with:
- **Bold typography** using JetBrains Mono font with heavy weights
- **Aggressive colors** like hot pink, neon green, and electric yellow
- **Thick black borders** and chunky drop shadows everywhere
- **High contrast** black background with white content boxes
- **No subtle design elements** - everything screams for attention

It's the perfect aesthetic for a developer blog that doesn't want to blend into the background!

## What's Next

This blog will serve as a place to document my development journey, share insights about Elixir and Phoenix, and explore new technologies. All powered by this simple yet elegant file-based approach.

The beauty of this setup is its simplicity - no database complexity, just Markdown files that can be version controlled alongside the code.