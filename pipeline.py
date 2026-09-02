import sqlite3
import pandas as pd

def init_db():
    conn = sqlite3.connect('cepof_data.db')
    with open('schema.sql', 'r') as f:
        conn.executescript(f.read())
    return conn

def load_data(conn):
    # Simulating reading raw CSVs
    df_investigators = pd.read_csv('raw_investigators.csv')
    df_experiments = pd.read_csv('raw_experiments.csv')
    
    # Basic cleaning: dropping measurements without a power value
    df_measurements = pd.read_csv('raw_measurements.csv').dropna(subset=['power_mw'])

    # Inserting into SQLite
    df_investigators.to_sql('investigators', conn, if_exists='append', index=False)
    df_experiments.to_sql('experiments', conn, if_exists='append', index=False)
    df_measurements.to_sql('optical_measurements', conn, if_exists='append', index=False)
    
    print("Pipeline executed successfully! Data inserted.")

if __name__ == "__main__":
    connection = init_db()
    load_data(connection)
    connection.close()
