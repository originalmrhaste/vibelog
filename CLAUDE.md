# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Phoenix blog application called "Viblog" built without Ecto (database layer). It uses Phoenix LiveView for interactive components and Tailwind CSS for styling.

## Development Commands

- `mix phx.server` - Start the Phoenix server (visit http://localhost:4000)
- `iex -S mix phx.server` - Start server in Interactive Elixir shell
- `mix setup` - Install and setup dependencies
- `mix deps.get` - Install Elixir dependencies
- `mix test` - Run tests
- `mix format` - Format code using Elixir formatter
- `mix check` - Run all code quality checks (format, deps, compile, credo)

## Asset Management

- `mix assets.setup` - Install Tailwind and esbuild if missing
- `mix assets.build` - Build assets for development
- `mix assets.deploy` - Build and minify assets for production

## Architecture

### Application Structure
- **lib/viblog/** - Core application modules
  - `application.ex` - OTP application supervisor tree
  - `mailer.ex` - Email functionality via Swoosh
- **lib/viblog_web/** - Web interface modules
  - `endpoint.ex` - HTTP endpoint configuration
  - `router.ex` - Route definitions
  - `telemetry.ex` - Metrics and monitoring
  - `gettext.ex` - Internationalization

### Web Layer Components
- **Controllers** - Handle HTTP requests and responses
- **HTML modules** - Template rendering and view logic
- **Components** - Reusable UI components using Phoenix.Component
- **Layouts** - Page structure templates (root.html.heex, app.html.heex)

### Key Technologies
- Phoenix 1.7.21 with LiveView 1.0
- Tailwind CSS for styling with Heroicons
- Bandit web server
- esbuild for JavaScript bundling
- No database (--no-ecto flag used)

## Testing

Tests are located in `test/` directory with support modules in `test/support/`. The project uses ExUnit for testing with Floki for HTML parsing in tests.

## Environment Configuration

- Elixir 1.18.2-otp-27
- Erlang 27.3.3
- Development server runs on port 4000
- Hot reloading enabled in development via phoenix_live_reload