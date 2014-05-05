-- ------------------------------------------------------------------------
-- 作者：宋超
-- 邮箱：gavin.song@qunar.com
-- 日期：2012-08-07
-- ------------------------------------------------------------------------
-- 功能：酒店list页报价日志
-- 上游：无
-- ------------------------------------------------------------------------

drop table twell_list_price_log;
create external table twell_list_price_log
(
    qGlobal         string      comment '',
    fromDate        string      comment '',
    toDate          string      comment '',
    listToDate      string      comment '',
    listOnly        string      comment '',
    cityurl         string      comment '',
    filterid        string      comment '',
    qn1             string      comment '',
    timeStr         string      comment '',
    price           string      comment ''
)
partitioned by (dt string, ht string)
row format delimited fields terminated by '\001' lines terminated by '\n'
stored as textfile
location '/user/hotel/twell/list_price';
