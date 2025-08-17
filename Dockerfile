# ==============================
# Stage 1: Build with Maven
# ==============================
FROM maven:3.8.1-openjdk-11 AS builder
WORKDIR /app

# Copy pom.xml and download dependencies first (better caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# ==============================
# Stage 2: Run Spring Boot
# ==============================
FROM openjdk:11-jre-slim
ARG JAR_FILE=/app/target/*.jar

# Copy jar from builder
COPY --from=builder ${JAR_FILE} /opt/bookapp/app.jar

WORKDIR /opt/bookapp
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
