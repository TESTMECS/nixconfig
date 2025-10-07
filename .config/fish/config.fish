if status is-interactive
    # Commands to run in interactive sessions can go here
end
alias nvimconfig="nvim $HOME/.config/nvim/init.lua"
alias fishconfig="nvim $HOME/.config/fish/config.fish"
alias ls="eza"
alias ll="eza -l"
alias la="eza -a"
alias l="eza -l"
alias uva="uv add"
alias uvr="uv run"
starship init fish | source
