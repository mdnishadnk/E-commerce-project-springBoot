# --- Stage 1: Build the application ---
FROM maven:3.9.11-eclipse-temurin-17-alpine AS build
WORKDIR /app
# Copy the project files
COPY . .
# Package the application (use -f to use the correct pom if not in root, otherwise omit)
RUN mvn clean package -DskipTests

# --- Stage 2: Create the final image ---
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Copy the built JAR from the 'build' stage
COPY --from=build /app/target/myapp.jar myapp.jar
# The application runs by default from /app
ENTRYPOINT ["java","-jar","myapp.jar"]
