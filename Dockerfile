# ======================================================================
# Stage 1: Front-end Build (Node)
# ======================================================================
FROM node:20-alpine AS frontend

# Set up the working directory for the front-end code
WORKDIR /app/frontend

# Copy package files and install dependencies
COPY frontend/package.json .
COPY frontend/package-lock.json .
RUN npm install

# Copy source code and build the front-end assets
COPY frontend/src /app/frontend/src
RUN npm run build # Assuming this command generates static files in 'dist/'

# ======================================================================
# Stage 2: Back-end Build (Maven/Java)
# ======================================================================
FROM maven:3.9-openjdk-17 AS backend

WORKDIR /app

# 1. Copy necessary files for Java compilation
COPY pom.xml .
COPY src /app/src

# 2. Copy the built static assets from the frontend stage
# Copy the 'dist' folder (or equivalent) into the Java project's static resources
COPY --from=frontend /app/frontend/dist /app/src/main/resources/static 

# 3. Build the final executable JAR file
RUN mvn clean package -DskipTests

ARG JAR_FILE=target/your-application-name-0.0.1-SNAPSHOT.jar


# ======================================================================
# Stage 3: Final Runtime (JRE)
# ======================================================================
FROM openjdk:17-jre-slim

EXPOSE 8080
WORKDIR /app

# Copy the final fat JAR from the backend stage
COPY --from=backend /app/${JAR_FILE} app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
