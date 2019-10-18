# Welcome

This project is meant to serve as a starting point for exploring [Elixir](https://elixir-lang.org) using [Docker](https://www.docker.com).

## Getting started

The easiest way to use this repo is to have [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and configured on your development machine.

### Using Docker

#### Start the back-end PostgreSQL server

Once Docker has been installed on your system, you can spin up the project by running:

```sh
$ docker-compose up --build
```

When you're ready to spin down the project, you can run:

```sh
$ docker-compose down
```

#### Create a Phoenix app

We can run mix phx.new from any directory in order to bootstrap our [Phoenix](https://phoenixframework.org) application. [Phoenix](https://phoenixframework.org) will accept either an absolute or relative path for the directory of our new project. Assuming that the name of our application is hello, let's run the following command:

```sh
$ mix phx.new hello

We are almost there! The following steps are missing:

    $ cd hello

Then configure your database in config/dev.exs and run:

    $ mix ecto.create

Start your Phoenix app with:

    $ mix phx.server

You can also run your app inside IEx (Interactive Elixir) as:

    $ iex -S mix phx.server
```

Assuming your database server is running (you DID `Start the back-end PostgreSQL server` as directed above, right), let's follow the advice above:

```sh
$ cd hello

# Define your desired database settings in config/dev.exs and run:
$ mix ecto.create

# Start your Phoenix app
$ mix phx.server

# To exit, simply press CMD+C/CTRL+C twice

# OPTIONAL: If you'd like to run your app in Interactive Elixir (iex)
$ iex -S mix phx.server
```

### Local development environment

Before we Dockerize our application, let's take a look at what we would need to do if we wanted to install [Elixir](https://elixir-lang.org) on our machine.

#### Install Elixir

For instructions on installing [Elixir](https://elixir-lang.org/), please refer to the guide available at [https://elixir-lang.org/install.html](https://elixir-lang.org/install.html).

##### macOS

To install [Elixir](https://elixir-lang.org/) on macOS using [Homebrew](https://brew.sh):

```sh
$ brew update
$ brew install elixir

# If Elixir has already been installed, you may be instructed to upgrade to the latest version
$ brew upgrade elixir
```

#### Install Phoenix

Before we install [Phoenix](https://phoenixframework.org), let's verify that we are on [Elixir](https://elixir-lang.org) 1.5 or greater, and Erlang 18 or greater:

```sh
$ elixir -v

Erlang/OTP 22 [erts-10.5.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe] [dtrace]

Elixir 1.9.2 (compiled with Erlang/OTP 22)
```

Once we have [Elixir](https://elixir-lang.org) and Erlang, we are ready to install the [Phoenix](https://phoenixframework.org) Mix archive. A Mix archive is a Zip file which contains an application as well as its compiled BEAM files. It is tied to a specific version of the application. The archive is what we will use to generate a new, base Phoenix application which we can build from.

```sh
$ mix archive.install hex phx_new 1.4.10
```
