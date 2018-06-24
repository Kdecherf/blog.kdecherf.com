Title: zsh, vcs_info and WebDAV mounts
Category: Blog
Tags: zsh, nextcloud, webdav
Date: 2018-06-24 22:39

Here is a quick note about using _zsh_ and *vcs_info* with WebDAV mounts.

*vcs_info* is a built-in feature in _zsh_ which lets you show VCS information
if the current working dir is a git, svn or bazaar repository. It is used by
tools like _oh-my-zsh_ and _powerlevel9k_; and basically uses VCS tools to
extract data: for example, it will use `git rev-parse --is-inside-work-tree` to
know if the current folder is a git worktree.

This feature will make these calls each time your shell shows the prompt, for
example:

 * when you change the current working directory
 * when a command exits

So each time the prompt will be shown to you, *vcs_info* will make extra file
accesses in order to know if the current working directory is a repo. If it's
not, it will check against the parent directories until finding a `.git`
directory or encountering a filesystem boundary.

In my case each `stat()` syscall costs between 200 and 300 ms inside my WebDAV
mount (*a NextCloud installation*). If we consider the dir
`~/NextCloud/dirA/dirB/dirC/dirD/dirE`, `git rev-parse --is-inside-work-tree`
will spend more than one second each time your shell will show you a prompt.

Say hello to `disable-patterns`, an option that lets you give directory
patterns in which *vcs_info* should not run. Considering that my WebDAV mount
is mounted in `~/NextCloud`, I must add the following line in `~/.zshrc` (_or
      any config file if you use a custom system for zsh_):

``` zsh
zstyle ':vcs_info:*' disable-patterns "${(b)HOME}/NextCloud(|/*)"
```

Reload your shell, now prompts in the mount should be instant.

Source: [https://superuser.com/questions/341725/how-can-i-selectively-disable-zshs-version-control-integration-when-my-cwd-is-o](https://superuser.com/questions/341725/how-can-i-selectively-disable-zshs-version-control-integration-when-my-cwd-is-o#373723)

_Enjoy!_

