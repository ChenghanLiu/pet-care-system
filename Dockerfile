FROM docker.1ms.run/maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml ./
COPY src ./src

RUN mvn -q -DskipTests package

FROM docker.1ms.run/eclipse-temurin:17-jre
WORKDIR /app

COPY --from=builder /app/target/*.jar /app/app.jar

RUN mkdir -p /app/uploads

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]