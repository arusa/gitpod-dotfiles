#!/usr/bin/env bash

# Install latest static tmux
sudo curl -L https://github.com/axonasif/build-static-tmux/releases/latest/download/tmux.linux-amd64.stripped -o /usr/bin/tmux
sudo chmod +x /usr/bin/tmux

# Auto start tmux on SSH or xtermjs
cat >>"$HOME/.bashrc" <<'EOF'
if test ! -v TMUX && (test -v SSH_CONNECTION || test "$PPID" == "$(pgrep -f '/ide/xterm/bin/node /ide/xterm/index.cjs' | head -n1)"); then {
  if ! tmux has-session 2>/dev/null; then {
    tmux new-session -n "editor" -ds "gitpod"
  } fi
    exec tmux attach
} fi
EOF

curl -L "https://raw.githubusercontent.com/arusa/gitpod-dotfiles/main/gitpod.tmux" --output ~/gitpod.tmux
chmod +x ~/gitpod.tmux
! grep -q 'gitpod.tmux' ~/.tmux.conf 2>/dev/null && echo "run-shell -b 'exec ~/gitpod.tmux'" >>~/.tmux.conf

echo "Install lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/bin

echo "Install nvim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim

echo "Install lazyvim"
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

sudo apt install fd-find
