# Діагностика та вирішення проблем

## Загальні проблеми

### 1. Проблеми з підключенням пристроїв

#### Симптоми
- Пристрій не з'являється в системі
- Дані не надходять
- Помилки автентифікації

#### Діагностика
```bash
# Перевірка мережевого з'єднання
ping your-thingsboard-host

# Перевірка портів
nc -zv your-thingsboard-host 1883  # MQTT
nc -zv your-thingsboard-host 8080  # HTTP
nc -zv your-thingsboard-host 5683  # CoAP

# Аналіз трафіку
tcpdump -i any port 1883 -w debug.pcap
```

#### Рішення
1. Перевірте облікові дані пристрою
2. Переконайтеся, що порти відкриті
3. Перевірте формат даних
4. Перевірте налаштування SSL/TLS

### 2. Проблеми з Rule Chain

#### Симптоми
- Правила не спрацьовують
- Втрата повідомлень
- Неправильна обробка даних

#### Діагностика
```javascript
// Додайте вузли Debug
{
  // На вході вузла
  msg: {
    temperature: 25,
    humidity: 60
  },
  metadata: {
    deviceName: "sensor1",
    deviceType: "thermometer"
  }
}

// Після трансформації
{
  temp_c: msg.temperature,
  temp_f: msg.temperature * 9/5 + 32,
  humidity: msg.humidity
}
```

#### Рішення
1. Перевірте умови фільтрів
2. Додайте логування
3. Перевірте формат даних
4. Перевірте з'єднання між вузлами

### 3. Проблеми з продуктивністю

#### Симптоми
- Повільна робота інтерфейсу
- Затримки в обробці даних
- Високе навантаження на CPU/RAM

#### Діагностика
```bash
# Моніторинг системи
top -b -n 1 | grep java

# Аналіз використання пам'яті
jmap -heap PID

# Перевірка навантаження на БД
psql -U postgres thingsboard -c "
SELECT schemaname, relname, n_live_tup, n_dead_tup
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;
"
```

#### Рішення
1. Оптимізація запитів
2. Налаштування кешування
3. Очищення старих даних
4. Масштабування системи

### 4. Проблеми з інтеграціями

#### Modbus
```yaml
# Типові помилки
errors:
  - code: "CONNECTION_REFUSED"
    solution: "Перевірте IP-адресу та порт"
  - code: "TIMEOUT"
    solution: "Збільште timeout або перевірте мережу"
  - code: "INVALID_DATA"
    solution: "Перевірте конфігурацію регістрів"

# Діагностика
debug:
  - command: "modpoll -m tcp -a 1 -r 30001 -c 1 192.168.1.100"
  - wireshark: "modbus.tcp"
```

#### OPC UA
```yaml
# Типові помилки
errors:
  - code: "BAD_IDENTITY_TOKEN_REJECTED"
    solution: "Перевірте облікові дані"
  - code: "BAD_SECURITY_CHECKS_FAILED"
    solution: "Перевірте налаштування безпеки"
  - code: "BAD_TIMEOUT"
    solution: "Збільште timeout"

# Діагностика
debug:
  - tool: "UaExpert"
  - wireshark: "opcua.tcp"
```

## Діагностика системи енергомоніторингу

### 1. Проблеми з лічильниками

#### Симптоми
- Відсутність даних
- Некоректні показання
- Пропуски в даних
- Затримки в передачі

#### Діагностика
```bash
# Перевірка зв'язку з лічильником Modbus
modpoll -m tcp -t 3 -r 30001 -c 10 192.168.1.100

# Аналіз якості даних
SELECT date_trunc('hour', ts) as hour,
       count(*) as samples,
       avg(value) as avg_value,
       stddev(value) as stddev_value
FROM ts_kv
WHERE key = 'activeEnergy'
  AND ts >= NOW() - INTERVAL '24 hours'
GROUP BY date_trunc('hour', ts)
ORDER BY hour;

# Перевірка затримок
SELECT device_id,
       extract(epoch from (now() - MAX(ts)))::integer as seconds_since_last_data
FROM ts_kv
GROUP BY device_id
HAVING extract(epoch from (now() - MAX(ts)))::integer > 300;
```

#### Рішення
1. Перевірте фізичне підключення
2. Налаштуйте параметри зв'язку
3. Встановіть правильні регістри
4. Налаштуйте період опитування

### 2. Проблеми з розрахунками EnPI

#### Симптоми
- Некоректні показники
- Відхилення від очікуваних значень
- Проблеми з базовою лінією

#### Діагностика
```javascript
// Перевірка розрахунків
function validateEnPICalculations(data) {
  var validation = {
    // Перевірка вхідних даних
    inputs: validateInputData(data),
    
    // Перевірка розрахунків
    calculations: {
      specificEnergy: validateSpecificEnergy(data),
      baseline: validateBaselineComparison(data),
      improvement: validateImprovement(data)
    },
    
    // Перевірка результатів
    results: validateResults(data)
  };
  
  return generateValidationReport(validation);
}

// Аналіз відхилень
function analyzeDeviations(data, baseline) {
  return {
    absolute: data.value - baseline.value,
    relative: (data.value - baseline.value) / baseline.value * 100,
    normalized: normalizeDeviation(data, baseline),
    factors: analyzeInfluencingFactors(data, baseline)
  };
}
```

#### Рішення
1. Перевірте формули розрахунків
2. Оновіть базову лінію
3. Врахуйте всі фактори впливу
4. Налаштуйте нормалізацію даних

### 3. Проблеми з верифікацією

#### Симптоми
- Низька якість даних
- Проблеми з точністю
- Невідповідність стандартам

#### Діагностика
```javascript
// Перевірка якості даних
function checkDataQuality(data) {
  return {
    // Повнота даних
    completeness: {
      expectedSamples: calculateExpectedSamples(data.period),
      actualSamples: countActualSamples(data),
      missingData: findMissingData(data)
    },
    
    // Точність
    accuracy: {
      measurements: validateMeasurements(data),
      calculations: validateCalculations(data),
      uncertainties: calculateUncertainties(data)
    },
    
    // Консистентність
    consistency: {
      timeSeriesAnalysis: analyzeTimeSeries(data),
      crossValidation: performCrossValidation(data),
      logicalChecks: performLogicalChecks(data)
    }
  };
}

// Аналіз невизначеності
function analyzeUncertainty(data) {
  return {
    measurement: calculateMeasurementUncertainty(data),
    modeling: calculateModelingUncertainty(data),
    combined: calculateCombinedUncertainty(data),
    expanded: calculateExpandedUncertainty(data, 0.95)
  };
}
```

#### Рішення
1. Покращіть якість вимірювань
2. Оновіть методологію верифікації
3. Документуйте процедури
4. Проведіть калібрування

### 4. Проблеми з оптимізацією

#### Симптоми
- Неефективне споживання
- Високі питомі показники
- Недосягнення цілей економії

#### Діагностика
```javascript
// Аналіз ефективності
function analyzeEfficiency(data) {
  return {
    // Аналіз режимів роботи
    operationalModes: {
      current: analyzeCurrentMode(data),
      optimal: calculateOptimalMode(data),
      potential: calculatePotential(data)
    },
    
    // Аналіз втрат
    losses: {
      technical: calculateTechnicalLosses(data),
      operational: calculateOperationalLosses(data),
      avoidable: identifyAvoidableLosses(data)
    },
    
    // Можливості оптимізації
    opportunities: {
      immediate: findImmediateOpportunities(data),
      shortTerm: findShortTermOpportunities(data),
      longTerm: findLongTermOpportunities(data)
    }
  };
}

// Оцінка потенціалу економії
function assessSavingsPotential(data) {
  return {
    technical: calculateTechnicalPotential(data),
    economic: calculateEconomicPotential(data),
    achievable: calculateAchievablePotential(data),
    roi: calculateROI(data)
  };
}
```

#### Рішення
1. Оптимізуйте режими роботи
2. Впровадьте автоматизацію
3. Навчіть персонал
4. Встановіть чіткі KPI

## Помилки баз даних

### 1. PostgreSQL
```sql
-- Перевірка блокувань
SELECT blocked_locks.pid AS blocked_pid,
       blocking_locks.pid AS blocking_pid,
       blocked_activity.usename AS blocked_user,
       blocking_activity.usename AS blocking_user
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_locks blocking_locks 
    ON blocking_locks.locktype = blocked_locks.locktype
WHERE NOT blocked_locks.granted;

-- Очищення невикористаних індексів
SELECT schemaname || '.' || tablename AS table_name,
       indexname AS index_name,
       idx_scan as index_scans
FROM pg_catalog.pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY schemaname, tablename;
```

### 2. Cassandra
```bash
# Перевірка статусу кластера
nodetool status

# Відновлення вузла
nodetool repair

# Очищення
nodetool cleanup
```

## Проблеми з UI

### 1. Повільне завантаження
- Оптимізуйте запити
- Використовуйте пагінацію
- Кешуйте дані
- Зменшіть розмір відповідей

### 2. Проблеми з віджетами
```javascript
// Діагностика віджетів
{
  // Перевірка підписки на дані
  subscription: {
    type: "timeseries",
    timewindow: {
      realtime: {
        timewindowMs: 3600000
      }
    }
  },
  
  // Перевірка конфігурації
  datasources: [{
    type: "entity",
    entityAliasId: "abc123",
    dataKeys: [{
      name: "temperature",
      type: "timeseries"
    }]
  }]
}
```

## Рекомендації з безпеки

### 1. Аудит безпеки
```bash
# Перевірка відкритих портів
nmap -sS -sV your-thingsboard-host

# Перевірка SSL
openssl s_client -connect your-thingsboard-host:443 -tls1_2

# Перевірка журналів
grep "Failed login attempt" /var/log/thingsboard/thingsboard.log
```

### 2. Захист від атак
- Налаштуйте брандмауер
- Використовуйте HTTPS
- Обмежте доступ за IP
- Моніторте підозрілу активність

## Оновлення системи

### 1. Підготовка до оновлення
```bash
# Резервне копіювання
backup_dir="/backup/thingsboard/$(date +%Y%m%d)"
mkdir -p $backup_dir

# База даних
pg_dump -U postgres thingsboard > $backup_dir/db.sql

# Конфігурація
cp -r /etc/thingsboard $backup_dir/
cp -r /var/lib/thingsboard/data $backup_dir/
```

### 2. Процес оновлення
```bash
# Зупинка сервісу
systemctl stop thingsboard

# Оновлення пакетів
apt update
apt install thingsboard

# Оновлення схеми БД
/usr/share/thingsboard/bin/install/upgrade.sh --fromVersion=3.3.1

# Запуск сервісу
systemctl start thingsboard
```
