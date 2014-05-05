-- ------------------------------------------------------------------------
-- 作者：宋超
-- 邮箱：gavin.song@qunar.com
-- 日期：2012-08-07
-- ------------------------------------------------------------------------
-- 功能：酒店list页搜索日志
-- 上游：无
-- ------------------------------------------------------------------------

drop table hslist_list_condition_log;
create external table hslist_list_condition_log
(
    filterid                string      comment '',
    cityurl                 string      comment '',
    q                       string      comment '',
    fromDate                string      comment '',
    toDate                  string      comment '',
    prs                     string      comment '',
    levels                  string      comment '',
    hotelType               string      comment '',
    sortBy                  string      comment '',
    isDesc                  string      comment '',
    kdh                     string      comment '',
    tuan                    string      comment '',
    bounds                  string      comment '',
    pageLimit               string      comment '',
    showBrandInfo           string      comment '',
    showFullRoom            string      comment '',
    showGroupShop           string      comment '',
    showHotelTypeInfo       string      comment '',
    showLmMessage           string      comment '',
    showNonPrice            string      comment '',
    showNPDHotel            string      comment '',
    showPrices              string      comment '',
    showPromotion           string      comment '',
    showStatic              string      comment '',
    showTopHotel            string      comment '',
    showTradingInfo         string      comment '',
    qGlobal                 string      comment '',
    qn1                     string      comment '',
    timeStr                 string      comment '',
    pfs                     string      comment '',
    ids                     string      comment '',
    hotels                  string      comment '',
    requestTime             string      comment '',
    qptype                  string      comment '',
    host_no                 string      comment ''
)
partitioned by (dt string, ht string)
row format delimited fields terminated by '\001' lines terminated by '\n'
stored as textfile
location '/user/hotel/hslist/list_condition';
