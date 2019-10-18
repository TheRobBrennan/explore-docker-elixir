# Welcome

This example is meant to serve as a starting point for exploring [Elixir](https://elixir-lang.org) using [Docker](https://www.docker.com) - based off the original blog post [Running Elixir in Docker Containers](https://www.poeticoding.com/running-elixir-in-docker-containers/)

The easiest way to use this repo is to have [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and configured on your development machine.

## Getting started

### Level 1

The following shell example is intended as a quick summary of the original blog post [Running Elixir in Docker Containers](https://www.poeticoding.com/running-elixir-in-docker-containers/) - with my own thoughts and interjections tossed in where appropriate.

```sh
# Let's pull both the latest development and alpine versions of Elixir
$ docker image pull elixir:1.9.2

1.9.2: Pulling from library/elixir
Digest: sha256:36d4e97bd80730f18ffcff7018e7057586eb70ef207b66717fd70b17c89d1aa8
Status: Downloaded newer image for elixir:1.9.2
docker.io/library/elixir:1.9.2

$ docker image pull elixir:1.9.2-alpine

1.9.2-alpine: Pulling from library/elixir
9d48c3bd43c5: Pull complete 
a9bc3f38faf5: Pull complete 
d73b62621d1b: Pull complete 
Digest: sha256:0c73898977c6c24bff432dd4d1b69beeda167d9488487a54c832b87216f8230f
Status: Downloaded newer image for elixir:1.9.2-alpine
docker.io/library/elixir:1.9.2-alpine
```

```sh
# Let's compare the size of these Docker images
$ docker image inspect elixir:1.9.2 --format '{{ .Size}}'
1083744501

$ docker image inspect elixir:1.9.2-alpine --format '{{ .Size}}'
87631525

# Wow! 1.08 GB for the development version; 87.6 MB for the alpine version.
```

```sh
# Both images run iex if no command is passed.
$ docker run -it elixir:1.9.2
$ docker run -it elixir:1.9.2-alpine

Erlang/OTP 22 [erts-10.5.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1]

Interactive Elixir (1.9.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

For fun, let's see how we can restart a stopped container.
```sh
# In terminal window #1, let's start one container
$ docker run -it elixir:1.9.2

# In another terminal window, let's list the containers we have
$ docker container ls -a
CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                     PORTS               NAMES
133c2351c3e0        elixir:1.9.2-alpine   "iex"               3 minutes ago       Up 3 minutes                                   wonderful_matsumoto
c9b31def28a9        elixir:1.9.2          "iex"               3 minutes ago       Exited (0) 3 minutes ago                       vigorous_nobel

# Notice we have a container named wonderful_matsumoto that is running; and another automatically named vigorous_nobel that has been stopped. If we switch back to our terminal window #1 and exit, we can see both containers have exited.
$ docker container ls -a
CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                     PORTS               NAMES
133c2351c3e0        elixir:1.9.2-alpine   "iex"               6 minutes ago       Exited (0) 6 seconds ago                       wonderful_matsumoto
c9b31def28a9        elixir:1.9.2          "iex"               6 minutes ago       Exited (0) 6 minutes ago                       vigorous_nobel

# Let's say we want to restart vigorous_nobel and fire up iex. We can do the following:
$ docker container start vigorous_nobel
vigorous_nobel

# Now we see the status of vigorous_nobel has now changed up being up
$ docker container ls -a
CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                     PORTS               NAMES
133c2351c3e0        elixir:1.9.2-alpine   "iex"               10 minutes ago      Exited (0) 4 minutes ago                       wonderful_matsumoto
c9b31def28a9        elixir:1.9.2          "iex"               10 minutes ago      Up 13 seconds                                  vigorous_nobel

$ docker container attach vigorous_nobel
# Press enter/return and you will see the iex shell is back up and running
```

```sh
# REMEMBER: Containers are ephemeral, so when they are removed the data is gone for good.
# We can have containers automatically remove themselves when stopped with
$ docker container run -it --rm elixir:1.9.2
```

### Level 2

Now that we have the basics down, let's up our game a little here.

```sh
# Let's bind our local /data folder to a /data folder within our container
#
# What's going on here?
#   -v local_path:container_path is what binds our local project path to the container
#   -w /data tells the container to start in the /data directory as its working directory
#
# Let's create a new elixir project using mix new
$ docker container run --rm -v $PWD:/data -w /data elixir:1.9.2 mix new crypto

* creating README.md
* creating .formatter.exs
* creating .gitignore
* creating mix.exs
* creating lib
* creating lib/crypto.ex
* creating test
* creating test/test_helper.exs
* creating test/crypto_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd crypto
    mix test

Run "mix help" for more commands.

# Let’s move inside the crypto directory and add a dependency to crypto/mix.exs
$ cd crypto
$ docker container run --rm -v $PWD:/app -w /app -it elixir:1.9.2 mix deps.get

Could not find Hex, which is needed to build dependency :poison
Shall I install Hex? (if running non-interactively, use "mix local.hex --force") [Yn] 
* creating /root/.mix/archives/hex-0.20.1
Resolving Hex dependencies...
Dependency resolution completed:
New:
  poison 4.0.1
* Getting poison (Hex package)

```

### Level 3

After the dependency is downloaded and built, the container is destroyed and all the data in /root/.mix is lost. If we run again the same commands we will have again to install hex. To solve this, an similar issues, we can create a local volume.

```sh
$ docker volume create elixir-mix
elixir-mix

# To use the local volume, we need to add the option
#   -v volume-name:container_mount_point

# The first time, Hex needs to be installed...
$ docker container run --rm -v elixir-mix:/root/.mix -v $PWD:/app -w /app -it  elixir:1.9.2 mix deps.get
Could not find Hex, which is needed to build dependency :poison
Shall I install Hex? (if running non-interactively, use "mix local.hex --force") [Yn] 
* creating /root/.mix/archives/hex-0.20.1
Resolving Hex dependencies...
Dependency resolution completed:
Unchanged:
  poison 4.0.1
All dependencies are up to date

# The second time the command is working properly because hex is found in the /root/.mix directory, where elixir-mix volume is mounted.
$ docker container run --rm -v elixir-mix:/root/.mix -v $PWD:/app -w /app -it  elixir:1.9.2 mix deps.get
Resolving Hex dependencies...
Dependency resolution completed:
Unchanged:
  poison 4.0.1
All dependencies are up to date

# We can now run our iex loading our crypto project
$ docker container run --rm -v elixir-mix:/root/.mix -v $PWD:/app -w /app -it  elixir:1.9.2 iex -S mix
Erlang/OTP 22 [erts-10.5.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

==> poison
Compiling 4 files (.ex)
Generated poison app
==> crypto
Compiling 1 file (.ex)
Generated crypto app
Interactive Elixir (1.9.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Poison.encode! %{hello: :world}
"{\"hello\":\"world\"}"
iex(2)>
```

### Level 4

Now it's time for the fun part. Let's see how we can run multiple containers.

```sh
# Create our bridge network
$ docker network create elixir-net
d0da229a4b8e6652f3df9e526fd782ab791b5ed2cc50256d189e04a71030876d

$ docker network inspect elixir-net
# With inspect we see that our elixir-net network has 192.168.112.0/20 subnet.
[
    {
        "Name": "elixir-net",
        "Id": "d0da229a4b8e6652f3df9e526fd782ab791b5ed2cc50256d189e04a71030876d",
        "Created": "2019-10-18T03:03:15.6012924Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "192.168.112.0/20",
                    "Gateway": "192.168.112.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]

# To run a container and to make it join the network we’ve just created, we use the --network option
$ docker run -it --rm --network elixir-net elixir:1.9.2

# Let’s use another terminal to see first the id of the container we started, and get then its IP inside elixir-net.
$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
280027c6f443        elixir:1.9.2        "iex"               27 seconds ago      Up 26 seconds                           thirsty_meitner

$ docker container inspect 280027c6f443 | jq
[
  {
    "Id": "280027c6f4432b81f342aa137742cfb5698a52cf24259d38dca73c9f0e89acc7",
    "Created": "2019-10-18T03:08:40.8113671Z",
    "Path": "iex",
    "Args": [],
    "State": {
      "Status": "running",
      "Running": true,
      "Paused": false,
      "Restarting": false,
      "OOMKilled": false,
      "Dead": false,
      "Pid": 45822,
      "ExitCode": 0,
      "Error": "",
      "StartedAt": "2019-10-18T03:08:41.369508Z",
      "FinishedAt": "0001-01-01T00:00:00Z"
    },
    "Image": "sha256:d50010b323774fa35f41a4b59106d80e40f4cedcacca688ce999bbd687af45ba",
    "ResolvConfPath": "/var/lib/docker/containers/280027c6f4432b81f342aa137742cfb5698a52cf24259d38dca73c9f0e89acc7/resolv.conf",
    "HostnamePath": "/var/lib/docker/containers/280027c6f4432b81f342aa137742cfb5698a52cf24259d38dca73c9f0e89acc7/hostname",
    "HostsPath": "/var/lib/docker/containers/280027c6f4432b81f342aa137742cfb5698a52cf24259d38dca73c9f0e89acc7/hosts",
    "LogPath": "/var/lib/docker/containers/280027c6f4432b81f342aa137742cfb5698a52cf24259d38dca73c9f0e89acc7/280027c6f4432b81f342aa137742cfb5698a52cf24259d38dca73c9f0e89acc7-json.log",
    "Name": "/thirsty_meitner",
    "RestartCount": 0,
    "Driver": "overlay2",
    "Platform": "linux",
    "MountLabel": "",
    "ProcessLabel": "",
    "AppArmorProfile": "",
    "ExecIDs": null,
    "HostConfig": {
      "Binds": null,
      "ContainerIDFile": "",
      "LogConfig": {
        "Type": "json-file",
        "Config": {}
      },
      "NetworkMode": "elixir-net",
      "PortBindings": {},
      "RestartPolicy": {
        "Name": "no",
        "MaximumRetryCount": 0
      },
      "AutoRemove": true,
      "VolumeDriver": "",
      "VolumesFrom": null,
      "CapAdd": null,
      "CapDrop": null,
      "Capabilities": null,
      "Dns": [],
      "DnsOptions": [],
      "DnsSearch": [],
      "ExtraHosts": null,
      "GroupAdd": null,
      "IpcMode": "private",
      "Cgroup": "",
      "Links": null,
      "OomScoreAdj": 0,
      "PidMode": "",
      "Privileged": false,
      "PublishAllPorts": false,
      "ReadonlyRootfs": false,
      "SecurityOpt": null,
      "UTSMode": "",
      "UsernsMode": "",
      "ShmSize": 67108864,
      "Runtime": "runc",
      "ConsoleSize": [
        0,
        0
      ],
      "Isolation": "",
      "CpuShares": 0,
      "Memory": 0,
      "NanoCpus": 0,
      "CgroupParent": "",
      "BlkioWeight": 0,
      "BlkioWeightDevice": [],
      "BlkioDeviceReadBps": null,
      "BlkioDeviceWriteBps": null,
      "BlkioDeviceReadIOps": null,
      "BlkioDeviceWriteIOps": null,
      "CpuPeriod": 0,
      "CpuQuota": 0,
      "CpuRealtimePeriod": 0,
      "CpuRealtimeRuntime": 0,
      "CpusetCpus": "",
      "CpusetMems": "",
      "Devices": [],
      "DeviceCgroupRules": null,
      "DeviceRequests": null,
      "KernelMemory": 0,
      "KernelMemoryTCP": 0,
      "MemoryReservation": 0,
      "MemorySwap": 0,
      "MemorySwappiness": null,
      "OomKillDisable": false,
      "PidsLimit": null,
      "Ulimits": null,
      "CpuCount": 0,
      "CpuPercent": 0,
      "IOMaximumIOps": 0,
      "IOMaximumBandwidth": 0,
      "MaskedPaths": [
        "/proc/asound",
        "/proc/acpi",
        "/proc/kcore",
        "/proc/keys",
        "/proc/latency_stats",
        "/proc/timer_list",
        "/proc/timer_stats",
        "/proc/sched_debug",
        "/proc/scsi",
        "/sys/firmware"
      ],
      "ReadonlyPaths": [
        "/proc/bus",
        "/proc/fs",
        "/proc/irq",
        "/proc/sys",
        "/proc/sysrq-trigger"
      ]
    },
    "GraphDriver": {
      "Data": {
        "LowerDir": "/var/lib/docker/overlay2/207c5708e353c975a98d95529edbbdab57845abd52ae07a8e7dab635ba782062-init/diff:/var/lib/docker/overlay2/cf775ba697f5da85fbed7d2ce398030e66c3740a554c891803587ef6c510fe18/diff:/var/lib/docker/overlay2/35ac465cabf5686415bc680484d2efacf95df007e907b6c02ec49e5a1c7a90e7/diff:/var/lib/docker/overlay2/c4e661f5b3b7ba78d80aac995ade813d2d8db96048dff4a5cfa977df2151e17a/diff:/var/lib/docker/overlay2/6541d43672071406e3008a6fce9ef03a2c8c18c6928e58849241935c65cb5d00/diff:/var/lib/docker/overlay2/50b06e436ee8d5a992239b32552e60855b59c469efd782809036f4d6e1dfa767/diff:/var/lib/docker/overlay2/6e4b4e92f8399f09e3a4de7d3da5c469446947333180075e137ffacc169fb879/diff:/var/lib/docker/overlay2/e48aefb60bc5de3d7de796af5d1bf1831d5567231a6e70de749eb262fd17cee8/diff:/var/lib/docker/overlay2/e0d8d6e669f88e1a0cb3f6079e6f6d2f3796ede7e3a8fd5c7650c25d0f82cebf/diff:/var/lib/docker/overlay2/8caef7ede739aae07cb7daf2b7fd7620b1554efdc74d5386c1780ae53c4bae51/diff",
        "MergedDir": "/var/lib/docker/overlay2/207c5708e353c975a98d95529edbbdab57845abd52ae07a8e7dab635ba782062/merged",
        "UpperDir": "/var/lib/docker/overlay2/207c5708e353c975a98d95529edbbdab57845abd52ae07a8e7dab635ba782062/diff",
        "WorkDir": "/var/lib/docker/overlay2/207c5708e353c975a98d95529edbbdab57845abd52ae07a8e7dab635ba782062/work"
      },
      "Name": "overlay2"
    },
    "Mounts": [],
    "Config": {
      "Hostname": "280027c6f443",
      "Domainname": "",
      "User": "",
      "AttachStdin": true,
      "AttachStdout": true,
      "AttachStderr": true,
      "Tty": true,
      "OpenStdin": true,
      "StdinOnce": true,
      "Env": [
        "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        "OTP_VERSION=22.1.3",
        "REBAR3_VERSION=3.12.0",
        "REBAR_VERSION=2.6.4",
        "ELIXIR_VERSION=v1.9.2",
        "LANG=C.UTF-8"
      ],
      "Cmd": [
        "iex"
      ],
      "Image": "elixir:1.9.2",
      "Volumes": null,
      "WorkingDir": "",
      "Entrypoint": null,
      "OnBuild": null,
      "Labels": {
        "org.opencontainers.image.version": "22.1.3"
      }
    },
    "NetworkSettings": {
      "Bridge": "",
      "SandboxID": "3555383d359c6a323d6af51a4642c3d77daea053de5b51e7cbab086876c65cef",
      "HairpinMode": false,
      "LinkLocalIPv6Address": "",
      "LinkLocalIPv6PrefixLen": 0,
      "Ports": {},
      "SandboxKey": "/var/run/docker/netns/3555383d359c",
      "SecondaryIPAddresses": null,
      "SecondaryIPv6Addresses": null,
      "EndpointID": "",
      "Gateway": "",
      "GlobalIPv6Address": "",
      "GlobalIPv6PrefixLen": 0,
      "IPAddress": "",
      "IPPrefixLen": 0,
      "IPv6Gateway": "",
      "MacAddress": "",
      "Networks": {
        "elixir-net": {
          "IPAMConfig": null,
          "Links": null,
          "Aliases": [
            "280027c6f443"
          ],
          "NetworkID": "d0da229a4b8e6652f3df9e526fd782ab791b5ed2cc50256d189e04a71030876d",
          "EndpointID": "5ba9629bffde7072e85b301297e9bbf4f10db442202dc7285b39c38aafbdd6c6",
          "Gateway": "192.168.112.1",
          "IPAddress": "192.168.112.2",
          "IPPrefixLen": 20,
          "IPv6Gateway": "",
          "GlobalIPv6Address": "",
          "GlobalIPv6PrefixLen": 0,
          "MacAddress": "02:42:c0:a8:70:02",
          "DriverOpts": null
        }
      }
    }
  }
]
# We can see that our container has an IP address of 192.168.112.2

# Let’s run another container in the same network, starting the session in bash instead of iex. The main image has the ping command we can use to ping the other container.
$ docker run -it --rm --network elixir-net elixir:1.9.2 bash
root@d0c6eeb14da5:/# ping 192.168.112.2
PING 192.168.112.2 (192.168.112.2) 56(84) bytes of data.
64 bytes from 192.168.112.2: icmp_seq=1 ttl=64 time=0.506 ms
64 bytes from 192.168.112.2: icmp_seq=2 ttl=64 time=0.092 ms
64 bytes from 192.168.112.2: icmp_seq=3 ttl=64 time=0.095 ms
64 bytes from 192.168.112.2: icmp_seq=4 ttl=64 time=0.097 ms
^C
--- 192.168.112.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3059ms
rtt min/avg/max/mdev = 0.092/0.197/0.506/0.178 ms
root@d0c6eeb14da5:/#

# Even if it works, we mustn’t use the IPs directly: each container has its own IP and if a container is destroyed and re-created the IP could not be the same.

# Hopefully we can rely on names. To make them work we need to start our container with the --name option. We also add the -h option to set the hostname (which will be useful later running multiple Elixir nodes).
```

### Level 5

Remove all containers related to this project so we can start with a clean slate. Then, we will want to run these commands in two different terminal windows.

```sh
# Terminal 1
$ docker run -it --rm --network elixir-net --name elixir-1 -h elixir-1 elixir:1.9.2 bash
root@elixir-1:/# 

# Terminal 2
$ docker run -it --rm --network elixir-net --name elixir-2 -h elixir-2 elixir:1.9.2 bash
root@elixir-2:/# 

# Terminal 2 - Let's ping elixir-1 to make sure we're on the same network
root@elixir-2:/# ping elixir-1
PING elixir-1 (192.168.112.2) 56(84) bytes of data.
64 bytes from elixir-1.elixir-net (192.168.112.2): icmp_seq=1 ttl=64 time=0.090 ms
64 bytes from elixir-1.elixir-net (192.168.112.2): icmp_seq=2 ttl=64 time=0.092 ms
64 bytes from elixir-1.elixir-net (192.168.112.2): icmp_seq=3 ttl=64 time=0.093 ms
^C
--- elixir-1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2021ms
rtt min/avg/max/mdev = 0.090/0.091/0.093/0.011 ms
root@elixir-2:/# 
```

That's cool. Now we have all we need to start iex in two separate containers and to connect the two nodes. To make them able to connect we need to use the --sname iex option, which assigns a short name to the node. In our case the name can be the same since we have different hostnames (-h option in docker).

```sh
# Let's pass our cookie as an environment variable
# Terminal 1
$ docker run -it --rm -e COOKIE=secret --network elixir-net --name elixir-1 -h elixir-1 elixir:1.9.2 iex --sname docker --cookie '$COOKIE'

Erlang/OTP 22 [erts-10.5.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

Interactive Elixir (1.9.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(docker@elixir-1)1> 

# Terminal 2
$ docker run -it --rm -e COOKIE=secret --network elixir-net --name elixir-2 -h elixir-2 elixir:1.9.2 iex --sname docker --cookie '$COOKIE'

Erlang/OTP 22 [erts-10.5.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

Interactive Elixir (1.9.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(docker@elixir-2)1> 

# Now let's run a few commands in terminal 2
iex(docker@elixir-2)1> Node.connect :"docker@elixir-1"
true
iex(docker@elixir-2)2> Node.list
[:"docker@elixir-1"]

# In terminal 2, let's start a MyAgent process
iex(docker@elixir-2)3> Agent.start_link(
    fn -> {:hello, :world} end, 
    name: {:global, MyAgent})
{:ok, #PID<0.122.0>}

# Back in terminaal 1, we can now access the MyAgent process
iex(docker@elixir-1)1> Agent.get({:global, MyAgent}, fn state-> state end)
{:hello, :world}

```
