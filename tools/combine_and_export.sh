#/bin/sh

set -e -x

BIN=$(readlink -f -- $(dirname -- "$0"))
cd $BIN

SQOOP="sudo -u hadoop_hotel JAVA_HOME=$JAVA_HOME HADOOP_HOME=$HADOOP_HOME SPATH=$PATH HIVE_HOME=$HIVE_HOME SQOOP_HOME=$SQOOP_HOME $SQOOP_HOME/bin/sqoop"
HSPG="env 'PGPASSWORD=pOn9o$0cGDOU_h5N%0jaEOKSKm2LynkP' /home/q/opt/pg90/bin/psql -Usearcher -dhs -p5435"
PYTHON="/home/q/python2.7.3/bin/python"

LOCK=/tmp/import-hotel-log.sh.lock

if [ -f $LOCK ]; then
    exit 0
fi

# 合并各条件执行该sql即可。
./sudo-hive.sh hive-sql/combine-all-tables.sql

# 导出
$HSPG -c "delete from qt_hotel_log_analyse_result_tmp;"
$HSPG -c "delete from qt_hotel_log_analyse_result_tmp_id;"
function export_hs_table {
    $SQOOP export --connect 'jdbc:postgresql://l-hsdb2.h.cn6.qunar.com:5435/hs?useUnicode=true;characterEncoding=utf8' --username searcher --password 'pOn9o$0cGDOU_h5N%0jaEOKSKm2LynkP' -m 2 --table qt_hotel_log_analyse_result_tmp --export-dir /user/hotel/qtypeahead/qt_hotel_log_analyse_result --input-fields-terminated-by '\0001'
}
export_hs_table

# 全量时做的处理，消重，拼音...
$HSPG -c "ALTER SEQUENCE qt_hotel_log_analyse_result_tmp_id_id_seq RESTART with 1;"
$HSPG -c "insert into qt_hotel_log_analyse_result_tmp_id(city_code, query, type, tag, hotel_seq, search_cnt, detail_cnt) select city_code, query, type, tag, case when hotel_seq is null then '' else hotel_seq end, search_cnt, detail_cnt from qt_hotel_log_analyse_result_tmp where city_code is not null and query is not null and tag is not null"
$HSPG -c "delete from qt_hotel_log_analyse_result_tmp_id where id in (select id from (select id, row_number() over (PARTITION BY trim(both E' \t\r\n' from city_code), trim(both E' \t\r\n' from query) order by type desc) as s from qt_hotel_log_analyse_result_tmp_id) as ss where s > 1)"

#check
NEW_LOG_LINES=`$HSPG -c "select count(*) from qt_hotel_log_analyse_result_tmp_id;" | grep -E '[1-9][0-9]+'`
echo $NEW_LOG_LINES
if [ $NEW_LOG_LINES -lt 3000000 ]; then
    echo "some thing wrong with qt_hotel_log_analyse_result_tmp_id. lines : $NEW_LOG_LINES"
    exit 1
fi
# 计算增量
$PYTHON ./cal_increment.py

# 高端酒店更新
./get_exhotel_data.sh

# qt_hotel_log_analyse_result done.
exit 0
