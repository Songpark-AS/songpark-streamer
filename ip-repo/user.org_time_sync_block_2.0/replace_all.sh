#sed -i 's/cantavi_streamer_/cantavi_streamer_/g' *

for file in $(find . -name 'time_sync_block*')
do
  mv "$file" "${file/time_sync_block/time_sync_block}"
done

find . \( ! -regex '.*/\..*' \) -type f | xargs sed -i 's/time_sync_block/time_sync_block/g'
