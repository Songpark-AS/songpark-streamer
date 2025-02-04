#sed -i 's/cantavi_streamer_/cantavi_streamer_/g' *

for file in $(find . -name 'Audio_Fader_*')
do
  mv "$file" "${file/Audio_Fader_/Audio_Medfilter_}"
done

find . \( ! -regex '.*/\..*' \) -type f | xargs sed -i 's/Audio_Fader_/Audio_Medfilter_/g'
