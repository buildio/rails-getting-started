# Optional: only used when this app's stack is set to "dockerfile" in Build's app settings.
# The default buildpack stack needs no Dockerfile at all.
FROM ruby:4.0-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git && \
    rm -rf /var/lib/apt/lists/*

# Copy dependency manifests first so the install layer is cached
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle config set --local deployment true && \
    bundle config set --local without "development test" && \
    bundle install

COPY . .

ENV RAILS_ENV=production
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
