# make comments available in zsh:
#setopt interactivecomments

#cd CEN_XFS_PDF
#mkdir CEN_XFS_PDF_HEADER_ONLY
find ./CEN_XFS_PDF -type f -name "*.pdf" -print0 | while IFS= read -r -d '' file; do
    i=$(pdftotext "$file" - | grep -F -o -e $'\f' -e '#ifdef __cplusplus' | awk 'BEGIN{page=1} /\f/{++page;next} {print page; exit 0}')
    file_name=$(basename "$file")
    echo "In '$file_name' headers located at page $i"
    #pdftk "$file" cat $i-end output "./CEN_XFS_PDF_HEADER_ONLY/$file_name"
done
#cd ..

