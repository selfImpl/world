#!/bin/bash

# use sys-wide config file to handle config file owner problems

# Usage: echo '中文' |env TO="angela.li@qunar.com" CC="yi.luo@qunar.com,xiaoyi.wang@qunar.com" ./mtext.sh |msmtp -t

TO=${TO:-"xunxin.wan@qunar.com"}
CC=${CC:-"xunxin.wan@qunar.com"}
BCC=${BCC:-"xunxin.wan@qunar.com"}
FROM=${FROM:-"qsearch@qunar.com"}
DATE=${DATE:-$(date -R)}
CTYPE=${CTYPE:-"text/plain; charset=\"gbk\""}
TITLE=${TITLE:-"Title"}
LINE="\r\n"

echo -ne "To: $TO\r\n"
echo -ne "CC: $CC\r\n"
echo -ne "From: $FROM\r\n"
echo -ne "Date: $DATE\r\n"
echo -ne "Content-Type: $CTYPE\r\n"
echo -ne "Content-Transfer-Encoding: 8bit\r\n"
echo -ne "MIME-Version: 1.0\r\n"
echo -ne "Subject: $TITLE\r\n"
echo -ne "\r\n\r\n"

# windows can only see gbk mail
iconv -c -f utf8 -t gbk |tee /dev/null

