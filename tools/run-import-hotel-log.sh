#/bin/sh

set -e -x

BIN=$(readlink -f -- $(dirname -- "$0"))
cd $BIN
source /home/weilong.li/.bashrc

LOCK_FILE=/tmp/run-import-hotel-log.sh.lock
TYPEAHEAD_FILE=/tmp/refresh_qtypeahead.lock
MAIL_FILE=/tmp/refresh_hotel_log_mail.txt
function send_mail {
    STATUS=$1

    cat $MAIL_FILE | env CC="weilong.li@qunar.com,han.lin@qunar.com,qian.liu@qunar.com" \
    TITLE="[$STATUS]Hotel Hadoop Hotel-Log Refresh Report" ./mtext.sh | msmtp -t
}

if [ -f "$LOCK_FILE" ]; then
    echo "lock by another refresh hotel-log script" >> $MAIL_FILE
    send_mail ERROR;
    exit 1
fi
if [ -f "$TYPEAHEAD_FILE" ]; then
    echo "refresh qtypeahead work is doing. run this next time. " >> $MAIL_FILE
    send_mail OK;
    exit 0
fi
touch $LOCK_FILE

echo > $MAIL_FILE

OK="0"

# 计算hotel-log 
./import-hotel-log.sh >> $MAIL_FILE 2>&1
if [ $? != "0" ]; then
    OK="1"
fi

if [ $OK != "0" ]; then
    send_mail ERROR;
else
    send_mail OK;
fi

rm -f $LOCK_FILE
