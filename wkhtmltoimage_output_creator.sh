#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
	## This file converts HTML pages (from the web or locally from a folder) to PNG or JPG images
	## For this, you might need to install wkhtmltoimage utility for linux or Mac from here:
	## https://wkhtmltopdf.org/downloads.html
	## SEE > wkhtmltoimage --H at the command prompt for more help.
	## RUN COMMAND: sh _wkhtmltoimage_output_creator.sh
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


## Initiating a shell command to create an image automatically from the generated HTML wallpaper files
echo "Creating IMAGE Wallpapers from HTMLs --------------------------- ";
for f in *.html
do
	 echo "Generating image from $f";
	 wkhtmltoimage --quality 100 --zoom 2 "$f" "./_sample_output/$f.jpg";
done

## Opening Finder at the output folder
open ./_wkhtmltoimage_output
