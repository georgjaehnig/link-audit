if [ $# -lt 1 ]; then
  echo $0 url
  exit 1
fi

rm -r /tmp/link-audit 2> /dev/null

LINKAUDIT_DIR=/tmp/link-audit
mkdir -p $LINKAUDIT_DIR

cd $LINKAUDIT_DIR
wget -r -l1 --span-hosts -e robots=off --no-check-certificate "$1" 2> $LINKAUDIT_DIR/log.txt

grep --before-context=3 -E '(response... (4|5)|unable to resolve|no certificate)' $LINKAUDIT_DIR/log.txt

cd - > /dev/null
