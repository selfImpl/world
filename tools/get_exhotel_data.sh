#!/bin/sh

HSPG="env PGPASSWORD=pOn9o$0cGDOU_h5N%0jaEOKSKm2LynkP /home/q/opt/pg90/bin/psql -Usearcher -dhs -p5435"
QHOTELPG="env PGPASSWORD=f758a694-a83f-4d7f-8c1a-8c4487e7e682 /home/q/opt/pg90/bin/psql -hl-pgdb1.h.cn6.qunar.com -Uqhotel -dhotel -p5432"

# 先清除老的数据
$HSPG -c "delete from qt_exhotel_words;"

# 高端酒店名
$QHOTELPG -c "copy (select distinct city_code, name from hotel_info_publish where star = 5 or grade = 4 or types @> ARRAY['EXCELLENT_HOTEL']::character varying(30)[]) to stdout;" | $HSPG -c "copy qt_exhotel_words(city_code, name) from stdin;"
echo "copy 高端酒店名 done."

# 高端集团
$QHOTELPG -c "copy (select distinct c.city_code, d.name from (select distinct a.city_code, b.name, b.group_id from hotel_info_publish a join hotel_brand b on a.brand = b.brand_code where a.operating_status != 4 and a.brand is not null and a.brand != '' and (a.star = 5 or a.grade = 4 or a.types @> ARRAY['EXCELLENT_HOTEL']::character varying(30)[])) c join brand_group d on c.group_id = d.id) to stdout" | $HSPG -c "copy qt_exhotel_words(city_code, name) from stdin;"
echo "copy 高端集团 done."

# 高端品牌
$QHOTELPG -c "copy (select distinct a.city_code, b.name from hotel_info_publish a join hotel_brand b on a.brand = b.brand_code where a.operating_status != 4 and a.brand is not null and a.brand != '' and (a.star = 5 or a.grade = 4 or a.types @> ARRAY['EXCELLENT_HOTEL']::character varying(30)[])) to stdout" | $HSPG -c "copy qt_exhotel_words(city_code, name) from stdin;"
echo "copy 高端品牌 done."

# 高端区域
$QHOTELPG -c "copy (select city_code, area from hotel_info_publish where operating_status != 4 and area is not null and area != '' and (star = 5 or grade = 4 or types @> ARRAY['EXCELLENT_HOTEL']::character varying(30)[])) to stdout;" | $HSPG -c "copy qt_exhotel_words(city_code, name) from stdin;"
echo "copy 高端区域 done."

# 高端商圈
$QHOTELPG -c "copy (select city_code, unnest(trading_areas) as name from hotel_info_publish where operating_status != 4 and trading_areas is not null and trading_areas::text != '{}' and (star = 5 or grade = 4 or types @> ARRAY['EXCELLENT_HOTEL']::character varying(30)[])) to stdout;" | $HSPG -c "copy qt_exhotel_words(city_code, name) from stdin;"
echo "copy 高端商圈 done."

# 拿热门poi
$QHOTELPG -c "delete from poi_hot;"
$HSPG -c "copy (select distinct city_code, query from qt_hotel_log_analyse_result where search_cnt > 1 and type = 1 and status = 0) to stdout" | $QHOTELPG -c "copy poi_hot(city_code, name) from stdin;"
echo "copy 热门 poi done."

# 拿热门poi坐标
$QHOTELPG -c "UPDATE poi_hot a set gpoint = x.gpoint from poi x left join poi_hot y on x.city_code = y.city_code and x.name = y.name where y.status is not null and x.status != 'del' and x.gpoint is not null and a.city_code = x.city_code and a.name = x.name;"

# 高端热门poi
$QHOTELPG -c "copy (select distinct b.city_code, b.name from hotel_info_publish a right join poi_hot b on ST_DWithin(st_geographyfromtext('POINT(' || split_part(google_point, ',', 2) || ' ' || split_part(google_point, ',', 1) || ')'), b.gpoint, 5000) where a.operating_status != 4 and (a.star = 5 or a.grade = 4 or a.types @> ARRAY['EXCELLENT_HOTEL']::character varying(30)[])) to stdout;" | $HSPG -c "copy qt_exhotel_words(city_code, name) from stdin;"
echo "copy poi done."

# test数量
exhotel_cnt=`$HSPG -c "copy (select count(*) from qt_exhotel_words) to stdout"`
echo $exhotel_cnt
if [ $exhotel_cnt -lt 30000 ]; then
    echo "test error."
    exit 1
fi

$HSPG -c "UPDATE qt_hotel_log_analyse_result x set app = a.app - 'exhotel'::text, last_mod = now() from qt_hotel_log_analyse_result a left join qt_exhotel_words b on a.city_code = b.city_code and a.query = b.name where a.app ? 'exhotel'::text and b.status is null and x.city_code = a.city_code and x.query = a.query;"

$HSPG -c "UPDATE qt_hotel_log_analyse_result x set app = a.app || 'exhotel=>1'::hstore, last_mod = now() from qt_hotel_log_analyse_result a left join qt_exhotel_words b on a.city_code = b.city_code and a.query = b.name where not a.app ? 'exhotel'::text and b.status is not null and x.city_code = a.city_code and x.query = a.query;"

#$HSPG -c "UPDATE qt_hotel_log_analyse_result x set app = a.app - 'exhotel'::text from qt_hotel_log_analyse_result a left join qt_exhotel_words b on a.city_code = b.city_code and a.query = b.name where a.app ? 'exhotel'::text and b.status is null and x.city_code = a.city_code and x.query = a.query;"

#$HSPG -c "UPDATE qt_hotel_log_analyse_result x set app = a.app || 'exhotel=>1'::hstore from qt_hotel_log_analyse_result a left join qt_exhotel_words b on a.city_code = b.city_code and a.query = b.name where not a.app ? 'exhotel'::text and b.status is not null and x.city_code = a.city_code and x.query = a.query;"

