
-- 1.Список всех узлов с типом и статусом
-- Задача: получить полный реестр оборудования
SELECT 
    id,
    name,
    ip_address,
    node_type,
    location,
    status
FROM nodes
ORDER BY node_type, name;


-- 2.Узлы в статусе 'inactive'
-- Задача: найти недоступное оборудование
SELECT 
    id,
    name,
    ip_address,
    node_type,
    location
FROM nodes
WHERE status = 'inactive';


-- 3. Средняя загрузка CPU по узлам
-- Задача: узнать среднюю нагрузку процессора
SELECT 
    n.name AS node_name,
    AVG(m.value) AS avg_cpu
FROM nodes n
JOIN metrics m ON n.id = m.node_id
JOIN metric_types mt ON m.metric_type_id = mt.id
WHERE mt.name = 'cpu_usage'
GROUP BY n.id, n.name
ORDER BY avg_cpu DESC;


-- 4. Узлы с количеством аварий > 1
-- Задача: найти проблемные узлы (часто ломаются)
SELECT 
    n.name,
    COUNT(i.id) AS incident_count
FROM nodes n
JOIN incidents i ON n.id = i.node_id
GROUP BY n.id, n.name
HAVING COUNT(i.id) > 1;


-- 5.Аварии с информацией об узле и метрике
-- Задача: полная картина по каждой аварии
SELECT 
    i.id,
    n.name AS node_name,
    n.ip_address,
    mt.name AS metric_type,
    m.value AS metric_value,
    i.severity,
    i.status,
    i.description,
    i.started_at
FROM incidents i
JOIN nodes n ON i.node_id = n.id
LEFT JOIN metrics m ON i.metric_id = m.id
LEFT JOIN metric_types mt ON m.metric_type_id = mt.id
ORDER BY i.started_at DESC;


-- 6.Аварии с информацией об узле
-- Задача: полная информация об авариях с названиями узлов
WITH incident_nodes AS (
    SELECT 
        i.id,
        i.severity,
        i.status,
        i.description,
        i.started_at,
        n.name AS node_name
    FROM incidents i
    JOIN nodes n ON i.node_id = n.id
)
SELECT 
    id AS incident_id,
    node_name,
    severity,
    status,
    description,
    started_at
FROM incident_nodes
ORDER BY started_at DESC;


-- 7. Топ-5 узлов по среднему пингу
-- Задача: найти узлы с наихудшей сетевой задержкой
SELECT 
    n.name AS node_name,
    AVG(m.value) AS avg_ping_ms
FROM nodes n
JOIN metrics m ON n.id = m.node_id
JOIN metric_types mt ON m.metric_type_id = mt.id
WHERE mt.name = 'ping'
GROUP BY n.id, n.name
ORDER BY avg_ping_ms DESC
LIMIT 5;


-- 8.Аварии за 2026 год
-- Задача: статистика динамики аварийности
SELECT 
    started_at,
    description,
    severity,
    status
FROM incidents
WHERE started_at >= '2026-01-01' AND started_at < '2027-01-01'
ORDER BY started_at;


-- 9. Сколько оповещений у каждого инженера
-- Задача: нагрузка на инженеров

SELECT 
    e.full_name,
    COUNT(a.id) AS alert_count
FROM engineers e
LEFT JOIN alerts a ON e.id = a.engineer_id
GROUP BY e.id, e.full_name
ORDER BY alert_count DESC;


-- 10. Открытые критические аварии
-- Задача: требуют немедленного вмешательства
SELECT 
    i.id,
    n.name AS node_name,
    i.description,
    i.started_at
FROM incidents i
JOIN nodes n ON i.node_id = n.id
WHERE i.status = 'open'
  AND i.severity = 'critical'
ORDER BY i.started_at;