# dotfiles

## single file install

``` sh
curl -fsSL "https://raw.githubusercontent.com/decantr/dotfiles/refs/heads/master/scripts/get.sh" | sh
```

Requires `curl`, uses `fzf` or falls back to bash picker. Places files
relative to the home directory as they are laid out here. Existing files are
prompted first and backed up on replace.

Alternatively pass a file paths directly

```sh
curl -fsSL "https://raw.githubusercontent.com/decantr/dotfiles/refs/heads/master/scripts/get.sh" | sh -s -- .foo bar

get.sh foo bar
```

An existing file is backed up to `<file>.<timestamp>` before it is replaced.
