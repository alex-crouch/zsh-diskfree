# zsh-disk🆓

Oh My Zsh plugin that displays the free space available on your disk right in your terminal prompt.

![Examples](https://github.com/alex-crouch/resources/blob/main/zsh-diskfree/images/servingsuggestion.gif)

## Features

- Shows available free disk space in your prompt with customisable units
- Automatically updates as you run commands
- Option to show free space for all disks or just the current disk

## Installation

1. Clone this repository to your Oh My Zsh custom plugins directory:

```bash
git clone https://github.com/alex-crouch/zsh-diskfree.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-diskfree
```

2. Add the plugin to your `.zshrc` file:

```bash
plugins=(... zsh-diskfree)
```

3. Integrate with your theme

To diplay the disk info on your prompt just edit your theme file and put the prompt call `$(diskfree_prompt_info)` into the prompt variable.

```bash
nano ${ZSH:-~/.oh-my-zsh}/themes/$ZSH_THEME.zsh-theme
```
For example with the robbyrussell theme:

```bash
PROMPT='%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) $(diskfree_prompt_info) %{$fg[cyan]%}%c%{$reset_color%}'
```

4. Reload

```bash
omz reload
```

## Configuration

You can configure the plugin by editing `zsh-diskfree.conf` at '${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-diskfree/zsh-diskfree.conf' or by adding environment variables to .zshrc eg. `export ZSH_DISKFREE_UNIT_GAP=1`. The variable names can be found in the configuration file and just need the `ZSH_DISKFREE_` prefix.

## Auto-Updating Prompt (Optional)

To make your prompt automatically update when idle at a prompt (useful for seeing disk space changes), add these lines to the top of your theme file, the `TMOUT` value is the refresh rate in seconds:

```bash
TMOUT=1
TRAPALRM() {
  # Don't reset prompt unless idle
  if [[ "$KEYMAP" == "main" && -z "$BUFFER" &&
        "$WIDGET" != "up-line-or-history" &&
        "$WIDGET" != "down-line-or-history" &&
        "$WIDGET" != "history-beginning-search-backward" &&
        "$WIDGET" != "history-beginning-search-forward" &&
        -z "$PREBUFFER" && -z "$LBUFFER" && -z "$RBUFFER" &&
        -z "$PREDISPLAY" && -z "$POSTDISPLAY" ]]; then
    zle reset-prompt
  fi
}
```
