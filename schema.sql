CREATE TABLE investigators (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    department TEXT
);

CREATE TABLE experiments (
    id INTEGER PRIMARY KEY,
    investigator_id INTEGER,
    experiment_date DATE,
    laser_type TEXT,
    FOREIGN KEY (investigator_id) REFERENCES investigators(id)
);

CREATE TABLE optical_measurements (
    id INTEGER PRIMARY KEY,
    experiment_id INTEGER,
    timestamp DATETIME,
    power_mw REAL,
    temperature_c REAL,
    FOREIGN KEY (experiment_id) REFERENCES experiments(id)
);

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

SELECT 
    i.name AS investigator,
    e.laser_type,
    m.timestamp,
    m.power_mw,
    AVG(m.power_mw) OVER (
        PARTITION BY e.id 
        ORDER BY m.timestamp 
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS moving_avg_power_5_readings
FROM optical_measurements m
JOIN experiments e ON m.experiment_id = e.id
JOIN investigators i ON e.investigator_id = i.id
ORDER BY e.id, m.timestamp;

FROM python:3.9-slim

WORKDIR /app

# Install dependencies (requires a requirements.txt file with 'pandas')
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Run the pipeline
CMD ["python", "pipeline.py"]
