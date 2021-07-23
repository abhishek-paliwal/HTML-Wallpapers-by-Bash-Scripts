#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
	## THIS SCRIPT CREATES WALLPAPERS USING BASH FROM CLI USING AN EXTERNAL QUOTES FILE.
	## CLI USAGE > bash _wallpaper.sh _quotes.txt 
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## First check if command line arguments are present or not.
if [ $# -eq 0 ]; then
    echo "No CLI arguments provided. The program will exit now." ;
	echo "NOTE: Program needs the quotes filepath as argument." ;
    exit 1 ;
fi

################################################################################
WORKDIR="$(pwd)" ;
OUTPUT_DIR="$WORKDIR/_outputs_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $OUTPUT_DIR ;

## GET CLI ARGUMENT
quotes_file="$1" ; 

random_text="COTTONCANDYFRUITCAKECOOKIEDRAGECARAMELSPIEPUDDINGSESAMESNAPSHALVAHJELLYBEANSDONUTSWEETICECREAMPASTRYTOPPINGCOTTONCANDYTOOTSIEROLLSESAMESNAPSGUMMIESCHOCOLATECAKEHALVAHBROWNIEMARSHMALLOWJELLYBISCUITTOFFEEPUDDINGWAFERWAFERSESAMESNAPSFRUITCAKEMARSHMALLOWMUFFINLIQUORICEGUMMIESMUFFINBONBONICECREAMDESSERTPUDDINGDESSERTAPPLEPIEJUJUBESBROWNIEJELLYCANDYCANESFRUITCAKEILOVEJELLYBEANSCARROT";
echo $random_text ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_create_wallpapers () {
	((countVar++)) ;
	line="$1" ;
	echo;
	echo "################################################################################" ;
    echo ">> CURRENT LINE: $line" ;
	echo "################################################################################" ;

 	## Assigning an array to the whole line with each word as its member element.
	stringarray=($line) ;
	words_in_line=${#stringarray[@]} ;
	
	##
	filename="$OUTPUT_DIR/$THIS_SCRIPT_NAME_SANS_EXTENSION-for-quote-$countVar-with-total-$words_in_line-words.html" ;
	echo ">> Wallpaper filename = $filename" ; 
	## Generate random css colors from another BASH script to the dump file
	bash $WORKDIR/_choose_random_color.sh > $filename;
	
	##
	echo "//////// $words_in_line = Number of words in this line ////////" ;  #finding the length of the array

	## Now create a temporary file with each sentence folded at 18 chars.
	tmpFile="$WORKDIR/tmp0.txt" ;
	echo $line | fold -w 18 -s > $tmpFile ;

	## BEGIN: WHILE LOOP
	while IFS='' read -r quoteSentence || [[ -n "$quoteSentence" ]];
	do
		echo "======> Line being read from file => $quoteSentence" ;
		# remove leading and trailing spaces using a single XARGS command.
		quoteSentence=$(echo $quoteSentence | xargs -0) ;
		quoteSentence_len="${#quoteSentence}" ;	
		# finding the number of characters needed to make 20 chars
		diff_var=$(expr 20 - $quoteSentence_len) ;
		
		# finding the characters to insert before and after the quoteSentence to make 20 chars
		chars_before=$((1 + $RANDOM % $diff_var)) ;
		chars_after=$(expr $diff_var - $chars_before) ; 
		
		#length of each string element
		echo "Word length = $quoteSentence_len | Chars needed to make 20 chars is $diff_var | Chars before + chars after = $chars_before + $chars_after ==> $quoteSentence"; 

		# Replacing the empty spaces to something more elegant to separate words.
		random_number0=$((0 + $RANDOM % 360)) ;
		randomChar=${random_text:$random_number0:1};  #choosing one random character
		#echo $randomChar;
		# Now, replacing empty spaces with special HTML separation characters.
		quoteSentence2=$(echo $quoteSentence | sd " " "</span>$randomChar<span class='custom_text_color'>" ) ; 
		##
		random_number=$((0 + $RANDOM % 360)) ;
		echo "Line2 is => $quoteSentence2" ;
		echo "${random_text:$random_number:$chars_before}<span class='custom_text_color'>$quoteSentence2</span>${random_text:$random_number:$chars_after}<br>" >> $filename;
	######	
	done < $tmpFile
	# END: WHILE LOOP
	
	## Insert footer for the html file
	echo "</h1><hr>
	<h1 align='center' style='font-size: 20px; font-weight: bold ;'>WWW.YOURWEBSITE.COM</h1>
	<hr></div></td></tr></tbody></table>
	</body></html>" >> $filename ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#BEGIN WHILE LOOP TO READ EVERY LINE IN THE FILE read from the command line
countVar=0;
while IFS='' read -r line || [[ -n "$line" ]]; do
	FUNC_create_wallpapers "$line" ;
done < "$quotes_file"
# ENDING WHILE LOOP TAKING THE FILE NAME FROM THE COMMAND LINE

################################################################################
## GENERATING IMAGES FOR WALLPAPER HTML FILES USING WKHTMLTOIMAGE
function FUNC_CREATE_IMAGES_FROM_HTML_WALLPAPERS () {
	HTML_INPUT_DIR="$1" ;
	echo;  
	echo "########## Creating IMAGE Wallpapers from HTMLs ###########";
	for f in $(fd 'wallpaper' --search-path=$HTML_INPUT_DIR -e html) ; do
		imageName=$(echo "$f" | sd '.html' '.jpg') ;
		echo "Generating image from => $f" ;
		echo "Image Name => $imageName" ;
		wkhtmltoimage --quality 100 --zoom 1.5 --disable-smart-width --width 1920 --height 1080 "$f" "$imageName" ;
	done
	## Listing all image + html files in workdir
	echo ">> CURRENT IMAGES IN $HTML_INPUT_DIR ... " ;
	fd --search-path=$HTML_INPUT_DIR -e jpg -e html;
}
HTML_INPUT_DIR="$OUTPUT_DIR" ;
FUNC_CREATE_IMAGES_FROM_HTML_WALLPAPERS "$HTML_INPUT_DIR" ;
################################################################################