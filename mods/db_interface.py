#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Submodule for SQL statements shipping to PostgreSQL
"""

import psycopg2		#use for DB connections

def connect(host='127.0.0.1', port=5432, db='postgres', user='postgres', password=None):
	conn_string = "host='%s' port='%s' dbname='%s' user='%s' password='%s'" % (host, port, db, user, password)  #generate connection string
	conn = psycopg2.connect(conn_string)                        #connect to database
	cursor = conn.cursor()										#set cursor for statements execution
	return conn, cursor

def query(statement, connect, cursor, flag=None):
	cursor.execute(statement)
	if flag != 'insert':
		result = cursor.fetchall()									#get statement string
		return result
	else:
		connect.commit()											#INSERT statement needs commit
		return 'INSERT succeeded!'