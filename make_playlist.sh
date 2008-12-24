#!/bin/bash

FILENUMBER=0

printf '<?xml version="1.0" encoding="utf-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
	<trackList>
		' > playlist.xml
for PIC in `ls | grep -i .jpg`; do
		printf '
		<track>
			<title>&nbsp;</title>
			<location>./'$PIC'</location>
		</track>
		' >> playlist.xml
        num=$(($FILENUMBER + 1))
done
printf '
	</trackList>
</playlist>
' >> playlist.xml

