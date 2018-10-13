if [ -z "$(cat $HOME/.dir_colors/dircolors | grep gruvbox)" ]; then
    echo "-> Set colorscheme in Gnome terminal"
    git clone https://github.com/metalelf0/gnome-terminal-colors.git /tmp/gnome-terminal-colors
    default_terminal_id=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
    /tmp/gnome-terminal-colors/install.sh -s gruvbox-dark -p ":$default_terminal_id" --install-dircolors
    rm -rf /tmp/gnome-terminal-colors
    echo "## gruvbox-dark theme" >> $HOME/.dir_colors/dircolors
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${default_terminal_id}/ use-theme-transparency false
fi
