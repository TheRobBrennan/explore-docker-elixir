# Welcome

This project is meant to serve as a starting point for exploring Elixir using Docker.

## Getting started

The easiest way to use this repo is to have [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and configured on your development machine.

### Local development environment

Before we Dockerize our application, let's take a look at what we would need to do if we wanted to install Elixir on our machine.

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

Before we install Phoenix, let's verify that we are on Elixir 1.5 or greater, and Erlang 18 or greater:

```sh
$ elixir -v

Erlang/OTP 22 [erts-10.5.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe] [dtrace]

Elixir 1.9.2 (compiled with Erlang/OTP 22)
```

Once we have Elixir and Erlang, we are ready to install the Phoenix Mix archive. A Mix archive is a Zip file which contains an application as well as its compiled BEAM files. It is tied to a specific version of the application. The archive is what we will use to generate a new, base Phoenix application which we can build from.

```sh
$ mix archive.install hex phx_new 1.4.10
```
