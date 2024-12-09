# Часті запитання (FAQ)

## Загальні питання

### 1. Як налаштувати з'єднання з пристроями?
Для підключення пристроїв до ThingsBoard:
1. Створіть пристрій в ThingsBoard
2. Отримайте облікові дані доступу
3. Налаштуйте протокол зв'язку (MQTT, HTTP, CoAP)
4. Використовуйте відповідні бібліотеки для вашої платформи

### 2. Як організувати ієрархію активів?
- Створіть структуру активів відповідно до вашої організації
- Використовуйте теги для групування
- Налаштуйте відносини між активами
- Призначте пристрої до відповідних активів

### 3. Як налаштувати тривоги?
1. Створіть правило в Rule Chain
2. Визначте умови спрацювання
3. Налаштуйте дії при спрацюванні
4. Встановіть пріоритети та часові параметри

### 4. Як оптимізувати продуктивність?
- Використовуйте відповідні типи баз даних
- Налаштуйте політику зберігання даних
- Оптимізуйте запити
- Використовуйте кешування

## Технічні питання

### 1. Проблеми з підключенням

#### MQTT
```bash
# Перевірка з'єднання
mosquitto_pub -d -h "your-thingsboard-host" -p 1883 -t "v1/devices/me/telemetry" \
-m "{"temperature": 25}" --username "YOUR_ACCESS_TOKEN"

# Налагодження з'єднання
tcpdump -i any port 1883 -w mqtt_debug.pcap
```

#### HTTP
```bash
# Тестування REST API
curl -v -X POST http://your-thingsboard-host/api/v1/YOUR_ACCESS_TOKEN/telemetry \
--header "Content-Type:application/json" \
--data '{"temperature": 25}'
```

### 2. Діагностика Rule Chain
- Перевірте журнали подій
- Використовуйте вузли Debug
- Перевірте конфігурацію фільтрів
- Відстежуйте метадані повідомлень

### 3. Оптимізація запитів
```sql
-- Оптимізація запитів часових рядів
SELECT date_trunc('hour', ts) as hour,
       avg(value) as avg_value
FROM ts_kv
WHERE key = 'temperature'
  AND ts >= NOW() - INTERVAL '24 hours'
GROUP BY date_trunc('hour', ts)
ORDER BY hour;

-- Індексація
CREATE INDEX ts_kv_ts_idx ON ts_kv (ts);
```

## Інтеграція

### 1. Modbus
```yaml
# Приклад конфігурації Modbus
configuration:
  devices:
    - name: "PLC1"
      type: "Master"
      transport: "TCP"
      host: "192.168.1.100"
      port: 502
      pollPeriod: 1000
      timeout: 3000
      retries: 3
      registers:
        - name: "Temperature"
          type: "InputRegister"
          address: 30001
          registerCount: 1
          byteOrder: "BigEndian"
```

### 2. OPC UA
```yaml
# Приклад конфігурації OPC UA
configuration:
  servers:
    - applicationName: "ThingsBoard OPC UA Client"
      applicationUri: "urn:thingsboard:client"
      serverHost: "192.168.1.100"
      serverPort: 4840
      securityPolicy: "None"
      identity:
        type: "anonymous"
      mapping:
        - nodeId: "ns=2;s=Device1.Temperature"
          timeseries: "temperature"
```

### 3. REST API
```bash
# Аутентифікація
curl -X POST http://your-thingsboard-host/api/auth/login \
-d '{"username":"tenant@thingsboard.org", "password":"tenant"}' \
-H "Content-Type:application/json"

# Отримання даних пристрою
curl -X GET http://your-thingsboard-host/api/device/{deviceId}/credentials \
-H "X-Authorization: Bearer $JWT_TOKEN"
```

## Безпека

### 1. Налаштування SSL/TLS
```bash
# Генерація сертифікатів
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365

# Налаштування MQTT over TLS
mosquitto_pub -d -h "your-thingsboard-host" -p 8883 \
--cafile cert.pem \
-t "v1/devices/me/telemetry" \
-m "{"temperature": 25}" \
--username "YOUR_ACCESS_TOKEN"
```

### 2. Керування доступом
- Налаштуйте ролі та дозволи
- Використовуйте групи користувачів
- Регулярно оновлюйте паролі
- Моніторте активність користувачів

## Обслуговування

### 1. Резервне копіювання
```bash
# Backup PostgreSQL
pg_dump -U postgres thingsboard > backup.sql

# Backup Cassandra
nodetool snapshot thingsboard

# Backup конфігурації
tar -czf tb-data.tar.gz /var/lib/thingsboard/data
```

### 2. Моніторинг системи
```bash
# Перевірка використання ресурсів
top -b -n 1 | grep java

# Моніторинг диску
df -h /var/lib/thingsboard

# Перевірка журналів
tail -f /var/log/thingsboard/thingsboard.log
```

## Питання з енергоефективності

### 1. Як налаштувати систему згідно ISO 50001?
- Визначте енергетичну політику
- Встановіть базову лінію споживання
- Налаштуйте збір даних з лічильників
- Створіть систему EnPI
- Налаштуйте звітність

### 2. Як розрахувати показники EnPI?
```javascript
// Приклад розрахунку EnPI
function calculateEnPI(data) {
  return {
    specificEnergy: data.energy / data.production,
    energyBaseline: compareToBaseline(data),
    performanceImprovement: calculateImprovement(data)
  };
}
```

### 3. Як налаштувати верифікацію даних?
- Встановіть правила валідації
- Налаштуйте перевірку якості даних
- Визначте методологію розрахунків
- Встановіть процедури верифікації
- Документуйте результати

### 4. Як інтегрувати лічильники?
```yaml
# Приклад конфігурації Modbus
configuration:
  device:
    type: "PowerMeter"
    protocol: "Modbus TCP"
    parameters:
      - register: 30001
        type: "FLOAT32"
        name: "ActivePower"
      - register: 30003
        type: "FLOAT32"
        name: "Energy"
```

### 5. Як налаштувати звітність?
- Визначте періодичність звітів
- Налаштуйте шаблони
- Встановіть KPI
- Налаштуйте автоматичну розсилку
- Створіть дашборди
