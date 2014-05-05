#bin/sh

set -x -e

LOCK_FILE='/tmp/import-db-data.sh.lock'

BIN=$(readlink -f -- $(dirname -- "$0"))
cd $BIN

if [ -f $LOCK_FILE ]; then
    echo "another instance running."
    exit 0
fi
touch $LOCK_FILE

SQOOP="sudo -u hadoop_hotel JAVA_HOME=$JAVA_HOME HADOOP_HOME=$HADOOP_HOME SPATH=$PATH HIVE_HOME=$HIVE_HOME SQOOP_HOME=$SQOOP_HOME $SQOOP_HOME/bin/sqoop"

function drop_old_tables {
    ./sudo-hive.sh hive-sql/drop-tables.sql
}

function import_qhotel_table {
    $SQOOP import --connect 'jdbc:postgresql://l-pgdb1.h.cn6.qunar.com:5432/hotel?useUnicode=true;characterEncoding=utf8' --username qhotel --password 'f758a694-a83f-4d7f-8c1a-8c4487e7e682' -m 1 --target-dir /user/hotel/qtypeahead/$2 --hive-import --query "$1" --hive-table $2
}

function import_hs_table {
    $SQOOP import --connect 'jdbc:postgresql://l-hsdb2.h.cn6.qunar.com:5435/hs?useUnicode=true;characterEncoding=utf8' --username searcher --password 'pOn9o$0cGDOU_h5N%0jaEOKSKm2LynkP' -m 1 --target-dir /user/hotel/qtypeahead/$2 --hive-import --query "$1" --hive-table $2
}

drop_old_tables

#city_city
import_qhotel_table "select distinct citycode, name from city_city where isdeleted = 0 and \$CONDITIONS" qt_city_city
#linkage
import_qhotel_table "select distinct city, hotel_name as name, hotel_seq from hotel_linkage_publish where hotel_seq is not null and hotel_seq != '' and status = 'on' and \$CONDITIONS" qt_linkage_names
#poi
import_qhotel_table "select distinct city_code, name from poi where status != 'del' and name is not null and name != '' and \$CONDITIONS" qt_poi
#brand
import_qhotel_table "select distinct a.city_code, b.name from hotel_info_publish a join hotel_brand b on a.brand = b.brand_code where a.operating_status != 4 and a.brand is not null and a.brand != '' and \$CONDITIONS" qt_hotel_brand
#集团
import_qhotel_table "select distinct c.city_code, d.name from (select distinct a.city_code, b.name, b.group_id from hotel_info_publish a join hotel_brand b on a.brand = b.brand_code where a.operating_status != 4 and a.brand is not null and a.brand != '') c join brand_group d on c.group_id = d.id where \$CONDITIONS" qt_hotel_group
#grade
import_qhotel_table "select distinct city_code, case when grade = 1 then unnest(ARRAY['经济型', '经济实惠', '低端', '价格低', '实惠']) when grade = 2 then unnest(ARRAY['三星及其他', '价位居中', '三星级', '3星级', '舒适', '舒适型']) when grade = 3 then unnest(ARRAY['四星级', '4星级', '四星及高档', '中档', '中端',  '四星级高档', '四星级或是高档',   '高档', '高档型']) when grade = 4 then unnest(ARRAY['五星级','5星级', '五星及豪华', '高价位', '高价格', '五星级或是豪华', '高端', '豪华型', '豪华']) end as name from hotel_info_publish where operating_status != 4 and grade is not null and grade != 5 and \$CONDITIONS" qt_hotel_grade
#trading_area
import_qhotel_table "select city_code, unnest(trading_areas) as name from hotel_info_publish where operating_status != 4 and trading_areas is not null and trading_areas::text != '{}' and \$CONDITIONS" qt_trading_area
#themes
import_qhotel_table "select city_code, case when theme = 'BUSINESS_HOTEL' then '商务型酒店' when theme = 'ECOMOMIC_HOTEL' then unnest(ARRAY['青年旅社', '青年旅舍']) when theme = 'EXPO_HOTEL' then '会展会务酒店' when theme = 'RESORT_HOTEL' then '度假休闲酒店' when theme = 'FAMILY_HOTEL' then '家庭旅馆' when theme = 'RENTAL_HOTEL' then '酒店式公寓' when theme = 'SUBJECT_HOTEL' then '主题酒店' when theme = 'GUZHEN_HOTEL' then '客栈' when theme = 'VILLAGE_HOTEL' then '乡村别墅' when theme = 'GUEST_HOTEL' then '招待所' when theme = 'BEST_HOTEL' then unnest(ARRAY['顶级奢华','顶级奢华酒店']) when theme = 'CHAIN_HOTEL' then '连锁品牌' when theme = 'EXCELLENT_HOTEL' then '精品酒店' end as name from (select city_code, unnest(types) as theme from hotel_info_publish where operating_status != 4 and types is not null) x where theme is not null and theme != '' and \$CONDITIONS" qt_themes

#黑名单
import_hs_table "select city_code, name, status from (select '' as city_code, name, status from hs_sensitive_word where status = 0 and (position('all' in tags)!=0 or position('suggest' in tags)!=0) union select city_code, name, status from hs_hotel_suggest_blacks where status = 0) tmp where \$CONDITIONS" qt_black_words

#tag(公务员)
import_hs_table "select city_code, suggest as name, tag, search_cnt, detail_cnt from hs_hotel_suggest_with_tag where status = 0 and \$CONDITIONS" qt_man_made_suggest

#fangxing
import_hs_table "select distinct b.city_code, unnest(a.types) as name from hs_hotel_room_types a join hs_city b on regexp_replace(a.hotel_seq, '_[0-9]+', '') = b.city_code where \$CONDITIONS" qt_hotel_room_types

#subway
import_qhotel_table "select b.city_code, a.line_name as name from area_line a join poi b on a.poi_id = b.id where \$CONDITIONS" qt_subway

rm $LOCK_FILE
exit 0
