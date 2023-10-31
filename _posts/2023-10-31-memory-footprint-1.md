---
layout: post
title: Memory Footprint
date: 2022-11-22 16:07:00 -0700
categories: hasura events algolia search
---

# Table of Contents

1.  [What](#org1229e2b)
2.  [Why](#org3bf1920)
3.  [How](#org43832c1)
4.  [Steps](#org8a7fe4c)


<a id="org1229e2b"></a>

# What

This project helps measure the scaling relationship between the number
of tracked tables, the number of roles, and the memory footprint for
Hasura `graphql-engine` v2.


<a id="org3bf1920"></a>

# Why

It's a matter of lore to say that Hasura's memory usage is
proportional both to the number of tracked tables and the number or
roles on those tables.  This project is an attempt to demystify that
lore with a quantitative analysis.


<a id="org43832c1"></a>

# How

This project has a `docker-compose.yaml` file that starts two
services, `postgres` and `graphql-engine`.  The `postgres` service has
initialization scripts that create functions for creating tables and
for generating Hasura metadata.  The general recipe then is:

1.  Launch the services.
2.  Call the PostgreSQL functions to create some number of tables.
3.  Call the PostgreSQL function to create the metadata and apply it to
    Hasura.


<a id="org8a7fe4c"></a>

# Steps

1.  Clone this repository.

    git clone https://github.com/dventimihasura/hasura-projects.git

1.  Change to the `memory-footprint-1` directory.

    cd memory-footprint-1

1.  Start the `postgres` and `graphql-engine` services using Docker
    Compose.

    docker compose up -d

1.  Use the `psql` PostgreSQL client to create the desired number of
    schema and tables within those schema.

    psql "postgres://postgres:postgres@localhost:15432/postgres" -f scratch.sql -vN_SCHEMA=1 -vN_TABLES=10

1.  Use the `psql` PostgreSQL client to generate Hasura metadata to
    track those tables and associate the desired number of
    `select_permission` roles.  In this example we're creating roles
    `role_1` through `role_10`.

    psql -At "postgres://postgres:postgres@localhost:15432/postgres" -c "select create_metadata(1, 10)" | curl -s http://localhost:8080/v1/metadata -d @-

1.  Examine the `graphql_engine` Docker container memory footprint.

    docker stats memory-footprint-1-graphql-engine-1

