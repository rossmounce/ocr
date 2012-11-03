#!/bin/sh

pdfinfo dokument2.pdf | grep Pages: | awk '{print $2}'

PAGES=100 # set to the number of pages in the PDF
SOURCE=book.pdf # set to the file name of the PDF
OUTPUT=book.txt # set to the final output file
RESOLUTION=600 # set to the resolution the scanner used (the higher, the better)

touch $OUTPUT
for i in `seq 1 $PAGES`; do
    convert -monochrome -density $RESOLUTION $SOURCE\[$(($i - 1 ))\] page$i.tif
    tesseract page$i.tif >> $OUTPUT
done
