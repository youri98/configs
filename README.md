## install


```bash
# install nerd fonts to support additional characters
brew tap homebrew/cask-fonts
brew install --cask font font-meslo-lg-nerd-font

# some usefull installations
brew install git fd ripgrep nvim zoxide direnv tmux

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

easy kickstart for neo vim
```bash
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

```


```bash
# install zsh autocompletion, autosuggestions, and syntax highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
```

```bash
# copy .zshrc config and source zsh
cp ~/.zshrc ~/.zshrc_backup
wget https://raw.githubusercontent.com/youri98/configs/main/.zshrc -O ~/.zshrc
source ~/.zshrc
```

```bash
#tmux stuff
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
wget https://raw.githubusercontent.com/youri98/configs/main/.tmux.conf -O ~/.tmux.conf
tmux source ~/.tmux.conf
```
