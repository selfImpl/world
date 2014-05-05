
insert overwrite table qt_hotel_log_analyse_result
select tmp.city_code, tmp.name, tmp.type, tmp.tag, tmp.seq, tmp.search_cnt, tmp.hit from (
    -- qt_city_city
--    select distinct citycode city_code, name, 100 type, '' tag, 'null' seq, 0 hit from
--        qt_city_city
--    union all
    -- hotel log
    select distinct city_code, query name, 0 type, '' tag, 'null' seq, totalsearch search_cnt, detail_hit hit from
        qt_city_query_analyse
    union all
    -- qt_poi
    select distinct a.city_code city_code, a.name name, 1 type, '' tag, 'null' seq, case when b.totalsearch is null then 0 else b.totalsearch end search_cnt, case when b.detail_hit is null then 0 else b.detail_hit end hit from
        qt_poi a
    left outer join
        qt_city_query_analyse b
    on
        a.city_code = b.city_code and a.name = b.query
    union all
    -- qt_subway
    select distinct a.city_code city_code, a.name name, 2 type, '' tag, 'null' seq, case when b.totalsearch is null then 0 else b.totalsearch end search_cnt, case when b.detail_hit is null then 0 else b.detail_hit end hit from
        qt_subway a
    left outer join
        qt_city_query_analyse b
    on
        a.city_code = b.city_code and a.name = b.query
    union all
    -- qt_trading_area
    select distinct a.city_code city_code, a.name name, 3 type, '' tag, 'null' seq, case when b.totalsearch is null then 0 else b.totalsearch end search_cnt, case when b.detail_hit is null then 0 else b.detail_hit end hit from
        qt_trading_area a
    left outer join
        qt_city_query_analyse b
    on
        a.city_code = b.city_code and a.name = b.query
    union all
    -- qt_themes
    select distinct a.city_code city_code, a.name name, 4 type, '' tag, 'null' seq, case when b.totalsearch is null then 0 else b.totalsearch end search_cnt, case when b.detail_hit is null then 0 else b.detail_hit end hit from
        qt_themes a
    left outer join
        qt_city_query_analyse b
    on
        a.city_code = b.city_code and a.name = b.query
    union all
    -- qt_hotel_room_types
    select distinct a.city_code city_code, a.name name, 5 type, '' tag, 'null' seq, case when b.totalsearch is null then 0 else b.totalsearch end search_cnt, case when b.detail_hit is null then 0 else b.detail_hit end hit from
        qt_hotel_room_types a
    left outer join
        qt_city_query_analyse b
    on
        a.city_code = b.city_code and a.name = b.query
    union all
    -- qt_hotel_grade
    select distinct a.city_code city_code, a.name name, 6 type, '' tag, 'null' seq, case when b.totalsearch is null then 0 else b.totalsearch end search_cnt, case when b.detail_hit is null then 0 else b.detail_hit end hit from
        qt_hotel_grade a
    left outer join
        qt_city_query_analyse b
    on
        a.city_code = b.city_code and a.name = b.query
    union all
    -- qt_hotel_brand
    select distinct a.city_code city_code, a.name name, 7 type, '' tag, 'null' seq, case when b.totalsearch is null then 0 else b.totalsearch end search_cnt, case when b.detail_hit is null then 0 else b.detail_hit end hit from
        qt_hotel_brand a
    left outer join
        qt_city_query_analyse b
    on
        a.city_code = b.city_code and a.name = b.query
    union all
    -- qt_hotel_group
    select distinct a.city_code city_code, a.name name, 7 type, '' tag, 'null' seq, case when b.totalsearch is null then 0 else b.totalsearch end search_cnt, case when b.detail_hit is null then 0 else b.detail_hit end hit from
        qt_hotel_group a
    left outer join
        qt_city_query_analyse b
    on
        a.city_code = b.city_code and a.name = b.query
    union all
    -- qt_linkage_names
    select distinct a.city city_code, a.name name, 8 type, '' tag, a.hotel_seq seq, case when b.totalsearch is null then 0 else b.totalsearch end search_cnt, case when b.detail_hit is null then 0 else b.detail_hit end hit from
        qt_linkage_names a
    left outer join
        qt_city_query_analyse b
    on
        a.city = b.city_code and a.name = b.query
    union all
    -- qt_man_made_suggest
    select distinct city_code, name, 9 type, tag, 'null' seq, search_cnt, detail_cnt hit from
        qt_man_made_suggest
    -- muti poi + brand
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct x.city_code, concat(x.name, ' ', y.name) as name, x.type, x.tag, x.hit from (
            select distinct a.city_code city_code, a.name name, 10 type, '' tag, case when b.detail_hit is null then 0 else b.detail_hit end hit from
            qt_poi a
            join
            qt_city_query_analyse b
            on
            a.city_code = b.city_code and a.name = b.query
            where
            b.detail_hit > 100
        ) x
        join
        qt_hotel_brand y
        on
        x.city_code = y.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct x.city_code, concat(y.name, ' ', x.name) as name, x.type, x.tag, x.hit from (
            select distinct a.city_code city_code, a.name name, 10 type, '' tag, case when b.detail_hit is null then 0 else b.detail_hit end hit from
            qt_poi a
            join
            qt_city_query_analyse b
            on
            a.city_code = b.city_code and a.name = b.query
            where
            b.detail_hit > 100
        ) x
        join
        qt_hotel_brand y
        on
        x.city_code = y.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    -- poi + grade
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct x.city_code, concat(x.name, ' ', y.name) as name, x.type, x.tag, x.hit from (
            select distinct a.city_code city_code, a.name name, 11 type, '' tag, case when b.detail_hit is null then 0 else b.detail_hit end hit from
            qt_poi a
            join
            qt_city_query_analyse b
            on
            a.city_code = b.city_code and a.name = b.query
            where
            b.detail_hit > 100
        ) x
        join
        qt_hotel_grade y
        on
        x.city_code = y.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct x.city_code, concat(y.name, ' ', x.name) as name, x.type, x.tag, x.hit from (
            select distinct a.city_code city_code, a.name name, 11 type, '' tag, case when b.detail_hit is null then 0 else b.detail_hit end hit from
            qt_poi a
            join
            qt_city_query_analyse b
            on
            a.city_code = b.city_code and a.name = b.query
            where
            b.detail_hit > 100
        ) x
        join
        qt_hotel_grade y
        on
        x.city_code = y.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    -- trading_area + brand
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct a.city_code city_code, concat(a.name, ' ', b.name) as name, 20 type, '' tag, 0 hit from
            qt_trading_area a
        join
            qt_hotel_brand b
        on
            a.city_code = b.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct a.city_code city_code, concat(b.name, ' ', a.name) as name, 20 type, '' tag, 0 hit from
            qt_trading_area a
        join
            qt_hotel_brand b
        on
            a.city_code = b.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
   -- trading_area + grade
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct a.city_code city_code, concat(a.name, ' ', b.name) as name, 21 type, '' tag, 0 hit from
            qt_trading_area a
        join
            qt_hotel_grade b
        on
            a.city_code = b.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct a.city_code city_code, concat(b.name, ' ', a.name) as name, 21 type, '' tag, 0 hit from
            qt_trading_area a
        join
            qt_hotel_grade b
        on
            a.city_code = b.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    -- subway + brand
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct a.city_code city_code, concat(a.name, ' ', b.name) as name, 30 type, '' tag, 0 hit from
            qt_subway a
        join
            qt_hotel_brand b
        on
            a.city_code = b.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct a.city_code city_code, concat(b.name, ' ', a.name) as name, 30 type, '' tag, 0 hit from
            qt_subway a
        join
            qt_hotel_brand b
        on
            a.city_code = b.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    -- subway + grade
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct a.city_code city_code, concat(a.name, ' ', b.name) as name, 31 type, '' tag, 0 hit from
            qt_subway a
        join
            qt_hotel_grade b
        on
            a.city_code = b.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
    union all
    select distinct p.city_code, p.name, p.type, p.tag, 'null' seq, case when q.totalsearch is null then 0 else q.totalsearch end search_cnt, case when q.detail_hit is null then 0 else q.detail_hit end hit from (
        select distinct a.city_code city_code, concat(b.name, ' ', a.name) as name, 31 type, '' tag, 0 hit from
            qt_subway a
        join
            qt_hotel_grade b
        on
            a.city_code = b.city_code
    ) p
    left outer join
    qt_city_query_analyse q
    on
    p.city_code = q.city_code and p.name = q.query
) tmp 
left outer join
    qt_black_words f
on
    tmp.city_code = f.city_code and tmp.name = f.name
where
    f.status is null;
