# ytnote — source this from ~/Dotfiles/zsh/.aliases (or symlink the `ytnote` script onto PATH).
# Mirrors the ytDL workflow: shortcut + URL and it runs.

export YTNOTE_DIR="${YTNOTE_DIR:-$HOME/Notes/youtube}"

ytnote() {
  command /home/mikekey/Tools/youtube-notetaker/ytnote "$@"
}
alias ytn='ytnote'
alias ytnt='ytnote --no-notes'   # transcript only
