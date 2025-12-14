# Stage 1: Build with Maven
FROM maven:3.9.11-eclipse-temurin-17-alpine AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run with JRE
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/myapp.jar myapp.jar
CMD ["java", "-jar", "myapp.jar"]
