# Price Ingestion Service

ETL-сервис для автоматической обработки и нормализации прайс-листов поставщиков  
(разные форматы Excel → единый формат + сохранение в PostgreSQL)

### Технологии
- Java 25 LTS
- Spring Boot 3.3
- PostgreSQL 16
- Apache POI 5.3
- Flyway
- Docker

### Как запустить
```bash
# 1. Поднять базу
docker-compose up -d

# 2. Запустить приложение
./mvnw spring-boot:run
# или просто запустить PriceProcessorApplication в IntelliJ IDEA