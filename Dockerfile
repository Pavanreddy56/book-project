# Builder stage
FROM maven:3.9.2-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Final stage
FROM eclipse-temurin:17-jdk
ARG JAR_FILE=target/book-app-0.0.1-SNAPSHOT.jar
COPY --from=builder /app/${JAR_FILE} /opt/bookapp/app.jar
WORKDIR /opt/bookapp
ENTRYPOINT ["java","-jar","app.jar"]
