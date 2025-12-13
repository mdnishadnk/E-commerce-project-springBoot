# ----------------------------------------------------------------------
# Stage 1: Build Stage (Name it something specific like 'mvnbuild')
# ----------------------------------------------------------------------
FROM maven:3-openjdk-17 AS mvnbuild

WORKDIR /app
COPY pom.xml .
COPY src /app/src

RUN mvn clean package -DskipTests
ARG JAR_FILE=target/E-commerce-project-springBoot-0.0.1-SNAPSHOT.jar


# ----------------------------------------------------------------------
# Stage 2: Final (Runtime) Stage
# ----------------------------------------------------------------------
FROM openjdk:17-jre-slim

EXPOSE 8081
WORKDIR /app

# 🛑 FIX APPLIED HERE: Referencing the named stage 'mvnbuild'
COPY --from=mvnbuild /app/${JAR_FILE} app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
