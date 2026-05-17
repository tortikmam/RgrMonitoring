-- 1. Типы метрик (id: 1-4)
INSERT INTO metric_types (name, unit, threshold_critical, threshold_warning) VALUES
('cpu_usage', '%', 90.0, 75.0),
('memory_usage', '%', 95.0, 80.0),
('ping', 'ms', 500.0, 200.0),
('temperature', '°C', 80.0, 60.0);

-- 2. Узлы (id: 1-6)
INSERT INTO nodes (name, ip_address, node_type, location, status) VALUES
('Router-Moscow-01', '192.168.1.1', 'router', 'Москва, ЦОД-3', 'active'),
('Server-SP-02', '192.168.1.10', 'server', 'Санкт-Петербург', 'active'),
('Switch-Kazan-01', '192.168.2.1', 'switch', 'Казань', 'active'),
('BaseStation-Nov-01', '10.0.1.1', 'base_station', 'Новосибирск', 'inactive'),
('Router-Moscow-02', '192.168.1.2', 'router', 'Москва, ЦОД-3', 'maintenance'),
('Server-Ekat-01', '192.168.3.10', 'server', 'Екатеринбург', 'active');

-- 3. Инженеры (id: 1-3)
INSERT INTO engineers (full_name, email, phone, role, is_active) VALUES
('Иванов Петр', 'ivanov@company.ru', '+79001234567', 'senior', true),
('Сидорова Анна', 'sidorova@company.ru', '+79007654321', 'junior', true),
('Петров Дмитрий', 'petrov@company.ru', '+79005551122', 'team_lead', true);

-- 4. Метрики (id: 1-18)
INSERT INTO metrics (node_id, metric_type_id, value, recorded_at) VALUES
-- Router-Moscow-01 (node_id=1): id 1-3
(1, 1, 45.5, '2026-05-15 10:00:00'),
(1, 3, 12.0, '2026-05-15 10:00:00'),
(1, 4, 55.0, '2026-05-15 10:00:00'),
-- Server-SP-02 (node_id=2): id 4-6
(2, 1, 92.3, '2026-05-15 10:05:00'),
(2, 2, 88.0, '2026-05-15 10:05:00'),
(2, 3, 45.0, '2026-05-15 10:05:00'),
-- Switch-Kazan-01 (node_id=3): id 7-9
(3, 1, 30.0, '2026-05-15 10:10:00'),
(3, 3, 8.0, '2026-05-15 10:10:00'),
(3, 4, 42.0, '2026-05-15 10:10:00'),
-- BaseStation-Nov-01 (node_id=4): id 10-12
(4, 1, 10.0, '2026-05-10 08:00:00'),
(4, 3, 600.0, '2026-05-10 08:00:00'),
(4, 4, 85.0, '2026-05-10 08:00:00'),
-- Server-Ekat-01 (node_id=6): id 13-15
(6, 1, 67.0, '2026-05-15 10:15:00'),
(6, 2, 45.0, '2026-05-15 10:15:00'),
(6, 3, 25.0, '2026-05-15 10:15:00'),
-- Дополнительные для аналитики: id 16-18
(1, 1, 78.0, '2026-05-14 10:00:00'),
(1, 1, 95.0, '2026-05-13 10:00:00'),
(2, 1, 88.0, '2026-05-14 10:05:00');

-- 5. Аварии
INSERT INTO incidents (node_id, metric_id, severity, status, description, started_at, resolved_at, resolved_by) VALUES
(2, 5, 'critical', 'open', 'CPU превысил 90%', '2026-05-15 10:05:00', NULL, NULL),
(4, 12, 'critical', 'acknowledged', 'Базовая станция недоступна, высокая температура', '2026-05-10 08:00:00', NULL, NULL),
(1, 16, 'warning', 'closed', 'CPU высокий, но в пределах', '2026-05-14 10:00:00', '2026-05-14 12:00:00', 1),
(1, 17, 'critical', 'closed', 'CPU критический, перезагрузка', '2026-05-13 10:00:00', '2026-05-13 10:30:00', 1),
(2, 18, 'warning', 'closed', 'CPU загружен', '2026-05-14 10:05:00', '2026-05-14 11:00:00', 2),
(3, 8, 'warning', 'closed', 'Ping нестабильный', '2026-05-15 10:10:00', '2026-05-15 10:20:00', 1),
(6, 14, 'warning', 'open', 'Memory usage растёт', '2026-05-01 09:00:00', NULL, NULL),
(3, 9, 'info', 'closed', 'Температура в норме после обслуживания', '2026-05-15 10:10:00', '2026-05-15 10:15:00', 3);

-- 6. Оповещения (incident_id только 1-8!)
INSERT INTO alerts (incident_id, engineer_id, channel, sent_at, delivered) VALUES
(1, 1, 'email', '2026-05-15 10:06:00', true),
(1, 1, 'sms', '2026-05-15 10:06:30', true),
(2, 3, 'telegram', '2026-05-10 08:05:00', true),
(2, 1, 'email', '2026-05-10 08:05:00', false),
(3, 1, 'email', '2026-05-14 10:01:00', true),
(4, 1, 'sms', '2026-05-13 10:01:00', true),
(5, 2, 'email', '2026-05-14 10:06:00', true),
(6, 1, 'telegram', '2026-05-15 10:11:00', true),
(7, 2, 'email', '2026-05-01 09:05:00', false),
(8, 3, 'email', '2026-05-15 10:12:00', true);