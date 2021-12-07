@echo off
chcp 65001
set /p MovieNum=   輸入影片序號:
set /p Camera=  輸入鏡頭數:
:: Audio
aria2c "https://fr-vod-sni.akamaized.net/%MovieNum%_tracking_01/1000//audio_128000/playlist.m3u8"
aira2c "https://fr-vod-sni.akamaized.net/%MovieNum%_tracking_01/1000/audio_128000/audio_128000/128000.ts"
:: sed 's?原字符串?替换字符串?'
sed -i "s?audio_128000/128000.ts?128000.ts?g; s?https://api.multi.vsp.mb.softbank.jp/api/v1/playkey?playkey?g" playlist.m3u8
ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto -allowed_extensions ALL -i playlist.m3u8 -c copy audio.ts
del playlist.m3u8
:: Video
aria2c "https://fr-vod-sni.akamaized.net/%MovieNum%_tracking_01/1001/video_1705032704/playlist.m3u8"
aria2c "https://fr-vod-sni.akamaized.net/%MovieNum%_tracking_00/1001/video_1705032704/video_1705032704/1705032704.ts"
sed -i "s?video_1705032704/1705032704.ts?1705032704.ts?g; s?https://api.multi.vsp.mb.softbank.jp/api/v1/playkey?playkey?g" playlist.m3u8
ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto -allowed_extensions ALL -i playlist.m3u8 -c copy video.ts
ffmpeg -i video.ts -i audio.ts -map 0:0 -map 1:0 -c:a copy -disposition:a:0 default -c:v copy  -f mpegts  -copyts -f mpegts merge.ts