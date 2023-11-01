---
layout: post
title: Updateable Views
date: 2022-11-22 16:07:00 -0700
categories: hasura events algolia search
---

# Table of Contents

1.  [What](#org4147b78)
2.  [Why](#org9aed463)
3.  [How](#orgc3021c3)
4.  [Steps](#orgdfbedf7)
    1.  [Step 1:  Clone this GitHub repository hasura-projects.](#orgfc34611)
    2.  [Step 2:  Change to the updatable-views-1 project sub-directory.](#orgea6779f)
    3.  [Step 3:  Create a .env file.](#orge142ebd)
    4.  [Step 4:  Edit the .env file according to your needs.](#orgd29539f)
    5.  [Step 5:  Use Docker Compose to launch the services.](#org6bb9bda)
    6.  [Step 6:  Open a browser to Hasura console and try out mutations against the `product_private` field.](#org197c7dd)


<a id="org4147b78"></a>

# What

This project demonstrates using [rules](https://www.postgresql.org/docs/current/sql-createrule.html) and [triggers](https://www.postgresql.org/docs/current/sql-createtrigger.html) to make updatable
[views](https://www.postgresql.org/docs/current/sql-createview.html) in PostgreSQL.


<a id="org9aed463"></a>

# Why

PostgreSQL views are automatically updatable only under certain
conditions, which among other things prohibits the use of joins.
Views that are defined with joins are not automatically updatable.
However, it is possible to make views updatable in PostgreSQL using
rules or triggers.


<a id="orgc3021c3"></a>

# How

This project sets up a simple e-commerce data model in the
[01<sub>init</sub><sub>model.sql</sub>](initdb.d-postgres/01_init_model.sql) file and adds sample data in the [02<sub>init</sub><sub>data.sql</sub>](initdb.d-postgres/02_init_data.sql)
file.  It then modifies that model in the [03<sub>alter</sub><sub>model.sql</sub>](initdb.d-postgres/03_alter_model.sql) file.
The modifications are these.

1.  Split the `product` table out into `product`, `product_name`, and
    `product_price` tables.
2.  Create a `product_private` view that joins these three tables back
    together to restore the columns of the original table.  Note that
    the `_private` suffix is an irrelevant detail.  It could be
    anything.
3.  Create rules and triggers on the `product_private` view to handle
    the `insert`, `update`, and `delete` cases.

This project also has an instance of Hasura GraphQL Engine.  It also
has metadata to track *most* of the tables, but for demonstration
purposes it avoids tracking the `product`, `product_price`, and
`product_name` tables.  Rather, it tracks the `product_view` view as if
it were a table, and in so doing it is fully-updatable.  GraphQL
mutations do work against this view.

Note that the relationships between the `order_detail` and
`product_private` table and view do have to be created manually in
Hasura, as views cannot participate in foreign key constraints and so
consequently Hasura Console cannot recommend these relationships.


<a id="orgdfbedf7"></a>

# Steps


<a id="orgfc34611"></a>

## Step 1:  Clone this GitHub repository [hasura-projects](https://github.com/dventimihasura/hasura-projects).

    git clone https://github.com/dventimihasura/hasura-projects.git


<a id="orgea6779f"></a>

## Step 2:  Change to the [updatable-views-1](README.md) project sub-directory.

    cd updatable-views-1


<a id="orge142ebd"></a>

## Step 3:  Create a .env file.

    cat <<EOF > .env
    PGPORT=<an available port for PostgreSQL>
    HGEPORT=<an available port for Hasura>
    EOF


<a id="orgd29539f"></a>

## Step 4:  Edit the .env file according to your needs.

Choose appropriate ports for PostgreSQL and Hasura.


<a id="org6bb9bda"></a>

## Step 5:  Use Docker Compose to launch the services.

    docker compose up

or

    docker-compose up


<a id="org197c7dd"></a>

## Step 6:  Open a browser to Hasura console and try out mutations against the `product_private` field.

<http://localhost:HGEPORT>

    mutation MyMutation {
      insert_product_private_one(object: {name: "Fruit Loops", price: 206}) {
        id
        name
        price
      }
    }

