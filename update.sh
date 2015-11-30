#!/bin/sh

# generate blog with theme
hugo --theme=herring-cove-swift

# send everything in public to the root of blog
# a: archive mode
#		r: recursive
#		l: keep symlinks
#		p: keep perms
#		t: keep time
#		g: keep groups
#		o: keep owner
#		D: keep devices, specials
# v: verbose
# z: compress
rsync -avz public/* 212.47.240.254:/srv/www/thatthinginswift.com/public_html/
