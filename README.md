# Niv Flakes

Nix flakes for the stubborn niv user

## Introduction

[Nix flakes](https://nixos.wiki/wiki/Flakes) is becoming more popular in the nix community, despite the feature still being work in progress.
It brings with it many advantages, mostly when considering discovery of new packages. `nix flake show` can give people a brief overview of what is in
a nix-related project, and allows someone to quickly figure out if the project contains something they need. However, it comes with some issues...

Flakes aren't the first solution to the problem of non-replicatable builds. There are also [Git Submodules](https://git-scm.com/docs/git-submodule), [Niv](https://github.com/nmattia/niv) and [Nix-Thunk](https://github.com/obsidiansystems/nix-thunk).
These options all have their own upsides and drawbacks, but one thing they all share is that they are not quite compatible with nix flakes. This project tries to integrate the second option, *Niv*.

## The problem

A `flake.nix` file is quite stingy when it comes to what can and can't go into it.
If you were to try and involve other files in the inclusion of your imports, you'd get an error, as nix doesn't see your dynamically generated attribute set as an attribute set, but as a *thunk*.
This means that we can't do anything other than typing out the attribute set by hand. This can be done declaratively.
When we try to import github repositories in nix flakes, we usually do this by using an input url in the form of "github:{name}/{repo}/{branch?}".
The problem with this is that when debugging a flake with a lot of inputs with this url scheme, you could accidentally exceed the rate limits imposed by the github api,
as flakes use GitHub's [Rest API](https://docs.github.com/en/rest) to resolve github urls.

## The solution (i hope)

Instead of using git or github urls to resolve github repositories, we instead use niv to find URLs to tarballs of repositories on a certain commit. This does have some drawbacks, however.
For one, niv works best when the repository is on github, which means that other git forges may not get the auto-updating benefits that github-hosted repositories have.

## Usage

### Installation

This is a template repository.
To use this flake you either fork this repository to your own account, clone it, or use `nix flake new -t github:crazazy/niv-flakes <new-dir>` to get a new version of this flake working

### Updating/Installing new github repositories

Dependent repositories are read from `nix/sources.json`. To edit it, its highly advisable to use niv.

- To add a new dependency, use `niv add [username]/[reponame]`. If your new dependency is a flake, you can use it as one by doing `niv modify [username]/[reponame] -a flake=true`
- To update all your dependencies, use `niv update`

After this, you should execute ./createFlakeNix.sh to generate a new flake.nix, followed by `nix flake update` do update your lockfile

### Changing what your flake does

Most of the actual flake logic is put in [./dirtyFlake.nix](./dirtyFlake.nix).
This is where you'll find a sample outputs function and an example description of the flake. Do with it what you want, and after modification make sure to do `nix flake check` to see if your flake still works.
