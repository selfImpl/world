#/bin/sh

set -e -x

BIN=$(readlink -f -- $(dirname -- "$0"))
cd $BIN
source /home/weilong.li/.bashrc

LOCK_FILE=/tmp/refresh_qtypeahead.lock
HADOOP_FILE=/tmp/run-import-hotel-log.sh.lock
MAIL_FILE=/tmp/refresh_qtypeahead_mail.txt
function send_mail {
    STATUS=$1

    cat $MAIL_FILE | env CC="weilong.li@qunar.com,han.lin@qunar.com,qian.liu@qunar.com" \
    TITLE="[$STATUS]Hotel QTypeahead Data Refresh Report" ./mtext.sh | msmtp -t
}

if [ -f "$LOCK_FILE" ]; then
    echo "lock by another refresh qtypeahead script" >> $MAIL_FILE
    send_mail ERROR;
    exit 1
fi
if [ -f "$HADOOP_FILE" ]; then
    echo "hadoop work is doing. run this next time. " >> $MAIL_FILE
    send_mail OK;
    exit 0
fi
touch $LOCK_FILE

echo > $MAIL_FILE

OK="0"

# 导入qhotel，hs的数据做数据源
./import-db-data.sh >> $MAIL_FILE 2>&1
if [ $? != "0" ]; then
    OK="1"
fi

# 合并导出到数据库
./combine_and_export.sh >> $MAIL_FILE 2>&1
if [ $? != "0" ]; then
    OK="1"
fi

if [ $OK != "0" ]; then
    send_mail ERROR;
else
    send_mail OK;
fi

rm -f $LOCK_FILE
sudo -u hadoop_hotel rm -rf /tmp/hadoop_hotel/*
