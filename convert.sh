#!/bin/bash
#ocrpdftotext
# Simplified implementation of http://ubuntuforums.org/showthread.php?t=880471

# Might consider doing something with getopts here, see http://wiki.bash-hackers.org/howto/getopts_tutorial

DPI=600
TESS_LANG=ces
#ces
#eng

FILENAME=${@%.pdf}
SCRIPT_NAME=`basename "$0" .sh`
TMP_DIR=${FILENAME}-tmp
OUTPUT_FILENAME=${FILENAME}
PAGES=$(pdfinfo ${FILENAME}.pdf | grep Pages: | awk '{print $2}')

mkdir ${TMP_DIR}
cp ${@} ${TMP_DIR}
cd ${TMP_DIR}

for i in `seq 1 $PAGES`; do
    convert -monochrome -density ${DPI} -depth 8 ${@}\[$(($i - 1 ))\] page$i.tif
    tesseract "page${i}.tif" "${OUTPUT_FILENAME}-${i}" -l ${TESS_LANG}
    rm "page${i}.tif"
    mv ${OUTPUT_FILENAME}-${i}.txt ..
done

rm *
cd ..
rmdir ${TMP_DIR}
