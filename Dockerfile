# Use Ubuntu as base image
FROM ubuntu:22.04

# Install OpenJDK 21
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Java environment variables
ENV JAVA_HOME /usr/lib/jvm/java-21-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin

# Create app directory
WORKDIR /app

# Build stage
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build
# Copy pom.xml and src
COPY pom.xml .
COPY src ./src
# Build the application
RUN mvn clean package -DskipTests

# Update the COPY command to use the built JAR from build stage
COPY --from=build /build/target/*.jar app.jar

# Expose the port your app runs on (typically 8080 for Spring Boot)
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
