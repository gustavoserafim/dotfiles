# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zshrc.pre.zsh"

################################################################################
# Zsh for Humans
################################################################################

# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Don't start tmux.
zstyle ':z4h:' start-tmux       no

# Move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'yes'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'mac'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
# zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
# zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
# zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
# z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

# Creates helpful shortcut aliases for many commonly used commands.
z4h load ohmyzsh/ohmyzsh/plugins/common-aliases

# Prevents any code from actually running while pasting, so you have a chance to
# review what was actually pasted before running it.
z4h load ohmyzsh/ohmyzsh/plugins/safe-paste

# Adds integration with asdf
z4h load ohmyzsh/ohmyzsh/plugins/asdf

# This plugin adds completion for CocoaPods. 
z4h load ohmyzsh/ohmyzsh/plugins/pod

# Adds completion for the Kubernetes cluster manager, as well as some aliases for
# common kubectl commands. 
#   USAGE: see https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl
z4h load ohmyzsh/ohmyzsh/plugins/kubectl

# Extracts any archive. USAGE:
#   extract <filename>
z4h load ohmyzsh/ohmyzsh/plugins/extract

# Helps list the shortcuts that are currently available based on the plugins you
# have enabled. USAGE:
#   acs
#   acs <keyword>
z4h load ohmyzsh/ohmyzsh/plugins/aliases

################################################################################
# LOAD AND CONFIG
################################################################################

# load asdf
/opt/homebrew/opt/asdf/libexec/asdf.sh

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

# Colors.
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Nicer prompt.
export PS1=$'\n'"%F{green} %*%F %3~ %F{white}"$'\n'"$ "

# Enable plugins.
plugins=(git brew history kubectl history-substring-search)

# Allow history search via up/down keys.
source ${share_path}/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Git aliases.
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Completions.
autoload -Uz compinit && compinit
# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

################################################################################
# KEY BINDINGS
################################################################################

z4h bindkey undo Ctrl+/   Shift+Tab # undo the last command line change
z4h bindkey redo Option+/           # redo the last undone command line change

z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

################################################################################
# ALIASES
################################################################################

# Flutter w/ FVM
alias flutter="fvm flutter"
alias dart="fvm dart"

# tree (from homebrew)
alias tree='tree -a -I .git'

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

################################################################################
# ENVIRONMENT VARIABLES
################################################################################

# Set iTerm as the default terminal.
export TERM_PROGRAM="iTerm.app"

# Enable NVM
export NVM_DIR="$HOME/.nvm"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/admin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/admin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/admin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/admin/google-cloud-sdk/completion.zsh.inc'; fi

# JAVA env
export JAVA_HOME=$(/usr/libexec/java_home)

#Flutter
export PATH="$PATH:`pwd`/fvm/default/bin"
export FLUTTER_ROOT=~/fvm/default
export PATH=$PATH:$FLUTTER_ROOT/bin:$FLUTTER_ROOT/bin/cache/dart-sdk/bin:~/.pub-cache/bin

# COCOAPODS
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# Kubernetes
export KUBECONFIG=~/.kube/config:$(ls -d ~/.kube/config.d/* | python -c 'import sys; print(":".join([l.strip() for l in sys.stdin]).strip())')
export PATH=$HOME/.kubectl-plugins:$PATH

# ADB

# GO
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Others
export PATH=$HOME/.local/bin:$PATH
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
