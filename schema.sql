-- Схема БД "Мониторинг сети"

DROP TABLE IF EXISTS alerts, incidents, metrics, engineers, metric_types, nodes;

-- 1. типы метрик
CREATE TABLE metric_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    unit VARCHAR(20),
    threshold_critical FLOAT,
    threshold_warning FLOAT
);

-- 2. Узлы сети
CREATE TABLE nodes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    ip_address INET UNIQUE NOT NULL,
    node_type VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Собранные метрики
CREATE TABLE metrics (
    id SERIAL PRIMARY KEY,
    node_id INTEGER NOT NULL REFERENCES nodes(id) ON DELETE CASCADE,
    metric_type_id INTEGER NOT NULL REFERENCES metric_types(id),
    value FLOAT NOT NULL CHECK (value >= 0),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Дежурные инженеры
CREATE TABLE engineers (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) DEFAULT 'junior' CHECK (role IN ('junior', 'senior', 'team_lead')),
    is_active BOOLEAN DEFAULT TRUE
);

-- 5. Аварии
CREATE TABLE incidents (
    id SERIAL PRIMARY KEY,
    node_id INTEGER NOT NULL REFERENCES nodes(id),
    metric_id INTEGER REFERENCES metrics(id),
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('critical', 'warning', 'info')),
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'acknowledged', 'resolved', 'closed')),
    description TEXT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    resolved_by INTEGER REFERENCES engineers(id),
    CONSTRAINT chk_resolution_time CHECK (resolved_at IS NULL OR resolved_at > started_at)
);

-- 6. Оповещения
CREATE TABLE alerts (
    id SERIAL PRIMARY KEY,
    incident_id INTEGER NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    engineer_id INTEGER NOT NULL REFERENCES engineers(id),
    channel VARCHAR(20) NOT NULL CHECK (channel IN ('email', 'sms', 'telegram', 'MAX')),
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivered BOOLEAN DEFAULT FALSE
);

-- Индексы (минимум 2 для оценки 4)

CREATE INDEX idx_metrics_node_time ON metrics(node_id, recorded_at);
CREATE INDEX idx_incidents_status_severity ON incidents(status, severity);
CREATE INDEX idx_alerts_sent_at ON alerts(sent_at);