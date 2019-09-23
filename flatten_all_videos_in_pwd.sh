#!/usr/bin/env bash

### flatten_all_videos_in_pwd ###

# Flattens all videos in the present working directory into .png files by 
# extracting the center horizontal line of pixels from each frame of the 
# movie, then appending all the single lines into a single flat image.
# Shoud only make flattened images for videos that don't have them yet.
# If the ear is rotating slower/faster than in our lab (~25 seconds per 
# complete rotation) then some additional finagling might need to be done.

# This script requires FFmpeg for frame extraction from input videos, as
# well as ImageMagick for image processing.

# Prevents improper string expansion if no .mov files are present in directory
shopt -s nullglob

# Lists all .mov files in current directory
for file in *.mov
do
	# Gets base name
	name=$(echo $file | sed 's/.mov//') 
	# Checks to see if flattening has already been done
 	if [ ! -e "$name.png" ]; then
 		mkdir ./maize_processing_folder
 		# Frame extraction
		ffmpeg -i ./"$file" -threads 4 ./maize_processing_folder/output_%04d.png
		# Crop to center pixel row (will vary based on video dimensions)
		mogrify -verbose -crop 1920x1+0+540 +repage ./maize_processing_folder/*.png
		# Append rows to one image
		convert -verbose -append +repage ./maize_processing_folder/*.png ./"$name.png"
		# Rotate and crop image
		mogrify -rotate "180" +repage ./"$name.png"
		mogrify -crop 1920x746+0+40 +repage ./"$name.png"
		rm -rf ./maize_processing_folder/
 	fi
done

# Turns back off the string expansion fix
shopt -u nullglob
