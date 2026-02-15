#!/bin/sh

success=0
fail=0
timeout=0

UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

# IP и страна
ip=$(curl -s api.ipify.org)
country=$(curl -s https://ipinfo.io/country)

printf "\nIP = %s [%s]\n\n" "$country" "$ip"

# Проверка RU сервера
ru=$(curl -s -o /dev/null -w "%{http_code}" -A "$UA" --connect-timeout 2 --max-time 10 https://51.250.90.228:20326/SLGxmxkEIQbDU9ARtm)

case "$ru" in
  200|201|204|301|302|304|307|403|498)
    printf "\033[32mСервер RU - Доступен [%s]\033[0m\n\n" "$ru"
    ;;
  000)
    printf "\033[31mСервер RU - Недоступен [таймаут]\033[0m\n\n"
    ;;
  *)
    printf "\033[31mСервер RU - Недоступен [%s]\033[0m\n\n" "$ru"
    ;;
esac

# Список сайтов
sites="
https://yandex.ru
https://dzen.ru
https://vkvideo.ru
https://rutube.ru
https://www.kinopoisk.ru
https://web.telegram.org
https://max.ru
https://www.ozon.ru
https://www.wildberries.ru
https://mail.ru
https://www.avito.ru
https://www.ivi.ru
https://2gis.ru
http://www.rzd.ru
https://www.tbank.ru
https://www.sberbank.ru
https://alfabank.ru
https://www.twitch.tv
https://www.roblox.com
https://store.steampowered.com
https://www.whatsapp.com
https://www.gismeteo.ru
https://discord.com
https://youtube.com
https://google.com
https://github.com
https://www.instagram.com
https://twitter.com
https://reddit.com
https://wikipedia.org
https://www.pornhub.com
"

# Перебор сайтов через while read
echo "$sites" | while read site; do
    [ -z "$site" ] && continue   # пропускаем пустые строки
    code=$(curl -s -o /dev/null -w "%{http_code}" -A "$UA" --connect-timeout 2 --max-time 10 "$site")
    
    # Получаем только домен
    domain=$sites
    case "$code" in
      200|201|204|301|302|304|307|403|498)
        printf "\033[32m%s - Успешно [%s]\033[0m\n" "$domain" "$code"
        success=$((success+1))
        ;;
      000)
        printf "\033[31m%s - Неудачно [таймаут]\033[0m\n" "$domain"
        fail=$((fail+1))
        timeout=$((timeout+1))
        ;;
      *)
        printf "\033[31m%s - Неудачно [%s]\033[0m\n" "$domain" "$code"
        fail=$((fail+1))
        ;;
    esac
done

# Итоги
printf "\nТест завершен\n"
echo "Всего сайтов: $(echo "$sites" | grep -c '\S')"
printf "\033[32mУспешных: %d\033[0m\n" "$success"
printf "\033[31mНеуспешных: %d\033[0m\n" "$fail"
echo "Таймаутов: $timeout"