# =============================================================================
#                                   Functions
# =============================================================================
zsh_wifi_signal() {
  local output=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I)
  local airport=$(echo $output | grep 'AirPort' | awk -F': ' '{print $2}')

  if [ "$airport" = "Off" ]; then
          local color='%F{black}'
          echo -n "%{$color%}Wifi Off"
  else
          local ssid=$(echo $output | grep ' SSID' | awk -F': ' '{print $2}')
          local speed=$(echo $output | grep 'lastTxRate' | awk -F': ' '{print $2}')
          local color='%F{black}'

          [[ $speed -gt 100 ]] && color='%F{black}'
          [[ $speed -lt 50 ]] && color='%F{red}'

          echo -n "%{$color%}$speed Mbps \uf1eb%{%f%}" # removed char not in my PowerLine font
  fi
}

# =============================================================================
#                                   Variables
# =============================================================================
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export FZF_DEFAULT_OPTS='--height 40% --reverse --border --inline-info --color=dark,bg+:235,hl+:10,pointer:5'

export ENHANCD_FILTER="fzf:peco:percol"
export ENHANCD_COMMAND='c'

# =============================================================================
#                                   Plugins
# =============================================================================
# Check if zplug is installed
[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

# =============================================================================
#                                   Options
# =============================================================================
# improved less option
export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"

# Key timeout and character sequences
KEYTIMEOUT=1
WORDCHARS='*?_-[]~=./&;!#$%^(){}<>'

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.
setopt hist_ignore_space        # Ignore commands that start with space.
setopt pushd_ignore_dups        # Dont push copies of the same dir on stack.
setopt pushd_minus              # Reference stack entries with "-".
setopt extended_glob

# =============================================================================
#                                   Aliases
# =============================================================================

# In the definitions below, you will see use of function definitions instead of
# aliases for some cases. We use this method to avoid expansion of the alias in
# combination with the globalias plugin.

# Directory coloring
if [[ $OSTYPE = (darwin|freebsd)* ]]; then
  export CLICOLOR="YES" # Equivalent to passing -G to ls.
  export LSCOLORS="exgxdHdHcxaHaHhBhDeaec"

  [ -d "/opt/local/bin" ] && export PATH="/opt/local/bin:$PATH"

  # Prefer GNU version, since it respects dircolors.
  if (( $+commands[gls] )); then
    alias ls='() { $(whence -p gls) -Ctr --file-type --color=auto $@ }'
  else
    alias ls='() { $(whence -p ls) -CFtr $@ }'
  fi
else
  alias ls='() { $(whence -p ls) -Ctr --file-type --color=auto $@ }'
fi

# Set editor preference to nvim if available.
if (( $+commands[nvim] )); then
  alias vim='() { $(whence -p nvim) $@ }'
else
  alias vim='() { $(whence -p vim) $@ }'
fi

alias grep='() { $(whence -p grep) --color=auto $@ }'
alias egrep='() { $(whence -p egrep) --color=auto $@ }'
alias rm='rm -v'
alias la='ls -a'
alias ll='ls -l'

# =============================================================================
#                                Key Bindings
# =============================================================================
# Common CTRL bindings.
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^f" forward-word
bindkey "^b" backward-word
bindkey "^k" kill-line
bindkey "^d" delete-char
bindkey "^y" accept-and-hold
bindkey "^w" backward-kill-word
bindkey "^u" backward-kill-line
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^F" history-incremental-pattern-search-forward

# =============================================================================
#                                   Startup
# =============================================================================
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

if ! zplug check; then
    printf "Install plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

if zplug check "zsh-users/zsh-syntax-highlighting"; then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)
  ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[cursor]='bg=yellow'
  ZSH_HIGHLIGHT_STYLES[globbing]='none'
  ZSH_HIGHLIGHT_STYLES[path]='fg=white'
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[command]='fg=green'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
  ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
  ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
fi

if zplug check "bhilburn/powerlevel9k"; then
  ZSH_THEME="powerlevel9k/powerlevel9k"

  # Font mode for powerlevel9k
  POWERLEVEL9K_MODE="nerdfont-complete"

  # Prompt settings
  POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
  POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%K{white}%k"
  POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%K{$DEFAULT_BACKGROUND} \u21aa "
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time custom_wifi_signal battery)

  # Separators
  POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\ue0b0'
  POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\ue0b5'
  POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\ue0b2'
  POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\ue0b7'

  # Context
  POWERLEVEL9K_CONTEXT_TEMPLATE=$'%F{cyan}\u23fb %F{white}%n%f'
  POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="clear"
  POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="white"

  # Directory segment
  POWERLEVEL9K_DIR_HOME_BACKGROUND='white'
  POWERLEVEL9K_DIR_HOME_FOREGROUND='black'
  POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='white'
  POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='black'
  POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='white'
  POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='black'
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
  POWERLEVEL9K_HOME_SUB_ICON=''
  POWERLEVEL9K_FOLDER_ICON=''

  # VCS icons
  POWERLEVEL9K_VCS_GIT_ICON=''
  POWERLEVEL9K_VCS_GIT_GITHUB_ICON=''
  POWERLEVEL9K_VCS_GIT_GITLAB_ICON=''

  # VCS colours
  POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='green'
  POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'
  POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='green'
  POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
  POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
  POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'

  # VCS CONFIG
  POWERLEVEL9K_SHOW_CHANGESET=false

  # Status
  POWERLEVEL9K_OK_ICON=$'\uf164'
  POWERLEVEL9K_FAIL_ICON=$'\uf165'
  POWERLEVEL9K_CARRIAGE_RETURN_ICON=$'\uf165'
  POWERLEVEL9K_STATUS_VERBOSE=false

  # Time
  POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"

  # Battery
  POWERLEVEL9K_BATTERY_LOW_FOREGROUND='red'
  POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND='blue'
  POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND='green'
  POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND='blue'
  POWERLEVEL9K_BATTERY_VERBOSE=false

  # Custom
  POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"
  POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_BACKGROUND="white"
  POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_FOREGROUND="black"
fi

# Source plugins and add commands to $PATH
zplug load

# Source defined functions.
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# Source local customizations.
[[ -f ~/.zsh_local ]] && source ~/.zsh_local

# Source exports and aliases.
[[ -f ~/.zsh_exports ]] && source ~/.zsh_exports
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# vim: ft=zsh
