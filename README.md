# yuchen-zsh-tools

Personal zsh helpers and git workflow aliases.

## Install

The recommended setup is to clone this repository under `$ZSH_CUSTOM/plugins`
and enable it from the normal `plugins=(...)` list.

### Oh My Zsh

Clone it as a custom plugin:

```zsh
git clone https://github.com/xieyuschen/yuchen-zsh-tools.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/yuchen-zsh-tools"
```

Then enable it in `~/.zshrc`:

```zsh
plugins=(
  git
  yuchen-zsh-tools
)
```

Oh My Zsh loads `yuchen-zsh-tools.plugin.zsh` automatically because the plugin
directory and plugin entrypoint use the same name.

To update:

```zsh
git -C "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/yuchen-zsh-tools" pull
```

### zinit

```zsh
zinit light xieyuschen/yuchen-zsh-tools
```

### antidote

Add this line to your `.zsh_plugins.txt`:

```text
xieyuschen/yuchen-zsh-tools
```

Then bundle it from `~/.zshrc`:

```zsh
antidote load
```

### antigen

```zsh
antigen bundle xieyuschen/yuchen-zsh-tools
```

### Manual

Clone the repository and source the root plugin file:

```zsh
git clone https://github.com/xieyuschen/yuchen-zsh-tools.git ~/.zsh/yuchen-zsh-tools
source ~/.zsh/yuchen-zsh-tools/yuchen-zsh-tools.plugin.zsh
```

## Git Identity Helpers

`gitmine` and `gitbot` configure the name and email for the current repository.

## Test

```zsh
zsh -n yuchen-zsh-tools.plugin.zsh
zsh -n plugins/git.plugin.zsh
zsh tests/git-plugin-smoke.zsh
```
