# Welcome

This project is meant to serve as a starting point for exploring [Elixir](https://elixir-lang.org) using [Docker](https://www.docker.com).

Developing [Elixir](https://elixir-lang.org) natively on your local machine appears to be a **much, much better** way to go. However, it doesn't hurt to begin experimenting and see what limitations or frustrations may present themselves.

Deploying [Elixir](https://elixir-lang.org) is a whole 'nother can of worms. These examples are from a cloud-native perspective - which means that a lot of the [Elixir](https://elixir-lang.org) goodness is left untapped. While some simpler applications may lend themselves well to this approach - think relatively simple servers or applications - we need to consider how we might handle more intricate [Phoenix](https://phoenixframework.org) and/or [Elixir](https://elixir-lang.org) applications.

Daniel Azuma presented a great talk at [ElixirConf 2018 - Docker and OTP Friends or Foes - Daniel Azuma](https://www.youtube.com/watch?v=nLApFANtkHs&feature=youtu.be). This is a must-see talk - ~38:52 in length and a great overview of considerations deploying Elixir apps. The live demo at the end brings it all together in a practical example using Kubernetes performing a live update of the game without losing state. The entire talk - including a summary, links to resources and libraries used in the talk, and the slide deck - is available at [https://daniel-azuma.com/articles/talks/elixirconf-2018](https://daniel-azuma.com/articles/talks/elixirconf-2018).

## Getting started

The easiest way to use this repo is to have [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and configured on your development machine.

Alternatively, you can still experiment with [Elixir](https://elixir-lang.org) on your development machine as well.

## Examples

This project is meant to serve as a starting point for exploring both [Elixir](https://elixir-lang.org) and Docker. I hope you enjoy exploring the examples that follow.

### Example: Phoenix Hello

This example - contained in `./example-phoenix-hello` - demonstrates how to build a simple [Phoenix](https://phoenixframework.org) application on [Elixir](https://elixir-lang.org).

Please refer to `./example-phoenix-hello/README.md` for instructions on getting started. If you already have [Docker Desktop](https://www.docker.com/products/docker-desktop) installed, you should be able to run `$ docker-compose up --build` and be off and running.

### Example: Run Elixir in multiple containers

This example - based off the original blog post [Running Elixir in Docker Containers](https://www.poeticoding.com/running-elixir-in-docker-containers/) - is intended to show how you can poke around with [Elixir](https://elixir-lang.org) and have multiple Docker containers communicate with each other.

Please refer to `./example-elixir-multiple-containers/README.md` for instructions on getting started.

![example-elixir-multiple-containers/assets/docker_elixir_multiple_containers-1-1024x576.png](example-elixir-multiple-containers/assets/docker_elixir_multiple_containers-1-1024x576.png)
