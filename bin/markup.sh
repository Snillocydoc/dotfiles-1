#!/bin/sh
if [ -h $0 ]; then
    SLINK=`ls -l $0 | awk '{print $11}'`;
    DIR=`dirname $SLINK`
else
    DIR=`dirname $0`
fi
#python "$DIR/../mkdn/markuptools.py" "$@"
python "$HOME/Dropbox/workspace/python/markdown/mkdn/markuptools.py" "$@"
