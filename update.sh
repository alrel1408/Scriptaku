#!/bin/bash
clear
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "\033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "\033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}
res1() {
    wget -O menu.zip https://raw.githubusercontent.com/alrel1408/scriptaku/main/menu/menu.zip
    unzip menu.zip
    chmod +x menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu
    rm -rf menu.zip
    
    # Fix semua referensi register yang masih ada - disable completely
    sed -i 's|https://raw.githubusercontent.com/alrel1408/AutoScript/main/Register|# Register system disabled|g' /usr/local/sbin/*
    sed -i 's|https://raw.githubusercontent.com/alrel1408/scriptaku/main/Register|# Register system disabled|g' /usr/local/sbin/*
    sed -i '/data_ip=.*Register system disabled/c\data_ip=""' /usr/local/sbin/*
    sed -i '/curl.*Register system disabled/d' /usr/local/sbin/*
    sed -i '/wget.*Register system disabled/d' /usr/local/sbin/*
    
    # Fix function checking_sc yang menyebabkan permission denied
    sed -i '/checking_sc() {/,/^}/c\
checking_sc() {\
  # Register system disabled - always allow\
  return 0\
}' /usr/local/sbin/*
    
    # Remove all register check logic completely
    sed -i '/useexp.*data_ip/d' /usr/local/sbin/*
    sed -i '/if.*date_list.*useexp/,/fi/d' /usr/local/sbin/*
    sed -i '/MYIP.*curl.*ipinfo/d' /usr/local/sbin/*
    sed -i '/data_ip.*curl.*Register/d' /usr/local/sbin/*
    
    # Remove banned/permission messages
    sed -i '/Permission Denied/d' /usr/local/sbin/*
    sed -i '/EXPIRED SCRIPT/d' /usr/local/sbin/*
    sed -i '/Contact telegram/d' /usr/local/sbin/*
    sed -i '/You are banned/d' /usr/local/sbin/*
    
    # Replace all register validation with always allow
    sed -i 's|if \[\[ $data_ip == *"Permission Denied"* ]]; then|if false; then|g' /usr/local/sbin/*
    sed -i 's|if \[\[ $data_ip == *"EXPIRED SCRIPT"* ]]; then|if false; then|g' /usr/local/sbin/*
    
    # Update branding ke AlrelShop
    sed -i 's|Vallstore|AlrelShop|g' /usr/local/sbin/*
    sed -i 's|VALLSTORE|ALRELSHOP|g' /usr/local/sbin/*
    sed -i 's|𝗩𝗮𝗹𝗹𝘀𝘁𝗼𝗿𝗲|𝗔𝗹𝗿𝗲𝗹𝗦𝗵𝗼𝗽|g' /usr/local/sbin/*
    sed -i 's|082300115583|082285851668|g' /usr/local/sbin/*
    sed -i 's|+6282300115583|+6282285851668|g' /usr/local/sbin/*
    sed -i 's|+6285974151519|+6282285851668|g' /usr/local/sbin/*
    
    # Pastikan symlink menu ada
    ln -sf /usr/local/sbin/menu /usr/bin/menu
    ln -sf /usr/local/sbin/menu /bin/menu
    
    # Update PATH jika diperlukan
    if ! grep -q "/usr/local/sbin" /etc/environment; then
        echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /etc/environment
    fi
    
    # Pastikan menu bisa diakses
    export PATH="/usr/local/sbin:$PATH"
    
    rm -rf update.sh
}
netfilter-persistent
clear

echo -e ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
echo -e "\e[1;97;101m            » UPDATE SCRIPT «             \033[0m"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
echo -e ""
echo -e "\033[1;91mUpdate Script Service\033[1;37m"
fun_bar 'res1'
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat
echo -e ""
read -n 1 -s -r -p "Press [ Enter ] To Back On Menu"
menu
