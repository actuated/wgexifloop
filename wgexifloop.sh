#!/bin/bash
#wgexifloop.sh
dateCreated="11/03/2019"
dateLastMod="3/1/2020"

#Edit to change tags retrieved with exiftool:
tagArgs="-Author -Creator -LastModifiedBy"

thisTempDir="wgexifloop-$(cat /dev/urandom | tr -dc 'A-Za-z' | head -c 10 | cut -c1-10)"
outStamp=$(date +%F-%H-%M)
csvOut="wgexifloop-$outStamp.csv"
tagsOut="wgexifloop-$outStamp-unique-tags.txt"

function fnWget {
  thisCleanUrl=$(echo "$thisUrl" | sed 's/\r//g')
  thisFileName=$(echo "$thisCleanUrl" | awk -F/ '{print $NF}')
  wget "$thisCleanUrl" --directory-prefix "$thisTempDir/" >/dev/null 2>&1
}

function fnExiftool {
  if [ -f "$thisTempDir/$thisFileName" ]; then
    echo
    echo "Begin Exif Check $countThis of $countTotal For: $thisCleanUrl"
    echo
    exiftool "$thisTempDir/$thisFileName" $tagArgs -S | sed 's/^/"/g' | sed 's/$/"/g' | awk -v awkUrl="$thisCleanUrl" '{print $0 ",\"" awkUrl "\""}' | tee -a "$csvOut" | sed 's/","/"~/g' | awk -F~ '{print $1}'
    echo
    echo "====================================================================================="
    let countThis=countThis+1
  else
    echo
    echo "Error: $thisFileName ($thisCleanUrl) did not download to $thisTempDir/, skipping..."
    echo
    echo "====================================================================================="
  fi
}

function fnCleanup {
  if [ -f "$thisTempDir/$thisFileName" ]; then rm "$thisTempDir/$thisFileName"; fi
}

echo
echo "====================[ wgexifloop.sh by Ted R (github: actuated) ]===================="

if [ "$1" = "" ]; then
  echo
  echo "Error: No input file specified."
  echo
  echo "Usage: ./wgexifloop.sh [list of URLs]"
  echo
  echo 'Uses wget to download each document, then run exifloop for tags in variable $tagArgs:'
  echo "$tagArgs"
  echo "Creates CSV output with tags and URLs, and text list of unique tags."
  echo
  echo "=======================================[ fin ]======================================="
  echo
  exit
fi

# Check to make sure the input file exists
if [ -f "$1" ]; then
  inFile="$1"
  countTotal=$(wc -l $inFile | awk '{print $1}')
else
  echo
  echo "Error: Input file '$1' does not exist."
  echo
  echo "=======================================[ fin ]======================================="
  echo
  exit
fi

# Create temp directory
if [ ! -d "$thisTempDir" ]; then mkdir "$thisTempDir"; fi

# Do functions for each URL
countThis=1
while read -r thisUrl; do
  fnWget
  fnExiftool
  fnCleanup
done < "$inFile"

# Delete temp directory
if [ -d "$thisTempDir" ]; then rm -r "$thisTempDir"; echo; echo "Cleaned up $thisTempDir/..."; fi
if [ -f "$csvOut" ]; then 
  echo
  echo 'Output "Tag: Value","URL" written to '$csvOut"."
  cat "$csvOut" | sed 's/","/~/g' | awk -F~ '{print $1}' | sed 's/^"//g' | sort | uniq > "$tagsOut"
  if [ -f "$tagsOut" ]; then echo "Unique tag values written to $tagsOut."; fi
fi

echo
echo "=======================================[ fin ]======================================="
echo

