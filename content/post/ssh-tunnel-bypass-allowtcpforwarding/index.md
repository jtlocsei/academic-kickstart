---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "How to Set Up SSH Port Forwarding (Tunneling) When AllowTcpForwarding is Disabled"
subtitle: ""
summary: ""
authors: [tobias]
tags: [clojure]
categories: []
date: 2020-08-08T08:03:39+08:00
lastmod: 2020-08-08T08:03:39+08:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

This post is for you if you want to SSH tunnel (with `ssh -L ...`) into a server that has AllowTcpForwarding set to no in the `/etc/ssh/sshd_config` file, and you don't have the privileges to change that file. 

The [issue](https://stackoverflow.com/questions/63274946/how-to-enable-allowtcpforwarding-in-jelastic/63310281#63310281) came up for me when trying to connect to a remote REPL of a Clojure web app that I'm hosting on [Jelastic cloud hosting](https://jelastic.com/paas-cloud-hosting/) with [MIRHosting](https://mirhosting.com/en/cloud). 


## Easy port forwarding with Mutagen

An easy way I've found to set up port forwarding in spite of "AllowTcpForwarding no" is to use the [Mutagen network forwarding tool](https://mutagen.io/documentation/forwarding). 

In case you haven't heard of [Mutagen](https://mutagen.io/), it's a suite of tools for file-sync and network forwarding. You can use it to develop on a remote machine as if it were a local machine. It's pretty awesome. I'll just show you the network forwarding commands, but you should check out the file sync capabilities too. 

[Install mutagen](https://mutagen.io/documentation/introduction/installation) on a mac with 


```
brew install mutagen-io/mutagen/mutagen
```

Suppose that there's a machine remote-host.com that you'd normally SSH into on port 22 with username `user`. And suppose you want to forward connections to port 7001 on your local machine to port 7002 on the remote machine. 

Here's the command you'd normally run to set up a tunnel with SSH:

```
ssh -L 7001:localhost:7002 user@remote-host.com -p 22
```

Here's the command you run with Mutagen instead:

```
mutagen forward create --name=my-port-forward tcp:localhost:7001 user@remote-host.com:22:tcp::7002
```

The connection stays active even if you close the terminal window. There's a set of commands to manage your forwarding connections. 

List all active forwarding connections:


```
mutagen forward list
```


Pause a connection:


```
mutagen forward pause my-port-forward
```


Resume a connection:


```
mutagen forward resume my-port-forward
```


Terminate a connection:


```
mutagen forward terminate my-port-forward
```



## Alternative port forwarding workarounds

There are several [workarounds described on unix.stackexchange](https://unix.stackexchange.com/questions/406695/how-to-ssh-forwarding-with-allowtcpforwarding-set-to-no), but they look fiddly and require multiple commands in multiple terminal windows. I haven't tried them. 

There's also a tool called [SaSSHimi](https://www.tarlogic.com/en/blog/sasshimi-evading-allowtcpforwarding/) (for "evading AllowTcpForwarding") that looks unmaintained. I haven't tried it either. 
