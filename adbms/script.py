import psycopg2
from decouple import config

# Database connector
dbConn1 = psycopg2.connect(database="postgres", user="postgres", password=config('PASSWORD1'), host=config('HOST1'), port=config('PORT1')) 
dbConn1.autocommit = True
dbCursor1 = dbConn1.cursor()

dbConn2 = psycopg2.connect(database="postgres", user="postgres", password=config('PASSWORD2'), host=config('HOST2'), port=config('PORT2')) 
dbConn2.autocommit = True
dbCursor2 = dbConn2.cursor()

while True:
    command = input("Enter command: ")
    try:
        dbCursor1.execute("BEGIN;") 
        dbCursor1.execute(command)
        dbCursor2.execute("BEGIN;") 
        dbCursor2.execute(command)
        print("Command executed successfully!!!\nCommitting...")
        dbCursor1.execute("commit;") 
        dbCursor2.execute("commit;")
    except Exception as error:
        print("An error occurred!!!\nInitiating Rollback...") 
        print(error)
        dbCursor1.execute("rollback;") 
        dbCursor2.execute("rollback;")
