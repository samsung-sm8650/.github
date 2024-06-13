#!/bin/bash
# This script extracts the MD5 sum of an Odin-compatible .tar.md5 file and compares the sum with the MD5 of the actual data

# Check if file name ends with .tar.md5
(echo $1 | grep -q '.tar.md5\>') || (echo "No .tar.md5 file found" && exit)

# Check if file name of the tar archive is appended to the .tar.md5 file
SIZE=$(wc -c < $1)
(dd if=$1 bs=1 skip=$(($SIZE - 5)) status=none | grep -q ".tar") || (echo "No checksum found" && exit)

echo "Calculating MD5 sums for $1..."

# Get size of appended "md5sum" footer. Won't work if there are two spaces in the file name!
COUNTER=0
while (echo "$DATA" | grep -vq "  "); do
	((COUNTER++))
	SKIP=$(($SIZE - $COUNTER))
	DATA=$(dd if=$1 bs=1 skip=$SKIP status=none)
done

# Calcualte MD5 sums
FOOTERSIZE=$(($COUNTER + 32))
TARSIZE=$(($SIZE - $FOOTERSIZE))
MD5FOOTER=$(dd if=$1 skip=$TARSIZE bs=1 count=32 status=none)
MD5=$(head -c $TARSIZE < $1 | md5sum | cut -c-32)

echo "The MD5 should be: $MD5FOOTER"
echo "The MD5 is:        $MD5"

[[ $MD5FOOTER = $MD5 ]] && echo "MD5 sums match!" || echo -e "\033[0;31mERROR:\033[0m Checksums do not match"
