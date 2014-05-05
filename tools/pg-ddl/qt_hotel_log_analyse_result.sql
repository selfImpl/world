begin;
drop table if exists qt_hotel_log_analyse_result_tmp;
create table qt_hotel_log_analyse_result_tmp
(
    city_code       text,
    query           text,
    type            int,
    tag             text,
    hotel_seq       text,
    search_cnt      int,
    detail_cnt      int
);
drop table if exists qt_hotel_log_analyse_result_tmp_id;
create table qt_hotel_log_analyse_result_tmp_id
(
    id              serial,
    city_code       text not null,
    query           text not null,
    type            int not null,
    tag             text not null,
    hotel_seq       text not null default '',
    search_cnt      int not null default 0,
    detail_cnt      int not null default 0
);
drop table if exists qt_hotel_log_analyse_result;
create table qt_hotel_log_analyse_result
(
    id              serial,
    city_code       text not null,
    query           text not null,
    query_py        text not null default '',
    type            int not null,
    tag             text not null,
    tag_py          text not null default '',
    hotel_seq       text not null default '',
    search_cnt      int not null default 0,
    detail_cnt      int not null default 0,
    status          int not null default 0,
    last_mod        timestamp not null default now(),
    app              hstore DEFAULT ''::hstore NOT NULL,
    poi_in_name     integer DEFAULT 0 NOT NULL
);
create index on qt_hotel_log_analyse_result(id);
create index on qt_hotel_log_analyse_result(type);
create index on qt_hotel_log_analyse_result(last_mod);
commit;
