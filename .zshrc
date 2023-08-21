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
# End of lines configured by compinstall


# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias vim='nvim'
alias vi='nvim'

# Zsh plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Pywal
wal -Req

# Starship prompt
eval "$(starship init zsh)"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"  # This loads nvm bash_completion

export PATH="$PATH:$HOME/go/bin"

# Clear screen only when not sourced manually; helps remove text typed before zsh loading finishes
[[ $ZSH_EVAL_CONTEXT =~ :file$ ]] || clear
