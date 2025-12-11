-- V1__initial_schema.sql
-- Описание: Первая миграция — создаёт все базовые таблицы для проекта.
-- Зачем: Flyway запустит это автоматически при старте приложения.
-- Как работает: Spring Boot увидит файл, выполнит SQL и отметит как "выполнено".
-- Важно: Всегда используй транзакции, индексы для производительности.

-- Включаем расширения для UUID и JSON (если нужно позже)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Таблица поставщиков (справочник)
CREATE TABLE suppliers (
    code VARCHAR(10) PRIMARY KEY,  -- Код поставщика, напр. 'SUPA'
    name VARCHAR(255) NOT NULL,    -- Полное название
    active BOOLEAN DEFAULT true,   -- Активен ли
    parser_bean_name VARCHAR(100), -- Имя бина парсера в Spring
    use_cbr_rate BOOLEAN DEFAULT true,  -- Использовать курс ЦБ или свой
    default_currency VARCHAR(3) DEFAULT 'RUB',  -- Валюта по умолчанию
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица логов обработки файлов
CREATE TABLE processing_log (
    id BIGSERIAL PRIMARY KEY,
    original_filename VARCHAR(500) NOT NULL,
    supplier_code VARCHAR(10) REFERENCES suppliers(code),
    status VARCHAR(20) DEFAULT 'NEW' CHECK (status IN ('NEW', 'PROCESSING', 'SUCCESS', 'ERROR')),
    rows_read INTEGER,
    rows_written INTEGER,
    error_message TEXT,
    processed_at TIMESTAMP,
    file_path VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица нормализованных цен
CREATE TABLE normalized_prices (
    id BIGSERIAL PRIMARY KEY,
    article VARCHAR(100) NOT NULL,
    name VARCHAR(500) NOT NULL,
    brand VARCHAR(100),
    manufacturer VARCHAR(200),
    price_type VARCHAR(10) NOT NULL CHECK (price_type IN ('RETAIL', 'DEALER')),  -- Тип цены
    price NUMERIC(12,2) NOT NULL,  -- Цена в валюте прайса
    currency VARCHAR(3) DEFAULT 'RUB' CHECK (currency IN ('RUB', 'USD', 'EUR')),
    price_rub NUMERIC(12,2),  -- Цена в рублях после пересчёта
    quantity INTEGER,
    supplier_code VARCHAR(10) REFERENCES suppliers(code),
    price_date DATE NOT NULL,
    processing_log_id BIGINT REFERENCES processing_log(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(article, supplier_code, price_type, price_date)  -- Уникальность
);

-- Таблица курсов поставщиков (если не ЦБ)
CREATE TABLE supplier_exchange_rates (
    id BIGSERIAL PRIMARY KEY,
    supplier_code VARCHAR(10) REFERENCES suppliers(code),
    currency VARCHAR(3) NOT NULL,
    rate NUMERIC(10,4) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    source VARCHAR(20) DEFAULT 'SUPPLIER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица курсов ЦБ РФ
CREATE TABLE cbr_exchange_rates (
    id BIGSERIAL PRIMARY KEY,
    currency VARCHAR(3) NOT NULL,
    rate NUMERIC(10,4) NOT NULL,
    rate_date DATE NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Индексы для скорости запросов
CREATE INDEX idx_normalized_prices_article_supplier ON normalized_prices(article, supplier_code);
CREATE INDEX idx_normalized_prices_date ON normalized_prices(price_date);
CREATE INDEX idx_processing_log_status ON processing_log(status);

-- Начальные данные: добавляем тестового поставщика
INSERT INTO suppliers (code, name, parser_bean_name, default_currency)
VALUES 
    ('TEST', 'Тестовый Поставщик', 'testSupplierParser', 'RUB'),
    ('SUPA', 'Поставщик A', 'supplierAParser', 'USD');  -- Пример с USD

-- Коммит миграции (Flyway сделает автоматически)