#!/usr/bin/env bash

### flatten_all_movies_in_pdw ###

# Flattens all movies in the present working directory into .png files by 
# extracting the center horizontal line of pixels from each frame of the 
# movie, then appending all the single lines into a single flat image.
# Shoud only make flattened images for movies that don't have them yet.
# If the corn is rotating slower/faster than in our lab (~25 seconds per 
# complete rotation) then some additional finagling might need to be done.

# This script requires FFmpeg for frame extraction from input movies, as
# well as ImageMagick for image processing.

shopt -s nullglob # This fixes a weird bash thing that can cause problems

for file in *.mov
do
	name=$(echo $file | sed 's/.mov//') 
 	if [ ! -e "$name.png" ]; then
 		mkdir ./maize_processing_folder
		ffmpeg -i ./"$file" -threads 4 ./maize_processing_folder/output_%04d.png
		mogrify -verbose -crop 1920x1+0+540 +repage ./maize_processing_folder/*.png
		convert -verbose -append +repage ./maize_processing_folder/*.png ./"$name.png"
		mogrify -rotate "180" +repage ./"$name.png"
		mogrify -crop 1920x746+0+40 +repage ./"$name.png"
		rm -rf ./maize_processing_folder/
 	fi
done

shopt -u nullglob # Turns back off the fix