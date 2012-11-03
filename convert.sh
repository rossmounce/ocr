#!/bin/bash
#ocrpdftotext
# Simplified implementation of http://ubuntuforums.org/showthread.php?t=880471

# Might consider doing something with getopts here, see http://wiki.bash-hackers.org/howto/getopts_tutorial

DPI=600
TESS_LANG=eng
#ces

FILENAME=${@%.pdf}
SCRIPT_NAME=`basename "$0" .sh`
TMP_DIR=${SCRIPT_NAME}-tmp
OUTPUT_FILENAME=${FILENAME}-output@DPI${DPI}
PAGES=$(pdfinfo ${FILENAME}.pdf | grep Pages: | awk '{print $2}')

mkdir ${TMP_DIR}
cp ${@} ${TMP_DIR}
cd ${TMP_DIR}

# convert -density ${DPI} -depth 8 ${@} "${FILENAME}.tif"
# tesseract "${FILENAME}.tif" "${OUTPUT_FILENAME}" -l ${TESS_LANG}

touch $OUTPUT_FILENAME
for i in `seq 1 $PAGES`; do
    convert -monochrome -density ${DPI} -depth 8 ${@}\[$(($i - 1 ))\] page$i.tif
    # tesseract page$i.tif -l ${TESS_LANG} >> $OUTPUT_FILENAME
    tesseract "page${i}.tif" "${OUTPUT_FILENAME}${i}" -l ${TESS_LANG}
    rm "page${i}.tif"
done

mv ${OUTPUT_FILENAME}*.txt ..
rm *
cd ..
rmdir ${TMP_DIR}
