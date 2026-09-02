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
