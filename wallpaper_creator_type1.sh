#!/bin/bash
## USAGE :> sh _wallpaper.sh _quotes.txt 

#random_text="LOREMIPSUMDOLORSITAMETCONSECTETURADIPISICINGELITSEDDOEIUSMODTEMPORINCIDIDUNTUTLABOREETDOLOREMAGNAALIQUAUTENIMADMINIMVENIAMQUISNOSTRUDEXERCITATIONULLAMCOLABORISNISIUTALIQUIPEXEACOMMODOCONSEQUATDUISAUTEIRUREDOLORINREPREHENDERITINVOLUPTATEVELITESSECILLUMDOLOREEUFUGIATNULLAPARIATUREXCEPTEURSINTOCCAECATCUPIDATATNONPROIDENTSUNTINCULPAQUIOFFICIADESERUNTMOLLITANIMIDESTLABORUM";
random_text="COTTONCANDYFRUITCAKECOOKIEDRAGECARAMELSPIEPUDDINGSESAMESNAPSHALVAHJELLYBEANSDONUTSWEETICECREAMPASTRYTOPPINGCOTTONCANDYTOOTSIEROLLSESAMESNAPSGUMMIESCHOCOLATECAKEHALVAHBROWNIEMARSHMALLOWJELLYBISCUITTOFFEEPUDDINGWAFERWAFERSESAMESNAPSFRUITCAKEMARSHMALLOWMUFFINLIQUORICEGUMMIESMUFFINBONBONICECREAMDESSERTPUDDINGDESSERTAPPLEPIEJUJUBESBROWNIEJELLYCANDYCANESFRUITCAKEILOVEJELLYBEANSCARROT";
echo $random_text;

#BEGIN WHILE LOOP TO READ EVERY LINE IN THE FILE read from the command line
while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "\n###############################\n";
    echo "Line being read from file:\n $line" ;

	stringarray=($line) #assigning an array to the whole line with each word as its member element.

	filename=`echo ${#stringarray[@]}-WORDS-$line.html`;
	
	touch "$filename" ; # create an empty text file
	
	touch tmp_css.html ; # create a temporary css dump file
	sh _choose_random_color.sh > tmp_css.html # generate random css colors from another BASH script to the dump file

	cat tmp_css.html > $filename; #copy dump css as the header for the html file


	echo "============\n Size of array = Number of words in line = ${#stringarray[@]} \n============" ;  #finding the length of the array
	
	for i in "${stringarray[@]}"
	    do
		      random_number=`jot -r 1  1 360`; #Mac only random number generator on bash

		      myvar=$i # assign a separate variable to each element, $i
		  	  # ${#myvar} is the length of the variable
		  	  diff_var=`expr 20 - ${#myvar}`; # number of characters needed to make 20 chars
		  	  
		  	  chars_before=`jot -r 1  1 $diff_var`;
		  	  chars_after=`expr $diff_var - $chars_before`; #evaluating expression and assigning values

		  	  echo "$i ==> Word length = ${#myvar} | Chars needed to make 20 chars is $diff_var | Chars before + chars after = $chars_before + $chars_after" #length of each string element
		  	  
		  	  echo "${random_text:$random_number:$chars_before}""<span class='custom_text_color'>$i</span>""${random_text:$random_number:$chars_after}""<br>" >> $filename;

	  	done

	  	#The following section adds lines to make it to 20 lines in total in HTML file.
		  	
			  	echo ">>>>>> 20 - length of the array is: " `expr 20 - ${#stringarray[@]}` ; #number of lines to make it to 20 lines
				
				para_length=`expr 20 - ${#stringarray[@]}`; #finding the number of lines required to make it to 20 lines
				
				# only add lines if there are less than 20 lines (20 words per quote or line), else don't add anything.
				if [ "$para_length" -gt "0" ]; then
					for j in $(seq 1 $para_length)
						do		
							random_number_2=`jot -r 1  1 360`;
						    echo "${random_text:$random_number_2:20}""<br>" >> $filename;
		                	echo "${random_text:$random_number_2:20}""<br>" ;
		            	done
		        else
		        	echo ">>>>> NUMBER OF WORDS ARE MORE THAN 20. SO NO LINES WILL BE ADDED IN HTML FILE.";
		    	fi
			
		
	  	echo "</h1>\n</div>\n</td></tr></tbody></table>\n</body>\n</html>" >> $filename; #footer for the html file
	

done < "$1"
# ENDING WHILE LOOP TAKING THE FILE NAME FROM THE COMMAND LINE

