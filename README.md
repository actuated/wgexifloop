# wgexifloop
Shell script to read a list of URLs, wget each document, and retrieve name metadata with exifloop while creating CSV output to track what metadata came from what URL.

# Usage
```
./wgexifloop.sh [list of URLs]
```
* Use tools like PowerMeta to create a list of URLs for office documents.
* Script will:
  - `wget` each file to a temp directory.
  - Use `exiftool` to extract Author, Creator, and Last Modified By metadata (change with the `tagArgs` script variable).
  - Append `"Tag: Value","URL"` to a CSV file `wgexifloop-YYYY-MM-DD-HH-MM.csv`.
  - Show the output `"Tag: Value"` for each file in stdout.
  - Clean up each file after it's checked, then clean up  the temp directory at the end.
  - When done, generate a sorted list of unique `Tag: Value` results as `wgexifloop-YYYY-MM-DD-HH-MM-unique-tags.txt`.
 
# Demo
```
root@k201a:/tr/temp/metadata# cat urls.txt 
http://127.0.0.1/file1.docx
http://127.0.0.1/file2.pdf
http://127.0.0.1/file3.docx

root@k201a:/tr/temp/metadata# /tr/github/wgexifloop/wgexifloop.sh urls.txt 

====================[ wgexifloop.sh by Ted R (github: actuated) ]====================

Begin Exif Check 1 of 3 For: http://127.0.0.1/file1.docx

"Creator: John Smith"
"LastModifiedBy: John Smith"

=====================================================================================

Begin Exif Check 2 of 3 For: http://127.0.0.1/file2.pdf

"Author: John Smith"
"Creator: John Smith"

=====================================================================================

Begin Exif Check 3 of 3 For: http://127.0.0.1/file3.docx


=====================================================================================

Cleaned up wgexifloop-lNqnvRjjqz/...

Output "Tag: Value","URL" written to wgexifloop-2020-03-01-11-23.csv.
Unique tag values written to wgexifloop-2020-03-01-11-23-unique-tags.txt.

=======================================[ fin ]=======================================
 
root@k201a:/tr/temp/metadata# cat wgexifloop-2020-03-01-11-23.csv 
"Creator: John Smith","http://127.0.0.1/file1.docx"
"LastModifiedBy: John Smith","http://127.0.0.1/file1.docx"
"Author: John Smith","http://127.0.0.1/file2.pdf"
"Creator: John Smith","http://127.0.0.1/file2.pdf"

root@k201a:/tr/temp/metadata# cat wgexifloop-2020-03-01-11-23-unique-tags.txt 
Author: John Smith
Creator: John Smith
LastModifiedBy: John Smith
```
