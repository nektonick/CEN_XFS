# make comments available in zsh:
#setopt interactivecomments


if [ ! -d "./CEN_XFS_PDF_HEADER_ONLY" ] 
then
    echo "Going to create directory for modified pdf files"
    mkdir "CEN_XFS_PDF_HEADER_ONLY"
else
    echo "Going to delete old files"
    rm ./CEN_XFS_PDF_HEADER_ONLY/*
fi

if [ ! -d "./CEN_XFS_HEADERS" ] 
then
    echo "Going to create directory for headers"
    mkdir "CEN_XFS_HEADERS"
else
    echo "Going to delete old files"
    rm ./CEN_XFS_HEADERS/*
fi

find ./CEN_XFS_PDF -type f -name "*.pdf" -print0 | while IFS= read -r -d '' file; do
    file_name=$(basename "$file")
    echo "Looking for page with headers in file '$file_name'"
    i=$(pdftotext "$file" - | grep -F -o -e $'\f' -e '#ifdef __cplusplus' | awk 'BEGIN{page=1} /\f/{++page;next} {print page; exit 0}')

    if [ ! -z "$i" ] 
    then
        echo "Headers located at page $i"

        echo "Generating pdf with headers only" # TODO: make configurable
        pdftk "$file" cat $i-end output "./CEN_XFS_PDF_HEADER_ONLY/$file_name"

        echo "Generation raw header file"
        pdftotext -layout -f $i -l -1 "$file" "./CEN_XFS_HEADERS/$(basename "$file" .pdf).h"
        echo ""

    else
        echo "Headers not found. Going to skip this file"
        echo ""
    fi
done
