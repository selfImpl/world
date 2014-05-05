-- ------------------------------------------------------------------------
-- 作者：宋超
-- 邮箱：gavin.song@qunar.com
-- 日期：2012-08-06
-- ------------------------------------------------------------------------
-- 功能："预订"点击日志
-- 上游：无
-- ------------------------------------------------------------------------

drop table booking_book_click_log;
create external table booking_book_click_log
(
    filterid        string      comment '',
    requestID       string      comment '',
    bid             string      comment '',
    tid             string      comment '',
    cityurl         string      comment '',
    fromDate        string      comment '',
    toDate          string      comment '',
    retailPrice     string      comment '',
    detailType      string      comment '',
    roomId          string      comment '',
    isFull          string      comment '',
    stat            string      comment '',
    source          string      comment '',
    lpsp            string      comment '',
    cpcRoomType     string      comment '',
    localCode       string      comment '',
    codeBase        string      comment '',
    seq             string      comment '',
    qGlobal         string      comment '',
    timeStr         string      comment ''
)
partitioned by (dt string, ht string)
row format delimited fields terminated by '\001' lines terminated by '\n'
stored as textfile
location '/user/hotel/booking/book_click';

