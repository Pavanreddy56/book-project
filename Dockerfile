# ==============================
# Stage 1: Build with Maven
# ==============================
FROM maven:3.8.1-openjdk-11 AS builder
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests

# ==============================
# Stage 2: Run Spring Boot
# ==============================
FROM openjdk:11-jre-slim

WORKDIR /opt/bookapp

# Copy the generated JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
