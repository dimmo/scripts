#!/bin/bash
# Works with CYGWIN

REPO_PATH=`dirname $0`/../../..
if [ -z $2 ]
then
    SELF=`basename $0`
    echo "Usage: $SELF CHILD PARENT [--yt]"
    echo
    echo "   where CHILD/PARENT could be either tag ('releaseXXX') or branch name ('default')"
    echo "         --yt     - generate query for YouTrack"
    echo "   examples:"
    echo "      $SELF release173 release172"
    echo "      $SELF default release173"
    echo
    echo "Note: 'hg' binary should be available in PATH"
    echo
    echo "Latest tags: "`hg log -r "tagged()" --repository $REPO_PATH  | grep tag | tail -n5 | tac | sed -e "s/tag://"`
    exit 1
fi
RESULT=`hg log -r "ancestors($1) and not ancestors($2)" -v --repository $REPO_PATH | grep "C-" | iconv -f cp1251 -t utf-8 | sort | uniq`

if [ "$3" == "--yt" ]
then
    echo `echo "$RESULT" | grep -o 'C-....' | sed -e 's/C-/#C-/' | sort | uniq`
else
    echo "$RESULT"
fi
