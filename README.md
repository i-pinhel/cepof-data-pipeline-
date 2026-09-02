# Experimental Data Ingestion Pipeline (CEPOF)

**The Problem:** In the lab, we generate thousands of lines of laser telemetry. This project automates the cleaning and structuring of this data for analysis.

**Architecture:** Python (Pandas) -> SQLite -> Docker.

**How to Run:**
1. `docker build -t cepof-pipeline .`
2. `docker run cepof-pipeline`

**Insights:**
The SQL queries use JOINs across 3 normalized tables and a Window Function to calculate a moving average of the laser power, which helps identify equipment instability over time.
