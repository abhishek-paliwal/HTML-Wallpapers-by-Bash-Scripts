#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
	## THIS SCRIPT CREATES WALLPAPERS USING BASH FROM CLI USING AN EXTERNAL QUOTES FILE.
	## CLI USAGE > sh _wallpaper.sh _quotes.txt 
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


random_text="COTTONCANDYFRUITCAKECOOKIEDRAGECARAMELSPIEPUDDINGSESAMESNAPSHALVAHJELLYBEANSDONUTSWEETICECREAMPASTRYTOPPINGCOTTONCANDYTOOTSIEROLLSESAMESNAPSGUMMIESCHOCOLATECAKEHALVAHBROWNIEMARSHMALLOWJELLYBISCUITTOFFEEPUDDINGWAFERWAFERSESAMESNAPSFRUITCAKEMARSHMALLOWMUFFINLIQUORICEGUMMIESMUFFINBONBONICECREAMDESSERTPUDDINGDESSERTAPPLEPIEJUJUBESBROWNIEJELLYCANDYCANESFRUITCAKEILOVEJELLYBEANSCARROT";
echo $random_text;

while IFS='' read -r quoteSentence || [[ -n "$quoteSentence" ]];
do
	stringarray=($quoteSentence) #assigning an array to the whole line with each word as its member element.
	filename=`echo ${#stringarray[@]}-WORDS-$quoteSentence.html`;

	touch "$filename" ; # create an empty text file
	touch tmp_css.html ; # create a temporary css dump file
	sh _choose_random_color.sh > tmp_css.html # generate random css colors from another BASH script to the dump file

	cat tmp_css.html > $filename; #copy dump css as the header for the html file

	#Now create a temporary file with each sentence folded at 18 chars.
	echo $quoteSentence | fold -w 18 -s > tmp0.txt;



		#BEGIN WHILE LOOP TO READ EVERY LINE IN THE FILE read from the command line
		while IFS='' read -r line || [[ -n "$line" ]];
		do
		    echo "\n###############################\n";
		    echo "Line being read from file:\n $line" ;

		    # remove leading and trailing spaces using a single XARGS command.
		    line=`echo $line | xargs -0`;

			# finding the number of characters needed to make 20 chars
			diff_var=`expr 20 - ${#line}`; # ${#line} is the number of chars in line

			# finding the characters to insert before and after the line to make 20 chars
			chars_before=`jot -r 1  0 $diff_var`;
			chars_after=`expr $diff_var - $chars_before`; #evaluating expression and assigning values

			echo "$line ==> Word length = ${#line} | Chars needed to make 20 chars is $diff_var | Chars before + chars after = $chars_before + $chars_after"; #length of each string element

			# Replacing the empty spaces to something more elegant to separate words.
			random_number0=`jot -r 1  0 360`;
			randomChar=${random_text:$random_number0:1};  #choosing one random character
			echo $randomChar;

			line2=`echo $line | sed 's/ /<\/span>'\$randomChar'<span class="custom_text_color">/g'`; #Now, replacing empty spaces with special HTML separation characters.

			line=$line2; #Assigning the variable back to the original name.

			#Mac only random number generator on bash
			random_number=`jot -r 1  0 360`;
			echo "Line2 is" $line2;

			echo "${random_text:$random_number:$chars_before}""<span class='custom_text_color'>$line</span>""${random_text:$random_number:$chars_after}""<br>" >> $filename;


		done < tmp0.txt
		# ENDING WHILE LOOP TAKING THE FILE NAME EXPLICITLY.

echo "</h1>\n<hr>\n<h2 align='center'>WWW.ABHISHEKPALIWAL.COM</h2>\n<hr>\n</div>\n</td></tr></tbody></table>\n</body>\n</html>" >> $filename; #footer for the html file

done < "$1"
