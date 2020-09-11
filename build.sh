#!/bin/bash -e

DIR="./fonts"
DIR_ORIGIN="${DIR}/original"
DIR_SUBSET="${DIR}/subset"

for filepath in "${DIR_ORIGIN}"/*; do
  filename="$(basename "${filepath}")"
  filename="${filename//-*[0-9]/}"

  for ext in ttf woff woff2; do
    output="${DIR_SUBSET}/${filename/ttf/$ext}"
    glyphs="${DIR_SUBSET}/glyphs.txt"
    args=" ${filepath} --output-file=${output} --text-file=${glyphs} \
      --layout-features='*' --glyph-names --symbol-cmap --legacy-cmap \
      --notdef-glyph --notdef-outline --recommended-glyphs \
      --name-IDs='*' --name-legacy --name-languages='*' \
      --drop-tables="

    case "${ext}" in
      woff)
        args+=" --with-zopfli"
        ;&
      woff2)
        args+=" --flavor=${ext}"
        ;&
      *) ;;
    esac

    pyftsubset ${args}
  done
done
