# wgexifloop
Shell script to read a list of URLs, wget each document, and retrieve name metadata with exifloop while creating CSV output to track what metadata came from what URL.

# Usage
```
./wgexifloop.sh [list of URLs]
```
* Use tools like PowerMeta to create a list of URLs for office documents.
* Script will:
  - `wget` each file to a temp directory
  - Use `exiftool` to extract Author, Creator, and Last Modified by metadata (change with the `tagArgs` script variable).
  - Append `"Tag: Value","URL"` to a CSV file `wgexifloop-YYYY-MM-DD-HH-MM.csv`.
  - Show the output `"Tag: Value"` for each file in stdout.
  - When done, generate a sorted list of unique `Tag: Value` results as `wgexifloop-YYYY-MM-DD-HH-MM-unique-tags.txt`.
 
