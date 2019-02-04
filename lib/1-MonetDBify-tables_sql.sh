#!/bin/bash

# MonetDB does not "like" varchar without size;
# use string instead.

sed -i 's|varchar|string|' */tables.sql

