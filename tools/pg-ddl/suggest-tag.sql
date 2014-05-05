drop table if exists hs_hotel_suggest_with_tag;

create table hs_hotel_suggest_with_tag (
    id serial not null,
    city_code text not null,
    suggest text not null,
    tag text not null,
    search_cnt int not null,
    detail_cnt int not null,
    status int not null default 0,
    unique(city_code, suggest, tag)
);

drop table hs_hotel_suggest_blacks;

create table hs_hotel_suggest_blacks (
    id serial not null,
    city_code text,
    name text not null,
    status int not null default 0
);
