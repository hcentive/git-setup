# How to setup a Git repository

This document describes how to setup a new git repository.

## Create repository
To create a new repository, SSH in to the git server and switch to the `git` user.

```
› ssh -i ~/.ssh/ITSupport.pem ubuntu@git.demo.hcentive.com
```
```
ubuntu@HC-AWS-LINUX65:~$ sudo su - git
```

In the `repositories` directory, create a new directory for the new repository. Then `cd` into this new directory and initialize a bare repository.

```
git@HC-AWS-LINUX65:~/repositories$ mkdir jenkins-cookbook.git
git@HC-AWS-LINUX65:~/repositories$ cd jenkins-cookbook.git/
git@HC-AWS-LINUX65:~/repositories/jenkins-cookbook.git$ git init --bare
```
Or enter the following command to create a directory and initialize a bare repository at the same time.
```
git@HC-AWS-LINUX65:~/repositories$ git init --bare jenkins-cookbook.git/
```
The `git init` command creates a new git repository. It is also used to convert an existing project to a git repository, or initialize a new empty repository.

A new git repository, on the server, *must* always be initialized with the `--bare` option. As it is a central repository, pushing branches to a non-bare repository has potential to overwrite changes. So, as a rule, all central repositories are bare, and all local repositories on developer machines are non-bare.

## Setup access control with gitolite
As a default, a new git repository is not accessible to users. Access control is setup via [gitolite](gitolite_setup.md) that uses active directory groups to grant access. The access control configuration is itself in a [git repository](https://git.demo.hcentive.com/gitolite-admin).

To setup access control, clone the `gitolite-admin` repository, and add a section for the new repo.
```
> git clone https://git.demo.hcentive.com/gitolite-admin
```
Add a new section to the `conf/gitolite.conf` file for the new repository. In the example below, read-write access to the `jenkins-cookbook` is restricted to the `techops` active directory group.

```
repo jenkins-cookbook
    RW+ = @techops
```
Commit and push the changes to the central repository.

```
> git commit -am "Added jenkins-cookbook repo"
> git push origin master
```
Clone the new repository on your workstation to make changes.
```
> git clone https://git.demo.hcentive.com/jenkins-cookbook
```

# References
* [Git on the Server - Getting Git on a Server](http://git-scm.com/book/en/v2/Git-on-the-Server-Getting-Git-on-a-Server)
* [Git access control with Gitolite](gitolite_setup.md)
