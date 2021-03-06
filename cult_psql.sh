#!/bin/bash

if [ $# -eq 0 ]; then
   MYDATABASE="cult"
else
   MYDATABASE=$1
fi

echo "Creating $MYDATABASE"

# Lesgo
dropdb $MYDATABASE
createdb $MYDATABASE

# Create classes table
psql -c "CREATE TABLE classes (
    id SERIAL,
    epoch_time INTEGER,
    class_id INTEGER,
    class_date CHARACTER VARYING(10),
    center_id INTEGER,
    workout_id INTEGER,
    seats INTEGER,
    startTime CHARACTER VARYING(8),
    endTime CHARACTER VARYING(8),
    formattedStartTime CHARACTER VARYING(7),
    formattedEndTime CHARACTER VARYING(7),
    isActive BOOLEAN,
    bookingNumber CHARACTER VARYING(15),
    version INTEGER,
    time_stamp TIMESTAMP WITH TIME ZONE
);" $MYDATABASE

# Populate using matches CSVs
for x in $(ls logs/cult_classes_*.csv);
  do
    echo "Copying $x"
    psql -c "\COPY classes(
                    epoch_time,
                    class_id,
                    class_date,
                    center_id,
                    workout_id,
                    seats,
                    startTime,
                    endTime,
                    formattedStartTime,
                    formattedEndTime,
                    isActive,
                    bookingNumber,
                    version)
                   FROM '$x' DELIMITER ',' CSV;" $MYDATABASE
done;
# Set match_date using tourney_date string
psql -c "UPDATE classes SET time_stamp=to_timestamp(epoch_time);" $MYDATABASE

echo "Classes Imported."

# Create players table
psql -c "CREATE TABLE workouts (
    id INTEGER,
    name CHARACTER VARYING(20),
    status CHARACTER VARYING(20),
    colour CHARACTER VARYING(20)
);" $MYDATABASE

psql -c "\COPY workouts(id, name, status, colour) FROM 'logs/cult_workouts.csv' DELIMITER ',' CSV;" $MYDATABASE

echo "Workouts Imported."

echo "All done."
