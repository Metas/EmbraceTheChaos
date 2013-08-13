import sqlite3 ;
from datetime import datetime, date;

conn = sqlite3.connect('embrace_the_chaos.sqlite3')
c= conn.cursor()
c.execute('drop table if exists tbl_quote')
c.execute('drop table if exists tbl_topic')

c.execute('create table tbl_topic(topic_id integer,topic_val text)')
c.execute('create table tbl_quote(quote_id integer primary key autoincrement,topic_id integer, pic_id integer, isFav integer, saveYN integer, createDate text, quote_val text)')

sql ="insert into tbl_topic values(1,'Empowerment')"
c.execute(sql)
sql = "insert into tbl_topic values(2,'Meditation')"
c.execute(sql)

sql = "insert into tbl_quote values(NULL,1,1,1,0,'06-19-2013','Time is Money')"
c.execute(sql)
sql = "insert into tbl_quote values(NULL,2,2,1,0,'06-19-2013','You are what you eat')"
c.execute(sql)
sql = "insert into tbl_quote values(NULL,1,1,0,1,'06-20-2013','You just have to ask')"
c.execute(sql)
sql = "insert into tbl_quote values(NULL,2,1,0,1,'06-19-2013','Health is Wealth')"
c.execute(sql)
sql= "insert into tbl_quote values(NULL,2,2,0,1,'06-24-2013','Good or Bad They will pass')"
c.execute(sql)
sql = "insert into tbl_quote values(NULL,1,2,0,1,'06-24-2013','Dont get attached to moments')"
c.execute(sql)
sql = "insert into tbl_quote values(NULL,1,1,0,1,'06-19-2013','Live the life you imagined')"
c.execute(sql)


conn.commit()
