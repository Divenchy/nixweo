# Spark / Scala / Java shell matching Databricks Runtime 17 (Spark 4.0, Scala 2.13, Java 17).
# Pinned to JDK 17 here because the global jdk25 is not supported by Spark.
{pkgs}: let
  jdk = pkgs.jdk17;
in
  pkgs.mkShell {
    packages = with pkgs; [
      jdk
      spark_4_0 # wraps its own JDK 21
      scala_2_13
      (sbt.override {jre = jdk;})
      (metals.override {jre = jdk;})
      coursier
      scala-cli
      databricks-cli
      python313 # for bin/pyspark
    ];
    JAVA_HOME = jdk.home;
    PYSPARK_PYTHON = "python3";
  }
