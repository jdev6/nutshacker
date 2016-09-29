#!/bin/env sh

if [ "$1" == "" ]; then
    #No arguments
    echo -e "The Nutshack theme song but instead of saying nutshack it plays the video you specify with the command: \n    $0 path/to/video.video_extension"
    exit 1
fi

video="$1"

if [ ! -f "$video" ]; then
    echo "'$video' doesn't exist"
    exit 1
fi

echo "Converting video to webm"
sleep 1

ffmpeg -i "$video" -b:v 1M -b:a 192k -vcodec libvpx -acodec libvorbis input.webm

echo "Creating concat list"
sleep 1
list=""

for n in `seq 1 18`; do
    clip=clips/${n}.webm
    list="$list $clip input.webm"
done
list="$list clips/19.webm"

printf "" > list.txt

for f in $list; do
    echo "file '$f'" >> list.txt
done

ffmpeg -f concat -i list.txt -b:v 64k -bufsize 64k -c copy output.webm

rm input.webm list.txt

#./mmcat.sh $list
#cat $list > output.webm
#cvlc $list