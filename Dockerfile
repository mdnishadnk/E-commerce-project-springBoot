# ----------------------------------------------------------------------
# Single Stage Build (Windows Nanoserver)
# ----------------------------------------------------------------------

# NOTE: This requires your Docker daemon and Jenkins agent to be configured
# for Windows containers. This is a large image.
FROM ubuntu

# Set the working directory (Windows path style)
WORKDIR /app

# Define the artifact name produced by Maven (Adjust this to your project's name)
# NOTE: This assumes your JAR is built on the host and copied in the build context.
ARG JAR_FILE="E-commerce-project-springBoot-0.0.1-SNAPSHOT.jar"

# Copy the pre-built JAR file from the host machine's target folder
# NOTE: Windows path separation is often done with backslashes in commands.
COPY target/%JAR_FILE% C:/app/app.jar

# Set the port the application runs on
EXPOSE 8081

# Command to run the application when the container starts
# Use powershell for the entrypoint in Windows containers
ENTRYPOINT ["java", "-jar", "C:/app/app.jar"]
