# Use an official Elixir runtime as a parent image
FROM elixir:latest

# Static asset (CSS, JS, etc) hot reload inspired by https://github.com/colindensem/demo-docker-elixir-phoenix
RUN apt-get update \
    && apt-get install -y postgresql-client \
    && apt-get install -y curl inotify-tools \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force

# Compile the project
RUN mix do compile

CMD ["/app/entrypoint.sh"]

