# Settings Variables
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Don't slow the zsh if not interactively run
[[ $- != *i* ]] && return


# Configurations
setopt autocd beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/aim/.zshrc'

autoload -Uz compinit
compinit
autoload -Uz bashcompinit
bashcompinit
# End of lines configured by compinstall


# Aliases
#alias ls='ls --color=auto'
alias ls='lsd'
alias grep='grep --color=auto'
alias vim='nvim'
alias vi='nvim'

# Zsh plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Command not found pacman
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=(
        ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
    )
    if (( ${#entries[@]} ))
    then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"
        do
            # (repo package version file)
            local fields=(
                ${(0)entry}
            )
            if [[ "$pkg" != "${fields[2]}" ]]
            then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Environment
export EDITOR="vim"
export VISUAL="$EDITOR"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/share/flutter/bin"
export PATH="$PATH:$HOME/.local/share/istio/bin"
export XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"

# Helpers
#source /etc/zsh_command_not_found

# Starship prompt
eval "$(starship init zsh)"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -s "$HOME/.envrc" ] && \. "$HOME/.envrc"  # This loads nvm bash_completion

# Ocaml
if (( $+commands[opam] )); then
	eval $(opam env);
fi

export GPG_TTY=$(tty)

export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1

#[ -f "/home/aim/.ghcup/env" ] && source "/home/aim/.ghcup/env" # ghcup-env
#. "$HOME/.cargo/env" 


# Load Angular CLI autocompletion.
source <(ng completion script)
