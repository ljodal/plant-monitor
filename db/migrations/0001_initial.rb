# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:plants) do
      primary_key :id
      String :name, :null=>false
    end
  end

  up do
    run %{
      CREATE STREAM temperature_readings (
        plant_id integer,
        value real
      );
    }

    run %{
      CREATE STREAM moisture_readings (
        plant_id integer,
        value integer
      );
    }

    run %{
      CREATE STREAM light_readings (
        plant_id integer,
        value integer
      );
    }

    run %{
      CREATE CONTINUOUS VIEW temperature_hourly AS
      SELECT
        plant_id,
        date_trunc('hour', arrival_timestamp) AS hour,
        AVG(value) AS value, COUNT(value) AS count
      FROM temperature_readings
      GROUP BY plant_id, hour;
    }

    run %{
      CREATE CONTINUOUS VIEW moisture_hourly AS
      SELECT
        plant_id,
        date_trunc('hour', arrival_timestamp) AS hour,
        AVG(value) AS value, COUNT(value) AS count
      FROM moisture_readings
      GROUP BY plant_id, hour;
    }

    run %{
      CREATE CONTINUOUS VIEW light_hourly AS
      SELECT
        plant_id,
        date_trunc('hour', arrival_timestamp) AS hour,
        AVG(value) AS value, COUNT(value) AS count
      FROM light_readings
      GROUP BY plant_id, hour;
    }
  end

  down do
    run 'DROP CONTINUOUS VIEW temperature_hourly;'
    run 'DROP CONTINUOUS VIEW moisture_hourly;'
    run 'DROP CONTINUOUS VIEW light_hourly;'
    run 'DROP STREAM temperature_readings;'
    run 'DROP STREAM moisture_readings;'
    run 'DROP STREAM light_readings;'
  end
end
