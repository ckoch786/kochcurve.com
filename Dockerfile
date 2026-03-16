# Dockerfile for building and serving a Jekyll site
FROM ruby:3.2-slim

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libffi-dev \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working dir
WORKDIR /srv/jekyll

# Copy Gemfile and Gemfile.lock if present
COPY Gemfile* ./

# Install gems
RUN gem install bundler && bundle install

# Copy site files
COPY . .

# Build site
RUN bundle exec jekyll build

# Expose Jekyll server port
EXPOSE 4000

# Start server
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
