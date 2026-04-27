FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests -B

FROM eclipse-temurin:17-jre

WORKDIR /app

RUN groupadd -r healthsys && useradd -r -g healthsys healthsys
USER healthsys

COPY --from=build /app/target/api-gateway-*.jar app.jar

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=docker
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379
ENV EUREKA_URL=http://eureka-server:8761/eureka

ENTRYPOINT ["java", "-jar", "app.jar"]