# ---- Step 1: build the project ----
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -q package -DskipTests

# ---- Step 2: run the project ----
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/resume-analyzer.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-Xmx350m", "-jar", "app.jar"]