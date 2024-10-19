export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
	git
	python
	zoxide
	brew
	colorize
	zsh-autosuggestions 
	zsh-syntax-highlighting 
	fast-syntax-highlighting 
	zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

############ User configuration ############

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# hooking stuff
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# vscode code shell command
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# tmux restore sessions after reboot
tmux start-server
tmux source-file ~/.tmux/resurrect/last

# for android studio
alias adb=~/Library/Android/sdk/platform-tools/adb

# jumbo stuff
alias jumbo-vpn-split="sh ~/.local/bin/jumbovpn"
alias jumbo-vpn-full="sh ~/.local/bin/jumbovpn-full"
alias jumbo-airflow-session="tmux attach-session -t jumbo-airflow"

# allow aerospace
xattr -d com.apple.quarantine /Applications/AeroSpace.app;