-- ------------------------------------------------------------------------
-- 作者：宋超
-- 邮箱：gavin.song@qunar.com
-- 日期：2012-08-06
-- ------------------------------------------------------------------------
-- 功能：酒店detail页点击日志
-- 上游：无
-- ------------------------------------------------------------------------

drop table twell_detail_click_log;
create external table twell_detail_click_log
(
    filterid        string      comment '',
    cityurl         string      comment '',
    fromDate        string      comment '',
    toDate          string      comment '',
    seq             string      comment '',
    requestor       string      comment '',
    qGlobal         string      comment '',
    qn1             string      comment '',
    timeStr         string      comment ''
)
partitioned by (dt string, ht string)
row format delimited fields terminated by '\001' lines terminated by '\n'
stored as textfile
location '/user/hotel/twell/detail_click';
