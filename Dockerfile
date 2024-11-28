# Use OpenJDK runtime as the base image
FROM openjdk:17-jdk-slim
# Set the working directory inside the container
WORKDIR /app
# Accept the JAR file name as a build argument
ARG JAR_FILE
# Copy the dynamically passed JAR file into the container
COPY ${JAR_FILE} app.jar
# Expose the port your application will run on
EXPOSE 8080
# Define the command to run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

