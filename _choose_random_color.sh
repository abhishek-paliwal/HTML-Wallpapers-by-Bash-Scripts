#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ## THIS BASH SCRIPT CALLS THIS BASH SCRIPT INSIDE IT :> sh _wallpaper_creator.sh _quotes.txt
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

primary_colors=('#000000' '#2196F3' '#795548' '#607D8B' '#FF9800' '#009688' '#C0C0C0' '#FFEB3B' '#F44336' '#E91E63' '#9C27B0' '#673AB7' '#00BCD4' '#4CAF50' '#CDDC39' '#3F51B5' '#FFFFFF') ;

darker_primary_colors=('#454545' '#1976D2' '#5D4037' '#455A64' '#F57C00' '#00796B' '#A0A0A0' '#FBC02D' '#D32F2F' '#FF4081' '#7B1FA2' '#512DA8' '#0097A7' '#388E3C' '#AFB42B' '#303F9F' '#E0E0E0') ;

custom_text_color=('#FFFFFF' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#000000' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#FFFFFF' '#000000') ;

# Finding a random number for the length of the colors array, which is 17 currently
random_number=$((0 + $RANDOM % 17)) ; 
chosen_primary_color="${primary_colors[$random_number]}"
chosen_darker_primary_colors="${darker_primary_colors[$random_number]}"
chosen_custom_text_color="${custom_text_color[$random_number]}"

html_header="<!--DOCTYPE html -->
<html>
<head>
<meta charset='utf-8'>
<title>Wallpaper</title>
<link href='https://fonts.googleapis.com/css?family=Source+Code+Pro:400,200,300,700,900' rel='stylesheet' type='text/css'>
<style>
body { background-color: $chosen_primary_color; /*PRIMARY COLOR*/ }

p { font-family: 'Source Code Pro'; }

h1 {
    color: $chosen_darker_primary_colors; /*DARKER VERSION OF PRIMARY COLOR*/
    margin-left: 20px;
    margin-top: 20px;
    font-family: 'Source Code Pro';
    font-weight: 200;
    font-size: 50px;
    letter-spacing: 20px;
    /* line-height: 40px; */
}

.custom_text_color { color: $chosen_custom_text_color; /* text color BLACK or WHITE selected */ }

mark {
    background-color: $chosen_darker_primary_colors;
    color: $chosen_primary_color;
}

/* THESE PAGE PRINT AND LAYOUT SETTINGS ONLY WORK ON GOOGLE CHROME*/
@media (max-width: 20in) {
    @page {
    size: 12in 7.2in; /* 16:10 resolution. Change This Size to Match to Your Needs */
    }
    p {
        font-family: 'Source Code Pro';
    }
    
    h1 {
        font-family: 'Source Code Pro';
        font-weight: 200;
        font-size: 40px;
        letter-spacing: 20px;
        line-height: 40px;
    }
}
</style>
</head>
<body>
<table width='100%' height='95%' border='0'>
<tbody>
<tr>
    <td valign='middle'>
<div>
<h1 align='center'>" ;

echo "$html_header" ;
