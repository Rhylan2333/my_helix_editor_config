export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/helix-24.07-x86_64-linux:/usr/local/bin/kent_tools:/usr/local/bin/kent_tools/blat:$PATH"

export BAT_THEME="ansi"

# RepeatMasker
export PERL5LIB="/home/caicai/miniforge3/envs/TE-Annotation/share/RepeatMasker:$PERL5LIB"

export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx PNPM_HOME "/home/caicai/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

alias cr="clear"
alias e="exa"
alias et="exa -T"
alias el="exa -hl"
alias eal="exa -ahl"
alias ma="mamba activate"
alias mda="mamba deactivate"
alias mel="mamba env list"
alias bst="bat -S -l tsv"

starship init fish | source
zoxide init fish | source
thefuck --alias | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/caicai/miniforge3/bin/conda
    eval /home/caicai/miniforge3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/caicai/miniforge3/etc/fish/conf.d/conda.fish"
        . "/home/caicai/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/caicai/miniforge3/bin" $PATH
    end
end

if test -f "/home/caicai/miniforge3/etc/fish/conf.d/mamba.fish"
    source "/home/caicai/miniforge3/etc/fish/conf.d/mamba.fish"
end
# <<< conda initialize <<<

# pnpm
set -gx PNPM_HOME "/home/caicai/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
