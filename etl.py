from pyspark.sql import SparkSession
from pyspark.sql.functions import col, get_json_object

def main():
    # Initialize a SparkSession
    spark = SparkSession.builder.getOrCreate()

    # Define the input path
    input_path = "hivecontainer/road-weather-information-stations.csv"

    # Read CSV data from Azure Blob Storage
    df = spark.read.csv("wasbs://{0}@{1}.blob.core.windows.net/{2}".format("hivestoracontainer", "hivestora", input_path), header=True)

    # Perform transformations
    df = df.withColumn("Latitude", get_json_object(col("StationLocation"), "$.coordinates[1]")) \
           .withColumn("Longitude", get_json_object(col("StationLocation"), "$.coordinates[0]")) \
           .drop("StationLocation")

    df = df.dropDuplicates(["RecordId"])

    # Define the output path
    output_path = "hiveoutputcontainer/road-weather-information-stations-output.csv"

    # Write DataFrame to Delta format
    df.write.format("delta").save("wasbs://{0}@{1}.blob.core.windows.net/{2}".format("hiveoutputcontainer", "hivestora", output_path))

if __name__ == "__main__":
    main()
