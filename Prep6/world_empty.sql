DROP SCHEMA IF EXISTS World CASCADE;
CREATE SCHEMA World;
SET search_path TO World;

CREATE TABLE country (
    code character(3) NOT NULL,
    name text NOT NULL,
    continent text NOT NULL,
    population integer NOT NULL
);

CREATE TABLE countrylanguage (
    countrycode character(3) NOT NULL,
    countrylanguage text NOT NULL,
    isofficial boolean,
    percentage real
);
