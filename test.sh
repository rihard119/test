#!/bin/sh

success=0
fail=0
timeout=0

ip=$(curl api.ipify.org -s)
contry=$(curl -s https://ipinfo.io/country)

echo -e "\nIP = $contry [$ip]\n"

ru=$(curl -s -o /dev/null -w "%{http_code}" -A "$UA" --connect-timeout 2 --max-time 10 https://51.250.90.228:20326/SLGxmxkEIQbDU9ARtm)

if echo "$ru" | grep -qE "^(200|201|204|301|302|304|307|498|403)$"; then
        echo -e "\e[32mСервер RU - Доступен [$ru]\e[0m\n"
    elif echo "$ru" | grep -qE "^(000)$"; then
        echo -e "\e[31mСервер RU - Недоступен [таймаут]\e[0m\n"
    else
        echo -e "\e[31mСервер RU - Недоступен [$ru]\e[0m\n"
    fi

# Список сайтов для проверки
sites=(
    "https://yandex.ru"
    "https://dzen.ru"
    "https://vkvideo.ru"
    "https://rutube.ru"
    "https://www.kinopoisk.ru"
    "https://web.telegram.org"
    "https://max.ru"
    "https://www.ozon.ru"
    "https://www.wildberries.ru"
    "https://mail.ru"
    "https://www.avito.ru"
    "https://www.ivi.ru"
    "https://2gis.ru"
    "http://www.rzd.ru"
    "https://www.tbank.ru"
    "https://www.sberbank.ru"
    "https://alfabank.ru"
    "https://www.twitch.tv"
    "https://www.roblox.com"
    "https://store.steampowered.com"
    "https://www.whatsapp.com"
    "https://www.gismeteo.ru"
    "https://discord.com"    
    "https://youtube.com"
    "https://google.com"
    "https://github.com"
    "https://www.instagram.com"
    "https://twitter.com"
    "https://reddit.com"
    "https://wikipedia.org"
    "https://www.pornhub.com"
)

# User-Agent для curl (имитация браузера)
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

# Проверяем каждый сайт
for site in "${sites[@]}"; do
    code=$(curl -s -o /dev/null -w "%{http_code}" -A "$UA" --connect-timeout 2 --max-time 10 "$site")

    domain=${site#http://}
    domain=${domain#https://}
    domain=${domain%%/*}

    if echo "$code" | grep -qE "^(200|201|204|301|302|304|307|498|403)$"; then
        echo -e "\e[32m$domain - Успешно [$code]\e[0m"
        ((success++))
    elif echo "$code" | grep -qE "^(000)$"; then
        echo -e "\e[31m$domain - Неудачно [таймаут]\e[0m"
        ((timeout++))
        ((fail++))
    else
        echo -e "\e[31m$domain - Неудачно [$code]\e[0m"
         ((fail++))
    fi
done


echo -e "\nТест завершен\n"
echo "Всего сайтов: ${#sites[@]}"
echo -e "\e[32mУспешных: $success\e[0m"
echo -e "\e[31mНеуспешных: $fail\e[0m\n"