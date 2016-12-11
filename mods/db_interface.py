# !/usr/bin/env python
#  -*- coding: utf-8 -*-

"""
Submodule for SQL statements shipping to PostgreSQL
"""

import psycopg2


def connect(host='127.0.0.1', port=5432, db='postgres', user='postgres', password=None):
    # generate connection string
    conn_string = (
        "host='%s' port='%s' dbname='%s' user='%s' password='%s'"
        % (host, port, db, user, password)
    )
    # connect to database
    conn = psycopg2.connect(conn_string)
    # set cursor for statements execution
    cursor = conn.cursor()
    return conn, cursor


def query(statement, connect, cursor, flag=None):
    cursor.execute(statement)
    if flag != 'insert':
        # get statement string
        result = cursor.fetchall()
        return result
    else:
        # INSERT statement needs commit
        connect.commit()
        return 'INSERT succeeded!'