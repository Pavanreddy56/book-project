# Stage 1: Build Backend
FROM maven:3.9.2-eclipse-temurin-17 AS backend-builder
WORKDIR /app

# Copy backend source and build
COPY backend/pom.xml backend/
COPY backend/src backend/src
RUN mvn clean package -DskipTests

# Stage 2: Build Frontend
FROM node:20 AS frontend-builder
WORKDIR /app

# Copy frontend source and install dependencies
COPY frontend/package.json frontend/package-lock.json frontend/
COPY frontend/src frontend/src
RUN npm install
RUN npm run build

# Stage 3: Combine backend + frontend
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /opt/app

# Copy backend jar
COPY --from=backend-builder /app/target/*.jar app.jar

# Copy frontend build
COPY --from=frontend-builder /app/build frontend

# Expose port (backend Spring Boot default)
EXPOSE 8080

# Run Spring Boot backend
ENTRYPOINT ["java", "-jar", "app.jar"]
