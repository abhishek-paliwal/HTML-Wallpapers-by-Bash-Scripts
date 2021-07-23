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

 	#assigning an array to the whole line with each word as its member element.
	stringarray=($line)
	words_in_line=${#stringarray[@]} ;
	filename="$OUTPUT_DIR/wallpaper-for-quote-$countVar-containing-total-$words_in_line-words.html" ;
	echo "wallpaper filename = $filename" ; 
	
	# generate random css colors from another BASH script to the dump file
	bash $WORKDIR/_choose_random_color.sh > $filename;

	##
	echo "//////// $words_in_line = Number of words in this line ////////" ;  #finding the length of the array
	##
	for myWord in "${stringarray[@]}" ; do
		####
		# number of characters needed to make 20 chars
		myWord_len="${#myWord}" ;	
		diff_var=$(expr 20 - $myWord_len); 
		random_number=$((1 + $RANDOM % 360)) ;	  	  
		chars_before=$((1 + $RANDOM % $diff_var)) ;
		
		#evaluating expression and assigning values
		chars_after=$(expr $diff_var - $chars_before) ; 
		
		#length of each string element
		echo "Word length = $myWord_len | Chars needed to make 20 chars is $diff_var | Chars before + chars after = $chars_before + $chars_after ==> $myWord" 
		
		echo "${random_text:$random_number:$chars_before}<span class='custom_text_color'>$myWord</span>${random_text:$random_number:$chars_after}<br>" >> $filename;
	####
	done
	##------------------------------
	
	## The following section adds lines to make it to 20 lines in total in HTML file.		  	
	## Finding the number of lines required to make it to 20 lines
	para_length=$(expr 20 - $words_in_line); 
	echo ">> $para_length = 20 minus length of the array" ; 
	##		
	# Only add lines if there are less than 20 lines (20 words per line)
	if [ "$para_length" -gt "0" ]; then
		echo ">>>>> NUMBER OF WORDS ARE LESS THAN 20. SO FOLLOWING LINES WILL BE ADDED IN HTML FILE.";
		for j in $(seq 1 $para_length)
			do		
				random_number_2=$((1 + $RANDOM % 360)) ;
				text_substr="${random_text:$random_number_2:20}" ;
				echo "$text_substr" ;
				echo "$text_substr<br>" >> $filename;
			done
	else
		echo ">>>>> NUMBER OF WORDS ARE MORE THAN 20. SO NO LINES WILL BE ADDED IN HTML FILE.";
	fi
	##------------------------------
		
	echo "	</h1>
			</div>
			</td></tr></tbody></table>
			</body></html>" >> $filename; #footer for the html file
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
		wkhtmltoimage --quality 100 --disable-smart-width --width 1920 --height 1080 "$f" "$imageName" ;
	done
	## Listing all image + html files in workdir
	echo ">> CURRENT IMAGES IN $HTML_INPUT_DIR ... " ;
	fd --search-path=$HTML_INPUT_DIR -e jpg -e html;
}
HTML_INPUT_DIR="$OUTPUT_DIR" ;
FUNC_CREATE_IMAGES_FROM_HTML_WALLPAPERS "$HTML_INPUT_DIR" ;
################################################################################