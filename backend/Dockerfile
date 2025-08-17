# Use JDK17 runtime image
FROM eclipse-temurin:17-jdk

# Set working directory inside container
WORKDIR /opt/bookapp

# Copy the backend jar (copied from Jenkins pipeline)
COPY backend-app.jar app.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Start the app
ENTRYPOINT ["java", "-jar", "app.jar"]
