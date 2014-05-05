-- ------------------------------------------------------------------------
-- 作者：weilong.li
-- 邮箱：weilong.li@qunar.com
-- 日期：2012-10-29
-- ------------------------------------------------------------------------
-- 功能：酒店日志分析统计结果
-- 上游：无
-- ------------------------------------------------------------------------

drop table if exists qt_hotel_log_analyse_result;
create table qt_hotel_log_analyse_result
(
    city_code       string      comment '',
    query           string      comment '',
    type            tinyint     comment '',
    tag             string      comment '',
    hotel_seq       string      comment '',
    search_cnt      int         comment '',
    detail_cnt      int         comment ''
)
row format delimited fields terminated by '\001' lines terminated by '\n'
stored as textfile
location '/user/hotel/qtypeahead/qt_hotel_log_analyse_result';
