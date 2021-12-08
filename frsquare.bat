:: Aria2c https://aria2.github.io/
:: Sed for Windows https://sourceforge.net/projects/gnuwin32/
@echo off
chcp 65001
set /p MovieNum=   輸入影片序號:
set /p Camera=  輸入鏡頭數:
set /p Version=  輸入版本號（個位數）：
:: Audio
aria2c "https://fr-vod-sni.akamaized.net/%MovieNum%_tracking_0%Version%/1000//audio_128000/playlist.m3u8"
aria2c "https://fr-vod-sni.akamaized.net/%MovieNum%_tracking_0%Version%/1000/audio_128000/audio_128000/128000.ts"
:: sed 's?原字符串?替换字符串?'
sed -i "s?audio_128000/128000.ts?128000.ts?g; s?https://api.multi.vsp.mb.softbank.jp/api/v1/playkey?playkey?g" playlist.m3u8
ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto -allowed_extensions ALL -i playlist.m3u8 -c copy audio.ts
del playlist.m3u8
:: Video
set /a cnt=1
:loop
echo %cnt%
aria2c "https://fr-vod-sni.akamaized.net/%MovieNum%_tracking_0%Version%/100%cnt%/video_1705032704/playlist.m3u8"
aria2c "https://fr-vod-sni.akamaized.net/%MovieNum%_tracking_0%Version%/100%cnt%/video_1705032704/video_1705032704/1705032704.ts"
sed -i "s?video_1705032704/1705032704.ts?1705032704.ts?g; s?https://api.multi.vsp.mb.softbank.jp/api/v1/playkey?playkey?g" playlist.m3u8
ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto -allowed_extensions ALL -i playlist.m3u8 -c copy video.ts
ffmpeg -i video.ts -i audio.ts -map 0:0 -map 1:0 -c:a copy -disposition:a:0 default -c:v copy  -f mpegts  -copyts -f mpegts camera_%cnt%.ts
del playlist.m3u8
del 1705032704.ts
del video.ts
set /a cnt=%cnt%+1
if %cnt% lss %Camera%+1 goto loop
del audio.ts
del 128000.ts
del sed*
pause.
