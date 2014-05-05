-- ------------------------------------------------------------------------
-- 作者：weilong.li
-- 邮箱：weilong.li@qunar.com
-- 日期：2012-10-29
-- ------------------------------------------------------------------------
-- 功能：根据log统计每个城市每个query的search量和detail量
-- 上游：无
-- ------------------------------------------------------------------------

drop table if exists qt_city_query_analyse;
create table qt_city_query_analyse
(
    city_code       string      comment '',
    query           string      comment '',
    totalsearch     int         comment '',
    detail_hit      int         comment ''
)
row format delimited fields terminated by '\001' lines terminated by '\n'
stored as textfile
location '/user/hotel/qtypeahead/qt_city_query_analyse';
