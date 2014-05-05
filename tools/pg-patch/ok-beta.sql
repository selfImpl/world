--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: BUCKETING_COLS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "BUCKETING_COLS" (
    "SD_ID" bigint NOT NULL,
    "BUCKET_COL_NAME" character varying(256),
    "INTEGER_IDX" integer NOT NULL
);


ALTER TABLE public."BUCKETING_COLS" OWNER TO postgres;

--
-- Name: COLUMNS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "COLUMNS" (
    "SD_ID" bigint NOT NULL,
    "COMMENT" character varying(256),
    "COLUMN_NAME" character varying(128) NOT NULL,
    "TYPE_NAME" character varying(4000) NOT NULL,
    "INTEGER_IDX" integer NOT NULL
);


ALTER TABLE public."COLUMNS" OWNER TO postgres;

--
-- Name: DATABASE_PARAMS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "DATABASE_PARAMS" (
    "DB_ID" bigint NOT NULL,
    "PARAM_KEY" character varying(180) NOT NULL,
    "PARAM_VALUE" character varying(4000)
);


ALTER TABLE public."DATABASE_PARAMS" OWNER TO postgres;

--
-- Name: DBS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "DBS" (
    "DB_ID" bigint NOT NULL,
    "DESC" character varying(4000),
    "DB_LOCATION_URI" character varying(4000) NOT NULL,
    "NAME" character varying(128)
);


ALTER TABLE public."DBS" OWNER TO postgres;

--
-- Name: DB_PRIVS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "DB_PRIVS" (
    "DB_GRANT_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "DB_ID" bigint,
    "GRANT_OPTION" smallint NOT NULL,
    "GRANTOR" character varying(128) DEFAULT NULL::character varying,
    "GRANTOR_TYPE" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_NAME" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_TYPE" character varying(128) DEFAULT NULL::character varying,
    "DB_PRIV" character varying(128) DEFAULT NULL::character varying
);


ALTER TABLE public."DB_PRIVS" OWNER TO postgres;

--
-- Name: GLOBAL_PRIVS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "GLOBAL_PRIVS" (
    "USER_GRANT_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "GRANT_OPTION" smallint NOT NULL,
    "GRANTOR" character varying(128) DEFAULT NULL::character varying,
    "GRANTOR_TYPE" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_NAME" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_TYPE" character varying(128) DEFAULT NULL::character varying,
    "USER_PRIV" character varying(128) DEFAULT NULL::character varying
);


ALTER TABLE public."GLOBAL_PRIVS" OWNER TO postgres;

--
-- Name: IDXS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "IDXS" (
    "INDEX_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "DEFERRED_REBUILD" bit(1) NOT NULL,
    "INDEX_HANDLER_CLASS" character varying(256) DEFAULT NULL::character varying,
    "INDEX_NAME" character varying(128) DEFAULT NULL::character varying,
    "INDEX_TBL_ID" bigint,
    "LAST_ACCESS_TIME" integer NOT NULL,
    "ORIG_TBL_ID" bigint,
    "SD_ID" bigint
);


ALTER TABLE public."IDXS" OWNER TO postgres;

--
-- Name: INDEX_PARAMS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "INDEX_PARAMS" (
    "INDEX_ID" bigint NOT NULL,
    "PARAM_KEY" character varying(256) NOT NULL,
    "PARAM_VALUE" character varying(767) DEFAULT NULL::character varying
);


ALTER TABLE public."INDEX_PARAMS" OWNER TO postgres;

--
-- Name: PARTITIONS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "PARTITIONS" (
    "PART_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "LAST_ACCESS_TIME" integer NOT NULL,
    "PART_NAME" character varying(767),
    "SD_ID" bigint,
    "TBL_ID" bigint
);


ALTER TABLE public."PARTITIONS" OWNER TO postgres;

--
-- Name: PARTITION_KEYS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "PARTITION_KEYS" (
    "TBL_ID" bigint NOT NULL,
    "PKEY_COMMENT" character varying(4000),
    "PKEY_NAME" character varying(128) NOT NULL,
    "PKEY_TYPE" character varying(767) NOT NULL,
    "INTEGER_IDX" integer NOT NULL
);


ALTER TABLE public."PARTITION_KEYS" OWNER TO postgres;

--
-- Name: PARTITION_KEY_VALS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "PARTITION_KEY_VALS" (
    "PART_ID" bigint NOT NULL,
    "PART_KEY_VAL" character varying(256),
    "INTEGER_IDX" integer NOT NULL
);


ALTER TABLE public."PARTITION_KEY_VALS" OWNER TO postgres;

--
-- Name: PARTITION_PARAMS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "PARTITION_PARAMS" (
    "PART_ID" bigint NOT NULL,
    "PARAM_KEY" character varying(256) NOT NULL,
    "PARAM_VALUE" character varying(4000)
);


ALTER TABLE public."PARTITION_PARAMS" OWNER TO postgres;

--
-- Name: PART_COL_PRIVS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "PART_COL_PRIVS" (
    "PART_COLUMN_GRANT_ID" bigint NOT NULL,
    "COLUMN_NAME" character varying(128) DEFAULT NULL::character varying,
    "CREATE_TIME" integer NOT NULL,
    "GRANT_OPTION" smallint NOT NULL,
    "GRANTOR" character varying(128) DEFAULT NULL::character varying,
    "GRANTOR_TYPE" character varying(128) DEFAULT NULL::character varying,
    "PART_ID" bigint,
    "PRINCIPAL_NAME" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_TYPE" character varying(128) DEFAULT NULL::character varying,
    "PART_COL_PRIV" character varying(128) DEFAULT NULL::character varying
);


ALTER TABLE public."PART_COL_PRIVS" OWNER TO postgres;

--
-- Name: PART_PRIVS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "PART_PRIVS" (
    "PART_GRANT_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "GRANT_OPTION" smallint NOT NULL,
    "GRANTOR" character varying(128) DEFAULT NULL::character varying,
    "GRANTOR_TYPE" character varying(128) DEFAULT NULL::character varying,
    "PART_ID" bigint,
    "PRINCIPAL_NAME" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_TYPE" character varying(128) DEFAULT NULL::character varying,
    "PART_PRIV" character varying(128) DEFAULT NULL::character varying
);


ALTER TABLE public."PART_PRIVS" OWNER TO postgres;

--
-- Name: ROLES; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "ROLES" (
    "ROLE_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "OWNER_NAME" character varying(128) DEFAULT NULL::character varying,
    "ROLE_NAME" character varying(128) DEFAULT NULL::character varying
);


ALTER TABLE public."ROLES" OWNER TO postgres;

--
-- Name: ROLE_MAP; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "ROLE_MAP" (
    "ROLE_GRANT_ID" bigint NOT NULL,
    "ADD_TIME" integer NOT NULL,
    "GRANT_OPTION" smallint NOT NULL,
    "GRANTOR" character varying(128) DEFAULT NULL::character varying,
    "GRANTOR_TYPE" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_NAME" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_TYPE" character varying(128) DEFAULT NULL::character varying,
    "ROLE_ID" bigint
);


ALTER TABLE public."ROLE_MAP" OWNER TO postgres;

--
-- Name: SDS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "SDS" (
    "SD_ID" bigint NOT NULL,
    "INPUT_FORMAT" character varying(4000),
    "IS_COMPRESSED" boolean NOT NULL,
    "LOCATION" character varying(4000),
    "NUM_BUCKETS" integer NOT NULL,
    "OUTPUT_FORMAT" character varying(4000),
    "SERDE_ID" bigint
);


ALTER TABLE public."SDS" OWNER TO postgres;

--
-- Name: SD_PARAMS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "SD_PARAMS" (
    "SD_ID" bigint NOT NULL,
    "PARAM_KEY" character varying(256) NOT NULL,
    "PARAM_VALUE" character varying(4000)
);


ALTER TABLE public."SD_PARAMS" OWNER TO postgres;

--
-- Name: SEQUENCE_TABLE; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "SEQUENCE_TABLE" (
    "SEQUENCE_NAME" character varying(255) NOT NULL,
    "NEXT_VAL" bigint NOT NULL
);


ALTER TABLE public."SEQUENCE_TABLE" OWNER TO postgres;

--
-- Name: SERDES; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "SERDES" (
    "SERDE_ID" bigint NOT NULL,
    "NAME" character varying(128),
    "SLIB" character varying(4000)
);


ALTER TABLE public."SERDES" OWNER TO postgres;

--
-- Name: SERDE_PARAMS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "SERDE_PARAMS" (
    "SERDE_ID" bigint NOT NULL,
    "PARAM_KEY" character varying(256) NOT NULL,
    "PARAM_VALUE" character varying(4000)
);


ALTER TABLE public."SERDE_PARAMS" OWNER TO postgres;

--
-- Name: SORT_COLS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "SORT_COLS" (
    "SD_ID" bigint NOT NULL,
    "COLUMN_NAME" character varying(128),
    "ORDER" integer NOT NULL,
    "INTEGER_IDX" integer NOT NULL
);


ALTER TABLE public."SORT_COLS" OWNER TO postgres;

--
-- Name: TABLE_PARAMS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "TABLE_PARAMS" (
    "TBL_ID" bigint NOT NULL,
    "PARAM_KEY" character varying(256) NOT NULL,
    "PARAM_VALUE" character varying(4000)
);


ALTER TABLE public."TABLE_PARAMS" OWNER TO postgres;

--
-- Name: TBLS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "TBLS" (
    "TBL_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "DB_ID" bigint,
    "LAST_ACCESS_TIME" integer NOT NULL,
    "OWNER" character varying(767),
    "RETENTION" integer NOT NULL,
    "SD_ID" bigint,
    "TBL_NAME" character varying(128),
    "TBL_TYPE" character varying(128),
    "VIEW_EXPANDED_TEXT" text,
    "VIEW_ORIGINAL_TEXT" text
);


ALTER TABLE public."TBLS" OWNER TO postgres;

--
-- Name: TBL_COL_PRIVS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "TBL_COL_PRIVS" (
    "TBL_COLUMN_GRANT_ID" bigint NOT NULL,
    "COLUMN_NAME" character varying(128) DEFAULT NULL::character varying,
    "CREATE_TIME" integer NOT NULL,
    "GRANT_OPTION" smallint NOT NULL,
    "GRANTOR" character varying(128) DEFAULT NULL::character varying,
    "GRANTOR_TYPE" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_NAME" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_TYPE" character varying(128) DEFAULT NULL::character varying,
    "TBL_COL_PRIV" character varying(128) DEFAULT NULL::character varying,
    "TBL_ID" bigint
);


ALTER TABLE public."TBL_COL_PRIVS" OWNER TO postgres;

--
-- Name: TBL_PRIVS; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "TBL_PRIVS" (
    "TBL_GRANT_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "GRANT_OPTION" smallint NOT NULL,
    "GRANTOR" character varying(128) DEFAULT NULL::character varying,
    "GRANTOR_TYPE" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_NAME" character varying(128) DEFAULT NULL::character varying,
    "PRINCIPAL_TYPE" character varying(128) DEFAULT NULL::character varying,
    "TBL_PRIV" character varying(128) DEFAULT NULL::character varying,
    "TBL_ID" bigint
);


ALTER TABLE public."TBL_PRIVS" OWNER TO postgres;

--
-- Name: BUCKETING_COLS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "BUCKETING_COLS"
    ADD CONSTRAINT "BUCKETING_COLS_pkey" PRIMARY KEY ("SD_ID", "INTEGER_IDX");


--
-- Name: COLUMNS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "COLUMNS"
    ADD CONSTRAINT "COLUMNS_pkey" PRIMARY KEY ("SD_ID", "COLUMN_NAME");


--
-- Name: DATABASE_PARAMS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "DATABASE_PARAMS"
    ADD CONSTRAINT "DATABASE_PARAMS_pkey" PRIMARY KEY ("DB_ID", "PARAM_KEY");


--
-- Name: DBPRIVILEGEINDEX; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "DB_PRIVS"
    ADD CONSTRAINT "DBPRIVILEGEINDEX" UNIQUE ("DB_ID", "PRINCIPAL_NAME", "PRINCIPAL_TYPE", "DB_PRIV", "GRANTOR", "GRANTOR_TYPE");


--
-- Name: DBS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "DBS"
    ADD CONSTRAINT "DBS_pkey" PRIMARY KEY ("DB_ID");


--
-- Name: DB_PRIVS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "DB_PRIVS"
    ADD CONSTRAINT "DB_PRIVS_pkey" PRIMARY KEY ("DB_GRANT_ID");


--
-- Name: GLOBALPRIVILEGEINDEX; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "GLOBAL_PRIVS"
    ADD CONSTRAINT "GLOBALPRIVILEGEINDEX" UNIQUE ("PRINCIPAL_NAME", "PRINCIPAL_TYPE", "USER_PRIV", "GRANTOR", "GRANTOR_TYPE");


--
-- Name: GLOBAL_PRIVS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "GLOBAL_PRIVS"
    ADD CONSTRAINT "GLOBAL_PRIVS_pkey" PRIMARY KEY ("USER_GRANT_ID");


--
-- Name: IDXS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "IDXS"
    ADD CONSTRAINT "IDXS_pkey" PRIMARY KEY ("INDEX_ID");


--
-- Name: INDEX_PARAMS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "INDEX_PARAMS"
    ADD CONSTRAINT "INDEX_PARAMS_pkey" PRIMARY KEY ("INDEX_ID", "PARAM_KEY");


--
-- Name: PARTITIONS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "PARTITIONS"
    ADD CONSTRAINT "PARTITIONS_pkey" PRIMARY KEY ("PART_ID");


--
-- Name: PARTITION_KEYS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "PARTITION_KEYS"
    ADD CONSTRAINT "PARTITION_KEYS_pkey" PRIMARY KEY ("TBL_ID", "PKEY_NAME");


--
-- Name: PARTITION_KEY_VALS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "PARTITION_KEY_VALS"
    ADD CONSTRAINT "PARTITION_KEY_VALS_pkey" PRIMARY KEY ("PART_ID", "INTEGER_IDX");


--
-- Name: PARTITION_PARAMS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "PARTITION_PARAMS"
    ADD CONSTRAINT "PARTITION_PARAMS_pkey" PRIMARY KEY ("PART_ID", "PARAM_KEY");


--
-- Name: PART_COL_PRIVS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "PART_COL_PRIVS"
    ADD CONSTRAINT "PART_COL_PRIVS_pkey" PRIMARY KEY ("PART_COLUMN_GRANT_ID");


--
-- Name: PART_PRIVS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "PART_PRIVS"
    ADD CONSTRAINT "PART_PRIVS_pkey" PRIMARY KEY ("PART_GRANT_ID");


--
-- Name: ROLEENTITYINDEX; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "ROLES"
    ADD CONSTRAINT "ROLEENTITYINDEX" UNIQUE ("ROLE_NAME");


--
-- Name: ROLES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "ROLES"
    ADD CONSTRAINT "ROLES_pkey" PRIMARY KEY ("ROLE_ID");


--
-- Name: ROLE_MAP_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "ROLE_MAP"
    ADD CONSTRAINT "ROLE_MAP_pkey" PRIMARY KEY ("ROLE_GRANT_ID");


--
-- Name: SDS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "SDS"
    ADD CONSTRAINT "SDS_pkey" PRIMARY KEY ("SD_ID");


--
-- Name: SD_PARAMS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "SD_PARAMS"
    ADD CONSTRAINT "SD_PARAMS_pkey" PRIMARY KEY ("SD_ID", "PARAM_KEY");


--
-- Name: SEQUENCE_TABLE_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "SEQUENCE_TABLE"
    ADD CONSTRAINT "SEQUENCE_TABLE_pkey" PRIMARY KEY ("SEQUENCE_NAME");


--
-- Name: SERDES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "SERDES"
    ADD CONSTRAINT "SERDES_pkey" PRIMARY KEY ("SERDE_ID");


--
-- Name: SERDE_PARAMS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "SERDE_PARAMS"
    ADD CONSTRAINT "SERDE_PARAMS_pkey" PRIMARY KEY ("SERDE_ID", "PARAM_KEY");


--
-- Name: SORT_COLS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "SORT_COLS"
    ADD CONSTRAINT "SORT_COLS_pkey" PRIMARY KEY ("SD_ID", "INTEGER_IDX");


--
-- Name: TABLE_PARAMS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "TABLE_PARAMS"
    ADD CONSTRAINT "TABLE_PARAMS_pkey" PRIMARY KEY ("TBL_ID", "PARAM_KEY");


--
-- Name: TBLS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "TBLS"
    ADD CONSTRAINT "TBLS_pkey" PRIMARY KEY ("TBL_ID");


--
-- Name: TBL_COL_PRIVS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "TBL_COL_PRIVS"
    ADD CONSTRAINT "TBL_COL_PRIVS_pkey" PRIMARY KEY ("TBL_COLUMN_GRANT_ID");


--
-- Name: TBL_PRIVS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "TBL_PRIVS"
    ADD CONSTRAINT "TBL_PRIVS_pkey" PRIMARY KEY ("TBL_GRANT_ID");


--
-- Name: UNIQUEINDEX; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "IDXS"
    ADD CONSTRAINT "UNIQUEINDEX" UNIQUE ("INDEX_NAME", "ORIG_TBL_ID");


--
-- Name: USERROLEMAPINDEX; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "ROLE_MAP"
    ADD CONSTRAINT "USERROLEMAPINDEX" UNIQUE ("PRINCIPAL_NAME", "ROLE_ID", "GRANTOR", "GRANTOR_TYPE");


--
-- Name: BUCKETING_COLS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "BUCKETING_COLS_N49" ON "BUCKETING_COLS" USING btree ("SD_ID");


--
-- Name: COLUMNS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "COLUMNS_N49" ON "COLUMNS" USING btree ("SD_ID");


--
-- Name: DATABASE_PARAMS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "DATABASE_PARAMS_N49" ON "DATABASE_PARAMS" USING btree ("DB_ID");


--
-- Name: IDXS_FK1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "IDXS_FK1" ON "IDXS" USING btree ("SD_ID");


--
-- Name: IDXS_FK2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "IDXS_FK2" ON "IDXS" USING btree ("INDEX_TBL_ID");


--
-- Name: IDXS_FK3; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "IDXS_FK3" ON "IDXS" USING btree ("ORIG_TBL_ID");


--
-- Name: INDEX_PARAMS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "INDEX_PARAMS_N49" ON "INDEX_PARAMS" USING btree ("INDEX_ID");


--
-- Name: PARTITIONCOLUMNPRIVILEGEINDEX; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "PARTITIONCOLUMNPRIVILEGEINDEX" ON "PART_COL_PRIVS" USING btree ("PART_ID", "COLUMN_NAME", "PRINCIPAL_NAME", "PRINCIPAL_TYPE", "PART_COL_PRIV", "GRANTOR", "GRANTOR_TYPE");


--
-- Name: PARTITIONS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "PARTITIONS_N49" ON "PARTITIONS" USING btree ("SD_ID");


--
-- Name: PARTITIONS_N50; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "PARTITIONS_N50" ON "PARTITIONS" USING btree ("TBL_ID");


--
-- Name: PARTITION_KEYS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "PARTITION_KEYS_N49" ON "PARTITION_KEYS" USING btree ("TBL_ID");


--
-- Name: PARTITION_KEY_VALS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "PARTITION_KEY_VALS_N49" ON "PARTITION_KEY_VALS" USING btree ("PART_ID");


--
-- Name: PARTITION_PARAMS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "PARTITION_PARAMS_N49" ON "PARTITION_PARAMS" USING btree ("PART_ID");


--
-- Name: PARTPRIVILEGEINDEX; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "PARTPRIVILEGEINDEX" ON "PART_PRIVS" USING btree ("PART_ID", "PRINCIPAL_NAME", "PRINCIPAL_TYPE", "PART_PRIV", "GRANTOR", "GRANTOR_TYPE");


--
-- Name: PART_COL_PRIVS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "PART_COL_PRIVS_N49" ON "PART_COL_PRIVS" USING btree ("PART_ID");


--
-- Name: PART_PRIVS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "PART_PRIVS_N49" ON "PART_PRIVS" USING btree ("PART_ID");


--
-- Name: SDS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "SDS_N49" ON "SDS" USING btree ("SERDE_ID");


--
-- Name: SD_PARAMS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "SD_PARAMS_N49" ON "SD_PARAMS" USING btree ("SD_ID");


--
-- Name: SERDE_PARAMS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "SERDE_PARAMS_N49" ON "SERDE_PARAMS" USING btree ("SERDE_ID");


--
-- Name: SORT_COLS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "SORT_COLS_N49" ON "SORT_COLS" USING btree ("SD_ID");


--
-- Name: TABLECOLUMNPRIVILEGEINDEX; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "TABLECOLUMNPRIVILEGEINDEX" ON "TBL_COL_PRIVS" USING btree ("TBL_ID", "COLUMN_NAME", "PRINCIPAL_NAME", "PRINCIPAL_TYPE", "TBL_COL_PRIV", "GRANTOR", "GRANTOR_TYPE");


--
-- Name: TABLEPRIVILEGEINDEX; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "TABLEPRIVILEGEINDEX" ON "TBL_PRIVS" USING btree ("TBL_ID", "PRINCIPAL_NAME", "PRINCIPAL_TYPE", "TBL_PRIV", "GRANTOR", "GRANTOR_TYPE");


--
-- Name: TABLE_PARAMS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "TABLE_PARAMS_N49" ON "TABLE_PARAMS" USING btree ("TBL_ID");


--
-- Name: TBLS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "TBLS_N49" ON "TBLS" USING btree ("SD_ID");


--
-- Name: TBLS_N50; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "TBLS_N50" ON "TBLS" USING btree ("DB_ID");


--
-- Name: TBL_COL_PRIVS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "TBL_COL_PRIVS_N49" ON "TBL_COL_PRIVS" USING btree ("TBL_ID");


--
-- Name: TBL_PRIVS_N49; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "TBL_PRIVS_N49" ON "TBL_PRIVS" USING btree ("TBL_ID");


--
-- Name: UNIQUEPARTITION; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "UNIQUEPARTITION" ON "PARTITIONS" USING btree ("PART_NAME", "TBL_ID");


--
-- Name: UNIQUETABLE; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "UNIQUETABLE" ON "TBLS" USING btree ("TBL_NAME", "DB_ID");


--
-- Name: UNIQUE_DATABASE; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "UNIQUE_DATABASE" ON "DBS" USING btree ("NAME");


--
-- Name: BUCKETING_COLS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "BUCKETING_COLS"
    ADD CONSTRAINT "BUCKETING_COLS_FK1" FOREIGN KEY ("SD_ID") REFERENCES "SDS"("SD_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: COLUMNS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "COLUMNS"
    ADD CONSTRAINT "COLUMNS_FK1" FOREIGN KEY ("SD_ID") REFERENCES "SDS"("SD_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: DATABASE_PARAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "DATABASE_PARAMS"
    ADD CONSTRAINT "DATABASE_PARAMS_FK1" FOREIGN KEY ("DB_ID") REFERENCES "DBS"("DB_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: DB_PRIVS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "DB_PRIVS"
    ADD CONSTRAINT "DB_PRIVS_FK1" FOREIGN KEY ("DB_ID") REFERENCES "DBS"("DB_ID");


--
-- Name: IDXS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "IDXS"
    ADD CONSTRAINT "IDXS_FK1" FOREIGN KEY ("SD_ID") REFERENCES "SDS"("SD_ID");


--
-- Name: IDXS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "IDXS"
    ADD CONSTRAINT "IDXS_FK2" FOREIGN KEY ("INDEX_TBL_ID") REFERENCES "TBLS"("TBL_ID");


--
-- Name: IDXS_FK3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "IDXS"
    ADD CONSTRAINT "IDXS_FK3" FOREIGN KEY ("ORIG_TBL_ID") REFERENCES "TBLS"("TBL_ID");


--
-- Name: INDEX_PARAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "INDEX_PARAMS"
    ADD CONSTRAINT "INDEX_PARAMS_FK1" FOREIGN KEY ("INDEX_ID") REFERENCES "IDXS"("INDEX_ID");


--
-- Name: PARTITIONS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PARTITIONS"
    ADD CONSTRAINT "PARTITIONS_FK1" FOREIGN KEY ("TBL_ID") REFERENCES "TBLS"("TBL_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PARTITIONS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PARTITIONS"
    ADD CONSTRAINT "PARTITIONS_FK2" FOREIGN KEY ("SD_ID") REFERENCES "SDS"("SD_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PARTITION_KEYS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PARTITION_KEYS"
    ADD CONSTRAINT "PARTITION_KEYS_FK1" FOREIGN KEY ("TBL_ID") REFERENCES "TBLS"("TBL_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PARTITION_KEY_VALS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PARTITION_KEY_VALS"
    ADD CONSTRAINT "PARTITION_KEY_VALS_FK1" FOREIGN KEY ("PART_ID") REFERENCES "PARTITIONS"("PART_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PARTITION_PARAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PARTITION_PARAMS"
    ADD CONSTRAINT "PARTITION_PARAMS_FK1" FOREIGN KEY ("PART_ID") REFERENCES "PARTITIONS"("PART_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PART_COL_PRIVS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PART_COL_PRIVS"
    ADD CONSTRAINT "PART_COL_PRIVS_FK1" FOREIGN KEY ("PART_ID") REFERENCES "PARTITIONS"("PART_ID");


--
-- Name: PART_PRIVS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "PART_PRIVS"
    ADD CONSTRAINT "PART_PRIVS_FK1" FOREIGN KEY ("PART_ID") REFERENCES "PARTITIONS"("PART_ID");


--
-- Name: ROLE_MAP_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "ROLE_MAP"
    ADD CONSTRAINT "ROLE_MAP_FK1" FOREIGN KEY ("ROLE_ID") REFERENCES "ROLES"("ROLE_ID");


--
-- Name: SDS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SDS"
    ADD CONSTRAINT "SDS_FK1" FOREIGN KEY ("SERDE_ID") REFERENCES "SERDES"("SERDE_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SD_PARAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SD_PARAMS"
    ADD CONSTRAINT "SD_PARAMS_FK1" FOREIGN KEY ("SD_ID") REFERENCES "SDS"("SD_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SERDE_PARAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SERDE_PARAMS"
    ADD CONSTRAINT "SERDE_PARAMS_FK1" FOREIGN KEY ("SERDE_ID") REFERENCES "SERDES"("SERDE_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SORT_COLS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SORT_COLS"
    ADD CONSTRAINT "SORT_COLS_FK1" FOREIGN KEY ("SD_ID") REFERENCES "SDS"("SD_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: TABLE_PARAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "TABLE_PARAMS"
    ADD CONSTRAINT "TABLE_PARAMS_FK1" FOREIGN KEY ("TBL_ID") REFERENCES "TBLS"("TBL_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: TBLS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "TBLS"
    ADD CONSTRAINT "TBLS_FK1" FOREIGN KEY ("SD_ID") REFERENCES "SDS"("SD_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: TBLS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "TBLS"
    ADD CONSTRAINT "TBLS_FK2" FOREIGN KEY ("DB_ID") REFERENCES "DBS"("DB_ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: TBL_COL_PRIVS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "TBL_COL_PRIVS"
    ADD CONSTRAINT "TBL_COL_PRIVS_FK1" FOREIGN KEY ("TBL_ID") REFERENCES "TBLS"("TBL_ID");


--
-- Name: TBL_PRIVS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "TBL_PRIVS"
    ADD CONSTRAINT "TBL_PRIVS_FK1" FOREIGN KEY ("TBL_ID") REFERENCES "TBLS"("TBL_ID");


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

