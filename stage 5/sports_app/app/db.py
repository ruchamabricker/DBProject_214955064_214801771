import psycopg2

def connect_db():
    try:
        conn = psycopg2.connect(
            dbname="integratedDB",
            user="postgres",
            password="Ruchama613!",
            host="localhost",
            port="5432"
        )
        return conn
    except Exception as e:
        print("Connecting error", e)
        return None
