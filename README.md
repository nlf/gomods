## Gomods

Gomods is a very simple and basic module vendoring script for Golang.

It does not manage your dependency versions explicitly, I recommend installing your dependencies from a service such as gopkg.in that provides versioning support for you.

What it *does* do, however, is provide you with a slim wrapper around the `go` command to automatically manage your `$GOPATH` and keep your projects dependencies where they belong, with your project.

### Installation

Download the `gomods.sh` script and save it somewhere. I recommend naming it `.gomods.sh` and placing it in your home directory. You can do so with the following command

`curl -o ~/.gomods.sh https://raw.githubusercontent.com/nlf/gomods/master/gomods.sh`

Next, add the following to your `.profile` file

`. $HOME/.gomods.sh`

Open a new terminal, and you're all set!

### Usage

When starting a new project (or converting an existing project to use `gomods`), run `go init`. That's it.

The directory `go_modules` will be created in your current directory. If this is a new project, its contents will be an empty `src` directory and a simple `.gitignore`. If this is an existing project, the dependencies for your project will also be installed into `go_modules`.

Any time you run a `go` command in this directory, the `$GOPATH` will be automatically set to `go_modules` for you.

### Notes

This is only tested in bash. It may work in other shells, it may not. I honestly don't know. If you fix it for a different shell, submit a pull request!
