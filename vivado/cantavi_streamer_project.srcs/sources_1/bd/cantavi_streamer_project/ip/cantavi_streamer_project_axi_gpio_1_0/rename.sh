for file in cantavi_streamer_*
do
  mv "$file" "${file/cantavi_streamer_/cantavi_streamer_}"
done
