#!/bin/sh
#
# !!! ImageMagick NEEDED !!!
# sudo apt-get install imagemagick
# 
#   ONLY PRIVATE USAGE!
#

fileExtension=jpg
#fileExtension=png
newDir=tempdir
rfidDir=rfiddir
#selectedFromMenu=0
menuOn=false

function_menu()
{
    echo ---MENU---
    echo \\n
    echo What do you want to do?
    echo \\n
    echo \(1\) - Show settings
    echo \(2\) - Edit target directory
    echo \(3\) - Edit temporary directory
    echo \(4\) - Set the file extension
    echo \\n
    echo \(0\) - Do nothing / Run
    echo \\n
    echo your selection: 
    read selectedFromMenu
    
    
    if $selectedFromMenu<=4 || $selectedFromMenu==0 ## THIS NOT WORK, LOOK THE SYNTAX!
    then
        case $selectedFromMenu in
            1)  echo 'Search for file extension: '$fileExtension
                echo 'Target directory: '$rfidDir
                echo 'Temporary directory: '$newDir
                echo \\n
                function_menu;;
            2)  echo 'Set the target folder name:' 
                read target
                rfidDir=$target
                function_menu;;
            3)  echo 'Set the temporary folder name:' 
                read tempTarget
                newDir=$tempTarget
                function_menu;;
            4)  echo 'Set the file extension:'
                read ext
                fileExtension=$ext
                function_menu;;
        esac
    else
        fuction_menu    
    fi
}

if convert --version | grep 6.9.7-4 && true
then
    echo ImageMagick installed.
    echo Create new forder \"$newDir\"
    
    if $menuOn
    then
        function_menu
    fi

    if mkdir $newDir
    then
        mkdir $rfidDir
        #cp *.$fileExtension $newDir
        for picture in *.${fileExtension} 
        do
            echo Found: $picture
            echo Resize $picture to 80x50mm
            # 945x591
            #convert $picture -resize '945x591!' $newDir/$picture
            convert $picture -resize 945x591! -blur '0x20' $newDir/bg_$picture
            echo Created background image bg_$picture
            convert $picture -resize 591x591! $newDir/$picture
            echo Resized $picture
            convert $newDir/bg_$picture $newDir/$picture -gravity center -composite -compose src-atop -flatten $rfidDir/rfid_$picture
            echo Added $picture on the center top to bg_$picture

        done
    fi
    
    rm -r $newDir
else
    echo ImageMagick not installed. Please run \"sudo apt install imagemagick\" 
    echo ""
fi

