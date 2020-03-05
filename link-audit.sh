#!/bin/bash
if [ $# -lt 1 ]; then
  echo 'Usage:'
  echo $0 url
  exit 1
fi

if [[ -z ${LINKAUDIT_RECIPIENT} ]];
then
  echo '$LINKAUDIT_RECIPIENT is not set.'
  echo 'You can set it with:'
  echo 'export LINKAUDIT_RECIPIENT=foo@example.com'
fi

rm -r /tmp/link-audit 2> /dev/null
 
LINKAUDIT_DIR=/tmp/link-audit
mkdir -p $LINKAUDIT_DIR

wget \
  -r \
  -l2 \
  -e robots=off \
  --no-check-certificate \
  --directory-prefix=$LINKAUDIT_DIR \
  "$1" 2> $LINKAUDIT_DIR/log.txt

{ \
  echo "Subject: Link Audit of $1"; \
  grep \
    --before-context=3 \
    -E '(response... (4|5)|unable to resolve|no certificate)' \
    $LINKAUDIT_DIR/log.txt ; \
} | /usr/sbin/sendmail $LINKAUDIT_RECIPIENT
