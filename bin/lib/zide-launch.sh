#!/usr/bin/env bash

if zellij ls -n | grep -E '^ZHIDE-Launch .*EXITED' &>/dev/null; then
    alacritty --title ZHIDE --config-file "${ZIDE_CONFIG_DIR}/alacritty/alacritty.toml" --command /usr/local/bin/zellij delete-session ZHIDE-Launch --force
fi
alacritty --title ZHIDE --config-file "${ZIDE_CONFIG_DIR}/alacritty/alacritty.toml" --command /usr/local/bin/zellij delete-session ZHIDE-Launch --force
#if zellij ls -n | grep -E '^ZHIDE-Launch ' &>/dev/null; then
#    alacritty --title ZHIDE --config-file "${ZIDE_CONFIG_DIR}/alacritty/alacritty.toml" --command zellij attach ZHIDE-Launch
#else
    # We don't have a ZHIDE-Launch session yet
    alacritty --title ZHIDE --config-file "${ZIDE_CONFIG_DIR}/alacritty/alacritty.toml" --command /usr/local/bin/zellij --session ZHIDE-Launch --new-session-with-layout zide-launch --config-dir "${ZIDE_CONFIG_DIR}/zellij" &> ${ZIDE_DIR}/log/zhide-launch.log
    
    printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "AZHIDE"

    #sleep 2s
    # Start session-manager plugin
    #sleep 3s
    #zellij --session ZHIDE-Launch action launch-or-focus-plugin zellij:session-manager
    #zellij --session ZHIDE-Launch action move-pane right
    #zellij --session ZHIDE-Launch action rename-pane "Project Manager"
#fi


