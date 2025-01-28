# Stage 1: Build the application
FROM gradle:8.10.2-jdk21 AS build

# Add GitHub credentials as build arguments
ARG GITHUB_USERNAME
ARG GITHUB_TOKEN

# Ensure Git is installed in the Gradle image
RUN apt-get update && apt-get install -y git

# Clone the repository using GitHub credentials with shallow clone (--depth 1)
RUN git clone --depth 1 https://github.com/aronvaupel/discovery-service.git /home/gradle/src

WORKDIR /home/gradle/src

# Ensure necessary Gradle wrapper and files have execution permissions
RUN chmod +x gradlew

# Build the project with Gradle
RUN ./gradlew clean build --no-daemon

# Stage 2: Create a smaller image for running the application
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

RUN apk update && \
    apk add --no-cache curl

# Copy the built jar from the previous stage
COPY --from=build /home/gradle/src/build/libs/*.jar app.jar

# Expose the Eureka port
EXPOSE 8761

# Healthcheck to ensure Eureka is running
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -f http://localhost:8761/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
