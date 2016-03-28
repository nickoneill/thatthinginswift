#!/bin/sh

# generates preview images for specified code snippets

# step 1: get basic yaml parsing code from stackoverflow
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

CONTENT=./content/*.md
for f in $CONTENT
do
  previewCode=""
  eval $(parse_yaml $f)
  if [ "$previewCode" ]
    then
      echo "Processing $f $previewCode"
      if [ -f "./codePreviews/$previewCode.txt" ]
        then
          echo "Found preview code"
          # make highlighted html file from preview code at testcode.html
          python syntaxHighlight.py "$(cat ./codePreviews/$previewCode.txt)"
          # make an image file from html
          wkhtmltoimage --height 630 --width 1200 previewCode.html previewCode.png
          # make the composite final image
          composite -gravity SouthEast swift-small.png previewCode.png previewFinal.png
          # move final image to codePreviews with proper name
          mv previewFinal.png ./static/images/previews/$previewCode.png
          # cleanup intermediates
          rm previewCode.html previewCode.png
      fi
  fi
done
