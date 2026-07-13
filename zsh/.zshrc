alias v=nvim
alias z=zoxide
alias lg=lazygit
alias hx=helix

export PATH="/home/yank/.bun/bin:$PATH"
export PATH="/home/yank/.cargo/bin:$PATH"
export PATH="/home/yank/llama.cpp/build/bin:$PATH"
export PATH="/home/yank/.local/share/coursier/bin:$PATH"
export SEARXNG_URL="http://searxng.tail9bbb5.ts.net:8080/"

eval "$(direnv hook zsh)"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure


export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border --inline-info'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# ghcd - ghq listをfzfで絞り込んでcd
ghcd() {
  local dir
  dir=$(ghq list | fzf --prompt='repos> ' --preview 'ls -la $(ghq root)/{}' --preview-window 'right:50%')
  if [[ -n "$dir" ]]; then
    cd "$(ghq root)/$dir"
  fi
}

