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
