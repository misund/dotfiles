# Export all Ptyxis settings

(I currently do _not_ have an automated backup mechanism mechanism)

    dconf dump /org/gnome/Ptyxis/ > .config/ptyxis.dconf

# Import Ptyxis settings

(I currently do this in `system_setup.sh`)

    dconf load /org/gnome/Ptyxis/ < $DIR/.config/ptyxis.dconf
