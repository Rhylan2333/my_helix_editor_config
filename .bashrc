# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# 自定义 fzf 历史搜索函数
bash_history_fzf() {
  local selected
  selected=$(
    history | awk '{$1=""; gsub(/^ +/, ""); print}' | \
      fzf  --reverse --height 60% --preview-window 'up,20%' \
      --preview "echo {} | bat -p -l bash --theme 'Monokai Extended Origin' --color always"
      )
  # 如果选中了命令，则执行
  if [[ -n "$selected" ]]; then
    # echo "🏃 执行 👉 $selected"
    # eval "$selected"
    READLINE_LINE=$selected
    READLINE_POINT=${#READLINE_LINE}
  fi
}
# 绑定快捷键 Alt+r（即 \er）
bind -x '"\er": bash_history_fzf'

# 函数：将当前行复制到剪贴板
copy_cmd_to_clipboard() {
    if printf '%s' "$READLINE_LINE" | xclip -selection clipboard 2>/dev/null; then
        echo -e "✅ Copied 👇\n$READLINE_LINE"
    else
        echo "❌ Failed to copy to clipboard. "
    fi
}
# 绑定到快捷键 Alt+x（即 \ex）
bind -x '"\ex": copy_cmd_to_clipboard'

# 可选：绑定到 Ctrl+Shift+C (注意：终端可能拦截此组合)
# bind -x '"\C-c": copy-line-to-clipboard' # 注意：这会覆盖默认的 SIGINT

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=250000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias mel='mamba env list'
alias ma='mamba activate'
alias mda='mamba deactivate'
alias cel='conda env list'
alias ca='conda activate'
alias cda='conda deactivate'
alias cr='clear'
alias yz='yazi'
alias e='eza'
alias el='eza -hl'
alias eal='eza -ahl'
alias et='eza -hT'
alias elt='eza -hlT'
alias bst='bat -S -l tsv'
alias bs='bat -S'

export BAT_THEME="Monokai Extended Origin"

# 历史记录忽略重复的命令
export HISTCONTROL=ignoreboth:erasedups

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
. "$HOME/.cargo/env"

eval "$(starship init bash)"
eval "$(zoxide init bash)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/caicai/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/caicai/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/caicai/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/caicai/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/caicai/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/caicai/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
