#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "  $0 'single line'"
    echo "  $0 'first line' 'second line'"
    exit 1
fi

DRY=0
if [ "$1" == "-n" ]; then
    DRY=1
    shift
fi

if [ $# -gt 2 ]; then
    echo "Too many lines."
    exit 1
fi

if [ $# -eq 1 ]; then
    echo '"'"$1"'"' > /tmp/glabel.txt
    if [ $DRY -eq 0 ]; then
        echo '"'"$1"'"' >> $(dirname $0)/log.txt
    fi
    if [ ${#1} -gt 11 ]; then
        TEMPLATE="dymo-oneline-small.glabels"
    else
        TEMPLATE="dymo-oneline.glabels"
    fi
fi

if [ $# -eq 2 ]; then
    echo '"'"$1"'","'"$2"'"' > /tmp/glabel.txt
    if [ $DRY -eq 0 ]; then
        echo '"'"$1"'" "'"$2"'"' >> $(dirname $0)/log.txt
    fi
    TEMPLATE="dymo-twoline.glabels"
fi

glabels-3-batch -o /tmp/glabel.pdf -i /tmp/glabel.txt $(dirname $0)/$TEMPLATE

if [ $DRY -eq 1 ]; then
    evince /tmp/glabel.pdf
else
    lp -d LabelWriter-450-2 -o media=w54h144 /tmp/glabel.pdf
fi
