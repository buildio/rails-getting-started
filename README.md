# Getting Started with Ruby on Rails on Build

A barebones [Ruby on Rails](https://rubyonrails.org/) app, ready to deploy to [Build](https://build.io).

Use it as a starting point for your own app, or as a sandbox to learn the Build deployment workflow: buildpacks, Procfiles, config vars, and automatic deploys.

<a href="https://app.build.io/deploy?template=buildio/rails-getting-started">
  <img src="https://app.build.io/deploy-to-build-button.svg" alt="Deploy" width="150px">
</a>

## What's inside

```
.
├── Procfile                              # Tells Build how to start the web process
├── config/routes.rb                      # Routes — pages and API endpoints
├── app/controllers/pages_controller.rb   # Landing page controller
├── app/controllers/api_controller.rb     # JSON API endpoints
├── app/views/pages/index.html.erb        # Landing page template
├── app/assets/stylesheets/               # Static assets
├── .env.example                          # Sample local config (copy to .env)
└── Dockerfile                            # Optional: for the "dockerfile" stack
```

No database is configured — this app skips Active Record to stay minimal.

## Run it locally

First, get your own copy of this template: click **Use this template** on [buildio/rails-getting-started](https://github.com/buildio/rails-getting-started), or fork it, into your own GitHub account.

You'll need Ruby 4.0 or later and Bundler.

```sh
git clone https://github.com/<your-org>/rails-getting-started.git
cd rails-getting-started
bundle install
cp .env.example .env
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000). Rails reloads code on each request in development, so edits show up on refresh.

## Deploy to Build

Build deploys directly from GitHub. If you haven't already, push the repo you cloned in [Run it locally](#run-it-locally) to your own GitHub account:

```sh
git push -u origin main
```

Then, in the [Build dashboard](https://build.io):

1. **Create an app** — click **New + → New App**, give it a name, and pick a region.
2. **Check the stack** — in **Settings**, the default stack with the Ruby buildpack auto-detected from `Gemfile` works out of the box. (Optionally add `https://github.com/heroku/heroku-buildpack-ruby` explicitly.)
3. **Connect GitHub** — in **Deploy → Connection**, select your organisation and connect this repository.
4. **Set the secret** — in **Settings → Config Vars**, add `SECRET_KEY_BASE` (generate one with `bin/rails secret`). Skip this if you deploy via the **Deploy to Build** button — `app.json` generates it for you.
5. **Deploy** — in **Deploy → Manual Deploy**, choose `main` and click **Deploy Branch**. Watch the build run, then click **Go** on the Overview tab to open your live app.

For continuous deployment, enable **Automatic Deploys** on the Deploy tab — every push to `main` then triggers a new build.

## Play with config vars

The landing page greeting is read from the `GREETING` environment variable. Change it with the [Build CLI](https://build.io/docs/guides/cli) — no redeploy needed:

```sh
brew install buildio/cli/bld
bld login
bld config:set GREETING="こんにちは, Build!" -a <your-app>
```

Refresh the page or hit the API:

```sh
curl https://<your-app>.build.io/api/greeting
```

## How it works

- **Procfile** — declares the web process: `web: bundle exec puma -C config/puma.rb`. Build's router sends HTTP traffic only to `web` processes.
- **`$PORT`** — Build injects the port at runtime; `config/puma.rb` reads `ENV["PORT"]`. Never hardcode a port.
- **Config vars** — settings live in environment variables, not in code (twelve-factor style). Locally, `dotenv-rails` loads them from `.env`, which stays out of git.
- **`SECRET_KEY_BASE`** — Rails needs this in production to sign cookies and sessions. On Build it's a config var; `app.json` generates it automatically for one-click deploys.

## Optional: deploy as a container

Prefer Docker? A `Dockerfile` is included. In **Settings → Stack**, select `dockerfile`, then deploy as normal — Build builds the image and runs it instead of using buildpacks.

## Endpoints

| Path | Description |
|------|-------------|
| `/` | Landing page with runtime info |
| `/api/status` | JSON health/uptime endpoint |
| `/api/greeting` | Returns the `GREETING` config var |
| `/up` | Rails' built-in health check |

## Next steps

- Uncomment the sample route in `config/routes.rb` and the matching action in `app/controllers/pages_controller.rb`, then redeploy.
- Add a `worker:` process to the Procfile for background jobs.
- Attach a database from the dashboard and re-enable Active Record — see [Databases & Add-ons](https://build.io/docs/guides/databases-and-addons).
