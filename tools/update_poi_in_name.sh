#/bin/sh

set -x

BIN=$(readlink -f -- $(dirname -- "$0"))
cd $BIN

PY=/home/q/python2.7.3/bin/python
log=/tmp/update_poi_in_name.log

ret="OK"
ret_code=10000

$PY $BIN/update_poi_in_name.py > $log 2>&1
if [ $? != "0" ]; then
    ret="ERROR"
    ret_code=0
fi

dt=`date +"%F %T"`
subject="[$ret] find poi in name result [$dt]"

mail -s "$subject" gavin.song@qunar.com weilong.li@qunar.com < $log

CACTI_URL='http://l-hotelcacti.h.cn6.qunar.com:8080/qmonitor_push.jsp'
GROUP='QHOTEL_SCRIPT'
MONITOR_NAME='QTYPEAHEAD_FIND_POI_IN_NAME'
curl -s --connect-timeout 10 -m 20 "$CACTI_URL?groupName=$GROUP&op=push&name=$MONITOR_NAME&value=$ret_code"