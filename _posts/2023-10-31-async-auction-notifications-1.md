---
layout: post
title: async-auction-notifications-1
date: 2022-11-22 16:07:00 -0700
categories: hasura events algolia search
---

# Table of Contents

1.  [What](#org8cb5c2d)
2.  [Why](#orgc1dec7e)
3.  [How](#org8819d03)
4.  [Steps](#org3e25708)
    1.  [Step 1](#org273f38c)
    2.  [Step 2](#org7d1e31a)
    3.  [Step 3](#org5dbdc68)
    4.  [Step 4](#org5fd1fd6)
    5.  [Step 5](#orgdc1c465)
    6.  [Step 6](#org9b36cbe)
    7.  [Step 7](#orgb4df324)
    8.  [Step 8](#orgde6df97)


<a id="org8cb5c2d"></a>

# What

This Proof-Of-Concept (POC) demonstrates asynchronous messaging with
Hasura Event Triggers and Hasura Subscriptions, operating in an auction
involving truckers who want to receive message notifications when
there are product deliveries whose origin and destination match the
origin and destination of routes on their schedules, so that they can
bid on those matching delivieries.


<a id="orgc1dec7e"></a>

# Why

Truckers with routes being matched to deliveries is a particular
instance of a general pattern, which is users registering interest in
a search query.  In this pattern, it's useful to receive a message or
an update when new data satisfies the search criteria.  This POC sets
up a data model to support exploring different ways of implementing
this in Hasura.  Some options are:

-   Hasura [Event Triggers](https://hasura.io/docs/latest/event-triggers/overview/)
-   Hasura [Subscriptions](https://hasura.io/docs/latest/subscriptions/overview/)


<a id="org8819d03"></a>

# How

The `delivery` table captures planned deliveries of a `product`
between an origin `region` and a destination `region` starting within
a date range.

The `route` table captures planned journeys of a trucker with an
`account` between an origin `region` and a destination `region`
starting within a date range.

The `route_message` table captures messages intended to notify a
trucker with an `account` that there are matches among the origin
`region` and `destination` region for `delivery` and `route` journeys
starting within an overlapping date range.  It is this table that
would be the target of Hasura event triggers.

The `generate_messages` trigger function (and matching triggers) fires
when rows are inserted into the `route` and/or `delivery` table, to
check for matches and add corresponding entries to the `route_message`
table.

The `run_simulation` function randomly generates `delivery` and
`route` journeys distributed over the next 10 days, for randomly
chosen `product` entries and `account` truckers.  Because the data are
random, it is not guaranteed that there will be matches between the
`route` and `delivery` entries.  In practice, 100 each of `route` and
`delivery` is sufficient for there to be a dozen or so matches so that
messages can be added to the `route_message` table.

See the <postgres-initdb.d/01_init_model.sql> file, the
<postgres-initdb.d/02_init_data.sql> file, and especially
<postgres-initdb.d/03_add_auction_model.sql> files for details.


<a id="org3e25708"></a>

# Steps


<a id="org273f38c"></a>

## Step 1

Clone this GitHub repostory.

    git clone https://github.com/dventimihasura/hasura-projects.git


<a id="org7d1e31a"></a>

## Step 2

Change to the `async-auction-notifications-1` project sub-directory.

    cd async-auction-notifications-1


<a id="org5dbdc68"></a>

## Step 3

Create a `.env` Docker Compose
[environment](<https://docs.docker.com/compose/environment-variables/set-environment-variables/>)
file.

    cat <<EOF > .env
    HGEPORT~<your exposed Hasura port>
    PGPORT~<your exposed PostgreSQL port>
    EOF


<a id="org5fd1fd6"></a>

## Step 4

Use a text editor to edit the `.env` file and replace the template
values as appropriate.

-   **`HGEPORT`:** Port to expose Hasura on
-   **`PGPORT`:** Port to expose PostgreSQL on


<a id="orgdc1c465"></a>

## Step 5

Launch the services with Docker Compose.

    [docker-compose|docker compose] up -d


<a id="org9b36cbe"></a>

## Step 6

Use the Hasura CLI to launch the Console and begin data modeling.

    hasura console --endpoint http://localhost:[HGE_PORT]


<a id="orgb4df324"></a>

## Step 7

In the Hasura Console API tab create a GraphQL Subscription to the `route_messages` field.

    subscription MyQuery {
      route_message {
        delivery_id
        id
        route_id
        route {
          origin
          destination
          account_id
        }
      }
    }

![img](api_tab.png)


<a id="orgde6df97"></a>

## Step 8

In the Hasura Console Data tab "SQL" text area call the
`run_simulation` function to simulate 100 random `delivery` entries
and 100 random `route` entries.

    select run_simulation(100, 100);

![img](data_tab.png)

