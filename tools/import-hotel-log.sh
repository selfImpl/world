#bin/sh

set -x

BIN=$(readlink -f -- $(dirname -- "$0"))
cd $BIN

MY_LOCK_FILE='/tmp/import-hotel-log.sh.lock'
DB_LOCK_FILE='/tmp/refresh_qtypeahead.lock'
HIVE_CMD_FILE='/tmp/import-hotel-log-hive.sql'
LAST_UPDATE='/tmp/import-hotel-log.last'

if [ -f $MY_LOCK_FILE ]; then
    echo 'already running an instance.'
    exit 0
fi
if [ -f $DB_LOCK_FILE ]; then
    echo 'db refresh is running.'
    exit 0
fi

touch $MY_LOCK_FILE

function ensure_log_in_days {
    echo "ensure_log_in_days"
    dt=`date -d "$1 days ago" +%Y-%m-%d`
    ht=`date -d "$1 days ago" +%H`
    key="$dt/$ht"
    if [ -f $LAST_UPDATE ]; then
        key=`cat $LAST_UPDATE`
    fi
    echo "until date : $key"
    hours=`expr $1 \* 24`
    echo "total hours : $hours"
    for i in `seq $hours`; do
        i=`expr $i - 1`
        ndt=`date -d "$i hours ago" +%Y-%m-%d`
        nht=`date -d "$i hours ago" +%H`
        if [ "$key" = "$ndt/$nht" ]; then
            break
        fi
        echo "alter table hslist_list_condition_log add partition (dt='$ndt', ht='$nht') location '/user/hotel/hslist/list_condition/$ndt/$nht';" >> $HIVE_CMD_FILE
        echo "alter table twell_detail_click_log add partition (dt='$ndt', ht='$nht') location '/user/hotel/twell/detail_click/$ndt/$nht';" >> $HIVE_CMD_FILE
    done
    cdt=`date +%Y-%m-%d`
    cht=`date +%H`
    ckey="$cdt/$cht"
    echo "current : $ckey"
    echo "$ckey" > $LAST_UPDATE
}

function generate_analyse_cmd {
    #统计一个月内log中每个城市每个query到detail页的次数
    dt=`date -d "$1 days ago" +%Y-%m-%d`
    ht=`date -d "$1 days ago" +%H`
    echo "insert overwrite table qt_city_query_analyse" >> $HIVE_CMD_FILE
    echo "select distinct e.city_code, e.query, e.search, e.count from (" >> $HIVE_CMD_FILE
    echo "select distinct c.city_code, c.query, d.search, c.count from (" >> $HIVE_CMD_FILE
    echo "    select a.cityurl as city_code, a.q as query, count(1) as count from" >> $HIVE_CMD_FILE
    echo "    ( " >> $HIVE_CMD_FILE
    echo "       select distinct filterid, cityurl, q from hslist_list_condition_log" >> $HIVE_CMD_FILE
    echo "        where filterid is not null and filterid != '' and q is not null and q != '' and (dt > '$dt' or (dt = '$dt' and ht >= '$ht'))" >> $HIVE_CMD_FILE
    echo "    ) a" >> $HIVE_CMD_FILE
    echo "    join" >> $HIVE_CMD_FILE
    echo "    (" >> $HIVE_CMD_FILE
    echo "        select filterid from twell_detail_click_log" >> $HIVE_CMD_FILE
    echo "        where filterid is not null and filterid != '' and (dt > '$dt' or (dt = '$dt' and ht >= '$ht'))" >> $HIVE_CMD_FILE
    echo "    ) b" >> $HIVE_CMD_FILE
    echo "    on" >> $HIVE_CMD_FILE
    echo "        a.filterid = b.filterid" >> $HIVE_CMD_FILE
    echo "    group by" >> $HIVE_CMD_FILE
    echo "        a.cityurl, a.q" >> $HIVE_CMD_FILE
    echo ") c" >> $HIVE_CMD_FILE
    echo "join" >> $HIVE_CMD_FILE
    echo "    ( " >> $HIVE_CMD_FILE
    echo "       select cityurl, q, count(1) as search from hslist_list_condition_log" >> $HIVE_CMD_FILE
    echo "        where filterid is not null and filterid != '' and q is not null and q != '' and (dt > '$dt' or (dt = '$dt' and ht >= '$ht'))" >> $HIVE_CMD_FILE
    echo "       group by" >> $HIVE_CMD_FILE
    echo "           cityurl, q" >> $HIVE_CMD_FILE
    echo "    ) d" >> $HIVE_CMD_FILE
    echo "on" >> $HIVE_CMD_FILE
    echo "    c.city_code = d.cityurl and c.query = d.q" >> $HIVE_CMD_FILE
    echo ") e;" >> $HIVE_CMD_FILE
    #echo "left outer join" >> $HIVE_CMD_FILE
    #echo "    qt_black_words f" >> $HIVE_CMD_FILE
    #echo "on" >> $HIVE_CMD_FILE
    #echo "    e.city_code = f.city_code and e.query = f.name" >> $HIVE_CMD_FILE
    #echo "where" >> $HIVE_CMD_FILE
    #echo "    f.status is null;" >> $HIVE_CMD_FILE
}

# empty it
echo "" > $HIVE_CMD_FILE
# generate hive sql
ensure_log_in_days 30
generate_analyse_cmd 30

# run it
./sudo-hive.sh $HIVE_CMD_FILE

rm $MY_LOCK_FILE
exit 0
