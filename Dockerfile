# ----------------------------------------------------------------------------------
# Stage 1: Build Stage (Uses a full JDK/Maven image to compile the Java application)
# ----------------------------------------------------------------------------------
FROM maven:latest

# Create and set the working directory inside the container
WORKDIR /app

# Copy the Maven project file (pom.xml) first to leverage Docker layer caching
COPY pom.xml .

# Copy the source code
COPY src /app/src

# Run the full Maven build. This creates the final JAR file in target/
# We explicitly skip tests here, as they should have run in the Jenkins Test stage.
RUN mvn clean package -DskipTests

# Define the JAR file path for the next stage based on your project structure
# NOTE: This name MUST match the output of your Maven build process (check your pom.xml artifactId)
ARG JAR_FILE=target/E-commerce-project-springBoot-0.0.1-SNAPSHOT.jar


# ----------------------------------------------------------------------------------
# Stage 2: Final (Runtime) Stage (Uses a minimal JRE image for security and size)
# ----------------------------------------------------------------------------------
FROM openjdk:17-jre-slim

# Set the external port (Spring Boot default)
EXPOSE 8081

# Create the application directory
WORKDIR /app

# Copy the final JAR file from the 'build' stage into the lightweight 'Final' stage
# The 'build' stage environment variables are not available here, so we copy by path
COPY --from=build /app/${JAR_FILE} app.jar

# Define the command to run the application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
