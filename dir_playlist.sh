#!/bin/bash

#	Create a playlist.xml for Flash Image Rotator from photo directories. (http://media.dreamhost.com)
#	These steps parse a Linux image hierarchy to build data file.  It may make sense to run
#	these individually vs. as a single script Note: the final step of creating the XML file does not 
#	like spaces, so those entries containing spaces in path or filename are removed.	

#	Create a data file with all the photos in the directory and subdirs. If 
#	just photos exist, this can be as simple as:
find /path/to/your/pics/ > photos.txt

#	If you have other files in the hierarchy or you want to exclude some types
#	you can add conditions.  For example I only want thumbnails not tagged private:
find /path/to/your/pics/ -name *JPG_w175h* | grep private -v > photos.txt

#	Now you should have a file with lines like: /path/to/your/pics/2008/December/GirlsKenechiNight/thumb_cache/thumbcache_DSCF9911.JPG_w175h131.jpg
# 	You can use thes paths as-is to generate the xml
 
#	Or you may wish to format them further to suit your needs.  I decided to convert the paths to URL format
#	to provide more portability.  First, remove the path detail above the WWW_ROOT for every line in the file:
cat photos.txt | cut -c14- > trimmed.txt

#	I add the URL header to the beginning of each line in the file:
cat trimmed.txt | sed 's/^/http:\/\/markpreynolds.com/' > URLs.txt

#	This should format all your lines like this:
#	http://markpreynolds.com/pics/2008/December/GirlsKenechiNight/thumb_cache/thumbcache_DSCF9911.JPG_w175h131.jpg

#	If you end up with too many items and would like to reduce the number, you can cull the file with sed.
#	I had over 12,000 so this example keeps only every 10th line:
cat URLs.txt | sed -n '3,${p;n;n;n;n;n;n;n;n;n;}' > culled.txt

#	Remove lines with spaces:
grep -v " " culled.txt > nospaces.txt

#	Build the playlist.xml file with no title/link and blank description.  In the example, the 
#	the navigation is best viewed, when set as:  so.addVariable('shownavigation','false');

FILE="nospaces.txt"
LINENUMBER=0
NUMLINES=`wc -l <$FILE`

printf '<?xml version="1.0" encoding="utf-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
	<trackList>
		' > playlist.xml

cat $FILE | while read PICPATH
do 
	printf '
	<track>
		<title>&nbsp;</title>
		<location>'$PICPATH'</location>
	</track>
	' >> playlist.xml
	LINENUMBER=$(($LINENUMBER + 1))
done

printf '
	</trackList>
</playlist>
' >> playlist.xml

