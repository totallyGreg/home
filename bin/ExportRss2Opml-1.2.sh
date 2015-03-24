#!/bin/sh
# version 1.2
# 	* added the htmlURL field for Wordpress
#	* escaped XML special strings from the title field
# Written by Sameer D'Costa and released into the public domain
# http://dcostanet.net/wordpress/2005/06/13/export-safari-rss-feeds-via-opml/


cat << HEADER
<?xml version="1.0" encoding="UTF-8"?>
<opml version="1.0">
	<head>
		<title>Safari OPML Export</title>
	</head>
	<body>
		<outline text="Safari Feeds">
HEADER
sqlite3 ~/Library/Syndication/Database3 'select *  from Sources;' | \
	sed -e 's/&/\&amp\;/g'  -e 's/</\&lt\;/g' -e 's/>/\&gt\;/g' -e 's/"/\&quot\;/g' -e 's/\x2C/\&#39/g' | \
	awk -F"|" '{printf "<outline type=\"rss\" text=\"\" title=\"%s\" xmlUrl=\"%s\"\ />\
		", $4, $2   }'
cat << FOOTER
                </outline>
        </body>
</opml>
FOOTER
