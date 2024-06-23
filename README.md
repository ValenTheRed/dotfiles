# dotfiles

All of my config files.

## Installation
After cloning, run

```sh
git config --local blame.ignoreRevsFile .git-blame-ignore-revs
```

## Some tips
- Prepend `DRI_PRIME=1` before launching program to enable nvidia card utilisation for
  that program on optimus laptops. Ref: https://wiki.archlinux.org/title/PRIME#For_open_source_drivers_-_PRIME.
- Instructions for [installing gnome-keyring](https://nurdletech.com/linux-notes/agents/keyring.html).
- Run gnome-keyring [automatically upon login problem](https://www.reddit.com/r/Fedora/comments/qjag8s/issue_with_unlocking_gnomekeyring_when_using/).
  The problem was that SELinux was blocking gnome-keyring from running on login.
  1. To check -- `sudo ausearch -m AVC | grep gnome-keyring-daemon` should have
     something like “[...] avc: denied { execute } [...]”.
  2. Install setroubleshoot with `sudo dnf -y install setroubleshoot`. Once
     installed, log out, then log back in. Then run `sealert`.
  3. Follow the instructions on it.
