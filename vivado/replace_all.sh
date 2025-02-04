#sed -i 's/cantavi_streamer_/cantavi_streamer_/g' *

for file in $(find . -name 'audio_mixer_*')
do
  mv "$file" "${file/audio_mixer_/cantavi_streamer_}"
done

find . \( ! -regex '.*/\..*' \) -type f | xargs sed -i 's/cantavi_streamer_/cantavi_streamer_/g'
