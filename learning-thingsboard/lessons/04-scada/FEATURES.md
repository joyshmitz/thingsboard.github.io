Переваги:
  - Модульна архітектура
  - Горизонтальне масштабування
  - Підтримка хмарного та локального розгортання
  - Можливість поступового розширення системи

Приклади використання:
  - Моніторинг одного процесу
  - Контроль цілого підприємства
  - Управління розподіленими об'єктами
```

### 2. Інтеграція з обладнанням
```yaml
Підтримувані протоколи:
  Промислові:
    - Modbus RTU/TCP
    - OPC UA
    - BACnet
    - Siemens S7
    - Profinet
    
  IoT:
    - MQTT
    - HTTP
    - CoAP
    - LwM2M
    
  Спеціалізовані:
    - LoRaWAN
    - Sigfox
    - NB-IoT
```

### 3. Візуалізація даних

#### 3.1. Промислові символи
```yaml
Бібліотека символів:
  Технологічне обладнання:
    - Насоси
    - Двигуни
    - Частотники
    - Клапани
    - Резервуари
    
  Вимірювальні прилади:
    - Датчики
    - Витратоміри
    - Рівнеміри
    
  Транспортні системи:
    - Конвеєри
    - Елеватори
    - Шнеки
```

#### 3.2. Динамічні елементи
```yaml
Типи анімації:
  - Обертання
  - Заповнення
  - Зміна кольору
  - Мерехтіння
  - Переміщення

Прив'язка до даних:
  - Пряме значення
  - Діапазони
  - Формули
  - Скрипти
```

#### 3.3. Віджети
```yaml
Базові:
  - Графіки
  - Діаграми
  - Таблиці
  - Індикатори

Спеціалізовані:
  - Мнемосхеми
  - Теплові карти
  - 3D моделі
  - Відео потоки

Користувацькі:
  - React компоненти
  - SVG графіка
  - HTML/CSS/JS
```

### 4. Керування процесами

#### 4.1. Rule Engine
```yaml
Можливості:
  Обробка даних:
    - Фільтрація
    - Агрегація
    - Перетворення
    - Збагачення
  
  Логіка:
    - Умовні оператори
    - Цикли
    - Функції
    - Скрипти
  
  Дії:
    - Керуючі команди
    - Сповіщення
    - API виклики
    - Запис в БД
```

#### 4.2. Сценарії автоматизації
```yaml
Типи сценаріїв:
  Планові:
    - За розкладом
    - По події
    - По умові
    
  Аварійні:
    - Захист обладнання
    - Безпека персоналу
    - Збереження продукту
    
  Оптимізаційні:
    - Енергоефективність
    - Якість продукції
    - Продуктивність
```

### 5. Безпека та надійність

#### 5.1. Система прав доступу
```yaml
Рівні доступу:
  Адміністратори:
    - Повний доступ
    - Налаштування системи
    - Управління користувачами
    
  Оператори:
    - Моніторинг процесів
    - Базове керування
    - Квитування тривог
    
  Технологи:
    - Налаштування параметрів
    - Аналіз даних
    - Звіти

Обмеження:
  - По об'єктах
  - По функціях
  - По часу
  - По локації
```

#### 5.2. Захист даних
```yaml
Методи захисту:
  Шифрування:
    - TLS/SSL
    - VPN
    - Сертифікати
    
  Аутентифікація:
    - Двофакторна
    - LDAP/Active Directory
    - OAuth 2.0
    
  Аудит:
    - Логування дій
    - Історія змін
    - Відстеження доступу
```

### 6. Аналітика та звітність

#### 6.1. Аналіз даних
```yaml
Типи аналізу:
  Реального часу:
    - Поточні значення
    - Тренди
    - Відхилення
    
  Історичний:
    - Статистика
    - Порівняння
    - Кореляції
    
  Предиктивний:
    - Прогнозування відмов
    - Планування ТО
    - Оптимізація режимів
```

#### 6.2. Звіти
```yaml
Формати:
  - PDF
  - Excel
  - HTML
  - CSV

Типи звітів:
  Оперативні:
    - Зміна
    - Доба
    - Тиждень
    
  Аналітичні:
    - Місяць
    - Квартал
    - Рік
    
  Спеціальні:
    - Аварії
    - Простої
    - Якість
```

### 7. Інтеграція з зовнішніми системами

#### 7.1. Типи інтеграцій
```yaml
ERP системи:
  - SAP
  - 1C
  - Microsoft Dynamics

MES системи:
  - Siemens
  - Wonderware
  - AVEVA

Лабораторні системи:
  - LIMS
  - QMS
  - Аналізатори
```

#### 7.2. Методи інтеграції
```yaml
API:
  - REST
  - GraphQL
  - WebSocket

Обмін файлами:
  - FTP
  - SMB
  - Email

Бази даних:
  - SQL
  - NoSQL
  - Часові ряди
```

## Інтеграційні сценарії

### 1. Інтеграція з ODOO

#### 1.1. Архітектура інтеграції
```yaml
Компоненти:
  ThingsBoard:
    - REST API Client
    - Rule Engine для обробки даних
    - Перетворювачі даних
    
  ODOO:
    - REST API Server
    - XML-RPC інтерфейс
    - Модулі інтеграції
    
  Проміжні компоненти:
    - Черги повідомлень (опціонально)
    - Кешування даних
    - Системи логування

Методи інтеграції:
  1. REST API:
     - Прямі HTTP запити
     - JSON формат даних
     - Автентифікація через токени
     
  2. XML-RPC:
     - Віддалені виклики процедур
     - Бінарні дані
     - Сесійна автентифікація
```

#### 1.2. Налаштування з'єднання
```yaml
ODOO Конфігурація:
  1. Створення API користувача:
     ```bash
     # В ODOO створіть технічного користувача
     # Надайте необхідні права доступу:
     - Інвентаризація: Менеджер
     - Виробництво: Користувач
     - API Access: Enabled
     ```
  
  2. Отримання доступу:
     ```python
     # Приклад Python-коду для тестування з'єднання
     import xmlrpc.client
     
     url = 'http://localhost:8069'
     db = 'odoo_database'
     username = 'api_user'
     password = 'api_password'
     
     common = xmlrpc.client.ServerProxy('{}/xmlrpc/2/common'.format(url))
     uid = common.authenticate(db, username, password, {})
     ```

ThingsBoard Конфігурація:
  1. Створення клієнта:
     ```json
     {
       "name": "ODOO Integration",
       "type": "HTTP",
       "configuration": {
         "baseUrl": "http://odoo:8069",
         "headers": {
           "Content-Type": "application/json",
           "Authorization": "Bearer ${TOKEN}"
         }
       }
     }
     ```
  
  2. Rule Chain для ODOO:
     - Node: REST API Call
     - Node: Transform Payload
     - Node: Save Timeseries
```

#### 1.3. Типові сценарії використання

##### 1.3.1. Синхронізація товарів/продукції
```yaml
Напрямок: ODOO -> ThingsBoard
  Rule Chain:
    1. HTTP Endpoint:
       - URL: /api/v1/products
       - Method: POST
       
    2. Трансформація даних:
       ```javascript
       var product = msg.product;
       return {
         productId: product.id,
         name: product.name,
         quantity: product.qty_available,
         location: product.location_id[1],
         lastUpdate: new Date().getTime()
       };
       ```
    
    3. Збереження:
       - Entity Type: ASSET
       - Entity Group: Products
       
  ODOO Тригери:
    - Створення продукту
    - Зміна кількості
    - Зміна локації
```

##### 1.3.2. Оновлення складських залишків
```yaml
Напрямок: ThingsBoard -> ODOO
  Rule Chain:
    1. Зміна кількості:
       - Node: Message Type Switch
       - Filter: quantity_changed
    
    2. REST API Call:
       ```json
       {
         "url": "/api/v1/inventory/update",
         "method": "POST",
         "payload": {
           "product_id": "${productId}",
           "new_quantity": "${quantity}",
           "location_id": "${locationId}"
         }
       }
       ```
    
    3. Підтвердження:
       - Save Success/Error
       - Send Notification

  Автоматизація ODOO:
    - Оновлення залишків
    - Створення руху товарів
    - Генерація документів
```

##### 1.3.3. Інтеграція виробничих процесів
```yaml
Виробничі операції:
  1. Створення виробничого замовлення:
     ```json
     {
       "url": "/api/v1/manufacturing/order",
       "method": "POST",
       "payload": {
         "product_id": "${productId}",
         "quantity": "${quantity}",
         "bom_id": "${bomId}",
         "scheduled_date": "${scheduledDate}"
       }
     }
     ```
  
  2. Відстеження прогресу:
     Rule Chain:
       - Node: Process Status
       - Node: Update ODOO
       - Node: Notify Manager
     
  3. Завершення виробництва:
     ```json
     {
       "url": "/api/v1/manufacturing/complete",
       "method": "POST",
       "payload": {
         "order_id": "${orderId}",
         "actual_quantity": "${actualQuantity}",
         "quality_data": "${qualityData}"
       }
     }
     ```

Контроль якості:
  1. Збір даних:
     - Параметри процесу
     - Результати вимірювань
     - Відхилення
     
  2. Передача в ODOO:
     - Створення записів якості
     - Оновлення специфікацій
     - Генерація звітів
```

##### 1.3.4. Моніторинг та сповіщення
```yaml
Налаштування сповіщень:
  1. Критичні події:
     ```javascript
     if (quantity < minLevel) {
       return {
         type: 'CRITICAL',
         title: 'Low Stock Alert',
         details: {
           product: productName,
           current: quantity,
           minimum: minLevel
         }
       };
     }
     ```
  
  2. Інтеграція з ODOO:
     - Створення задач
     - Сповіщення користувачів
     - Планування поповнень

  3. Автоматичні дії:
     - Створення замовлень
     - Перепланування виробництва
     - Коригування запасів
```

##### 1.3.5. Аналітика та звітність
```yaml
Типи звітів:
  1. Виробничі показники:
     - Ефективність обладнання
     - Виконання плану
     - Якість продукції
     
  2. Складська аналітика:
     - Оборотність запасів
     - Точність прогнозів
     - ABC-аналіз
     
  3. Інтеграція даних:
     - Експорт в ODOO
     - Синхронізація метрик
     - Консолідована звітність

Автоматизація звітів:
  Rule Chain:
    1. Збір даних:
       - Агрегація показників
       - Розрахунок KPI
       
    2. Формування звіту:
       - Шаблони ODOO
       - Графіки та діаграми
       
    3. Розсилка:
       - За розкладом
       - По події
       - На запит
```

## Rule Engine та сценарії автоматизації

### 1. Основні компоненти Rule Engine

#### 1.1. Типи вузлів
```yaml
Вхідні вузли:
  - Generator:
      Опис: Генерація тестових даних
      Приклад: |
        {
          "msgType": "POST_TELEMETRY",
          "interval": 1000,
          "payload": {
            "temperature": "$random.nextInt(20,30)",
            "humidity": "$random.nextInt(40,60)"
          }
        }
  
  - Device Profile:
      Опис: Обробка повідомлень від пристроїв
      Приклад: |
        {
          "filter": "typeof msg.temperature !== 'undefined'"
        }
        
  - REST API:
      Опис: Прийом HTTP запитів
      Приклад: |
        {
          "endpoint": "/api/v1/data",
          "method": "POST",
          "security": "JWT_TOKEN"
        }

Обробка даних:
  - Transform:
      Опис: Перетворення даних
      Приклад: |
        var temperature = msg.temperature;
        var status = temperature > 25 ? 'high' : 'normal';
        return { temp: temperature, status: status };
  
  - Filter:
      Опис: Фільтрація повідомлень
      Приклад: |
        return msg.status === 'high';
  
  - Switch:
      Опис: Маршрутизація за умовою
      Приклад: |
        {
          "conditions": [
            { "key": "status", "value": "high", "route": "alarm" },
            { "key": "status", "value": "normal", "route": "log" }
          ]
        }

Дії:
  - RPC:
      Опис: Виклик команд на пристрої
      Приклад: |
        {
          "method": "setValue",
          "params": {
            "value": "${msg.newValue}"
          },
          "timeout": 5000
        }
  
  - Database:
      Опис: Збереження в БД
      Приклад: |
        {
          "type": "timeseries",
          "keys": ["temperature", "status"]
        }
        
  - Notification:
      Опис: Відправка сповіщень
      Приклад: |
        {
          "type": "alarm",
          "severity": "CRITICAL",
          "message": "Temperature is too high: ${msg.temp}"
        }
```

### 2. Складні сценарії автоматизації

#### 2.1. Каскадне керування насосами
```yaml
Опис: Автоматичне керування групою насосів з підтримкою тиску

Rule Chain:
  1. Збір даних:
     ```javascript
     // Отримання даних з датчиків
     {
       pressure: msg.pressure,     // Тиск в системі
       flowRate: msg.flowRate,     // Витрата
       pumpStatus: msg.pumpStatus  // Статус насосів
     }
     ```
  
  2. Аналіз та прийняття рішень:
     ```javascript
     var targetPressure = 5.0;  // Бар
     var deadband = 0.2;        // Гістерезис
     
     if (msg.pressure < targetPressure - deadband) {
       // Збільшити потужність або включити додатковий насос
       return {
         action: 'increase',
         delta: targetPressure - msg.pressure
       };
     } else if (msg.pressure > targetPressure + deadband) {
       // Зменшити потужність або виключити насос
       return {
         action: 'decrease',
         delta: msg.pressure - targetPressure
       };
     }
     ```
  
  3. Керування частотниками:
     ```javascript
     // Зміна частоти обертання
     {
       method: 'setFrequency',
       params: {
         deviceId: msg.pumpId,
         frequency: calculateFrequency(msg.delta)
       }
     }
     ```
  
  4. Моніторинг та логування:
     ```javascript
     // Запис історії роботи
     {
       ts: new Date().getTime(),
       values: {
         pressure: msg.pressure,
         activePumps: msg.pumpStatus.filter(p => p.active).length,
         totalFlow: msg.flowRate
       }
     }
     ```

Алгоритми оптимізації:
  1. Чергування насосів:
     ```javascript
     // Розподіл навантаження
     function selectNextPump(pumps) {
       return pumps.sort((a, b) => 
         a.workingHours - b.workingHours
       )[0];
     }
     ```
  
  2. Енергоефективність:
     ```javascript
     // Оптимізація енергоспоживання
     function optimizePower(flow, pressure) {
       var efficiency = flow * pressure / power;
       return {
         optimal: efficiency > 0.8,
         recommendation: calculateOptimalParams(flow, pressure)
       };
     }
     ```
```

#### 2.2. Контроль температурного режиму
```yaml
Опис: Підтримка температур в багатозонній системі

Компоненти:
  - Датчики температури
  - Нагрівачі/охолоджувачі
  - Клапани
  - Вентилятори

Rule Chain:
  1. Збір та агрегація даних:
     ```javascript
     // Агрегація даних з зон
     var zones = msg.temperatures.map(t => ({
       zoneId: t.id,
       current: t.value,
       target: getTargetTemp(t.id),
       humidity: t.humidity,
       mode: determineMode(t.value, getTargetTemp(t.id))
     }));
     ```
  
  2. Логіка керування:
     ```javascript
     // Визначення режиму для кожної зони
     function determineMode(current, target) {
       var delta = Math.abs(current - target);
       if (delta < 0.5) return 'maintain';
       return current > target ? 'cooling' : 'heating';
     }
     
     // Розрахунок потужності
     function calculatePower(delta) {
       return Math.min(100, Math.max(0, delta * 20));
     }
     ```
  
  3. Керуючі впливи:
     ```javascript
     // Формування команд керування
     zones.forEach(zone => {
       if (zone.mode === 'heating') {
         // Включення нагрівача
         sendCommand(zone.id, 'heater', calculatePower(zone.target - zone.current));
         // Керування клапаном
         sendCommand(zone.id, 'valve', 'open');
       } else if (zone.mode === 'cooling') {
         // Включення охолодження
         sendCommand(zone.id, 'cooler', calculatePower(zone.current - zone.target));
         // Керування вентилятором
         sendCommand(zone.id, 'fan', calculateFanSpeed(zone.delta));
       }
     });
     ```
  
  4. Оптимізація та енергозбереження:
     ```javascript
     // Розрахунок оптимального режиму
     function optimizeEnergy(zones) {
       return zones.map(zone => ({
         ...zone,
         schedule: calculateSchedule(zone),
         preheating: needPreheating(zone),
         powerSaving: canReducePower(zone)
       }));
     }
     ```

Додаткові функції:
  1. Прогнозування:
     ```javascript
     // Передбачення температур
     function predictTemperature(zone, timeOffset) {
       var trend = calculateTrend(zone.history);
       return {
         predicted: zone.current + trend * timeOffset,
         confidence: calculateConfidence(trend)
       };
     }
     ```
  
  2. Аварійні ситуації:
     ```javascript
     // Обробка аварій
     if (zone.current > zone.maxAllowed) {
       createAlarm({
         type: 'HIGH_TEMPERATURE',
         severity: 'CRITICAL',
         zone: zone.id,
         value: zone.current
       });
       
       // Аварійне охолодження
       emergencyCooling(zone.id);
     }
     ```
```

#### 2.3. Інтеграція з базами даних
```yaml
Опис: Робота з різними типами баз даних

Timeseries DB:
  1. Запис даних:
     ```javascript
     // Збереження телеметрії
     {
       ts: msg.ts,
       values: {
         temperature: msg.value,
         pressure: msg.pressure,
         status: msg.status
       },
       ttl: 30 * 24 * 3600 // 30 днів
     }
     ```
  
  2. Агрегація:
     ```javascript
     // Агрегація за період
     var end = new Date().getTime();
     var start = end - 24 * 3600 * 1000; // 24 години
     
     loadTimeseries({
       keys: ['temperature'],
       startTs: start,
       endTs: end,
       interval: 3600000, // 1 година
       agg: 'AVG'
     });
     ```

SQL Queries:
  1. Зчитування даних:
     ```javascript
     // Запит до БД
     var query = {
       sql: 'SELECT * FROM production WHERE date = ${date}',
       params: {
         date: msg.date
       }
     };
     ```
  
  2. Обробка результатів:
     ```javascript
     // Трансформація даних
     if (msg.data && Array.isArray(msg.data)) {
       return msg.data.map(row => ({
         timestamp: row.timestamp,
         value: parseFloat(row.value),
         quality: row.quality === 1
       }));
     }
     ```
```

## Приклади використання

### 1. Моніторинг виробництва
```yaml
Функції:
  - Відображення стану обладнання
  - Контроль параметрів процесу
  - Облік продукції
  - Контроль якості

Інтерфейс:
  - Мнемосхема виробництва
  - Графіки параметрів
  - Журнал подій
  - Звіти зміни
```

### 2. Управління енергоресурсами
```yaml
Функції:
  - Облік споживання
  - Контроль навантаження
  - Оптимізація режимів
  - Виявлення втрат

Інтерфейс:
  - Енергобаланс
  - Діаграми споживання
  - Прогноз витрат
  - Рекомендації
```

### 3. Контроль якості
```yaml
Функції:
  - Збір даних з аналізаторів
  - Статистичний контроль
  - Відстеження партій
  - Сертифікати якості

Інтерфейс:
  - Лабораторні дані
  - Контрольні карти
  - Тренди параметрів
  - Звіти якості
```

## Кращі практики

### 1. Проектування системи
```yaml
Рекомендації:
  Архітектура:
    - Модульний підхід
    - Стандартизація рішень
    - Масштабованість
    - Відмовостійкість
    
  Інтерфейс:
    - Єдиний стиль
    - Інтуїтивність
    - Інформативність
    - Ергономічність
    
  Безпека:
    - Багаторівневий захист
    - Резервування
    - Аудит
```

### 2. Впровадження
```yaml
Етапи:
  1. Підготовка:
    - Аналіз вимог
    - Проектування
    - Планування
    
  2. Розробка:
    - Конфігурація системи
    - Створення мнемосхем
    - Налаштування логіки
    
  3. Тестування:
    - Функціональне
    - Інтеграційне
    - Навантажувальне
    
  4. Введення в експлуатацію:
    - Навчання персоналу
    - Дослідна експлуатація
    - Технічна підтримка
```

### 3. Обслуговування
```yaml
Регламентні роботи:
  Щоденно:
    - Перевірка працездатності
    - Контроль помилок
    - Резервне копіювання
    
  Щомісячно:
    - Аналіз продуктивності
    - Оптимізація налаштувань
    - Оновлення системи
    
  Щорічно:
    - Аудит безпеки
    - Перегляд конфігурації
    - Планування розвитку
```

## Приклади конфігурації

### 1. Налаштування підключення обладнання
```yaml
Приклад підключення Modbus TCP пристрою:
  1. Створення пристрою:
    - Перейти в "Пристрої"
    - Натиснути "+" -> "Додати новий пристрій"
    - Заповнити поля:
        Ім'я: "Температурний датчик"
        Тип: "Modbus TCP"
        Профіль: "Modbus Device"
    
  2. Конфігурація Modbus:
    - IP адреса: 192.168.1.100
    - Порт: 502
    - Slave ID: 1
    - Polling interval: 1000ms
    
  3. Налаштування регістрів:
    - Температура:
        Тип: Input Register
        Адреса: 3000
        Масштаб: 0.1
    - Вологість:
        Тип: Input Register
        Адреса: 3001
        Масштаб: 1.0
```

### 2. Створення мнемосхеми
```yaml
Приклад мнемосхеми резервуара:
  1. Створення дашборда:
    - Перейти в "Дашборди"
    - Натиснути "+" -> "Створити новий дашборд"
    - Назва: "Резервуар 1"
    
  2. Додавання віджетів:
    - Зображення резервуара:
        Тип: "Зображення"
        Файл: "tank.svg"
        Розмір: 400x600px
        
    - Індикатор рівня:
        Тип: "Лінійний датчик"
        Джерело: ${device:tank_level}
        Діапазон: 0-100%
        Кольори:
          0-20%: червоний
          20-80%: зелений
          80-100%: жовтий
          
    - Температура:
        Тип: "Цифровий"
        Джерело: ${device:temperature}
        Одиниці: °C
        Формат: ##.#
        
  3. Налаштування анімації:
    - Заповнення резервуара:
        Тип: "Зміна кольору"
        Прив'язка: ${device:tank_level}
        CSS: fill-opacity
```

### 3. Налаштування тривог
```yaml
Приклад налаштування тривог:
  1. Створення правила:
    - Перейти в "Rule Chains"
    - Додати вузол "Тривога"
    
  2. Конфігурація умов:
    - Висока температура:
        Умова: temperature > 85
        Тип: CRITICAL
        Текст: "Критична температура!"
        
    - Низький рівень:
        Умова: tank_level < 10
        Тип: WARNING
        Текст: "Низький рівень рідини"
        
  3. Налаштування сповіщень:
    - Email:
        Отримувачі: operators@company.com
        Шаблон: "alarm_template.html"
        
    - SMS:
        Номери: +380501234567
        Текст: "${alarm.type}: ${alarm.text}"
```

### 4. Створення звітів
```yaml
Приклад налаштування звіту зміни:
  1. Створення шаблону:
    - Формат: Excel
    - Змінні:
        start_time: ${time:START_OF_DAY}
        end_time: ${time:END_OF_DAY}
        
  2. Налаштування даних:
    - Виробництво:
        Запит: SELECT time, value 
               FROM telemetry 
               WHERE key = 'production'
        Період: ${start_time} - ${end_time}
        
    - Простої:
        Запит: SELECT start_ts, end_ts, reason 
               FROM events 
               WHERE type = 'downtime'
        Період: ${start_time} - ${end_time}
        
  3. Планування:
    - Час: 23:00
    - Періодичність: Щоденно
    - Формат: PDF
    - Розсилка: shift_managers@company.com
```

## Типові помилки та їх вирішення

### 1. Проблеми підключення пристроїв
```yaml
Помилка підключення Modbus:
  Симптоми:
    - Пристрій не з'являється в системі
    - Помилки timeout в логах
    - Немає даних від пристрою
  
  Можливі причини:
    - Неправильна IP-адреса або порт
    - Брандмауер блокує з'єднання
    - Невірний Slave ID
    - Неправильна конфігурація регістрів
  
  Рішення:
    1. Перевірка мережі:
       - Ping пристрою:
           ```bash
           ping 192.168.1.100
           ping -c 4 modbus-device.local
           ```
       - Telnet на порт:
           ```bash
           telnet 192.168.1.100 502
           nc -zv 192.168.1.100 502
           ```
       - Перевірка налаштувань мережі:
           ```bash
           ip addr show
           route -n
           cat /etc/resolv.conf
           ```
    
    2. Перевірка конфігурації:
       - Звірити параметри з документацією
       - Тест Modbus з'єднання:
           ```bash
           modpoll -m tcp -a 1 -r 3000 -c 10 192.168.1.100
           mbpoll -m tcp -a 1 -r 3000 -c 10 192.168.1.100
           ```
       - Перевірити доступність портів:
           ```bash
           netstat -tulpn | grep 502
           lsof -i :502
           ```
    
    3. Діагностика:
       - Включити debug логування:
           ```bash
           tail -f /var/log/thingsboard/thingsboard.log | grep -i modbus
           journalctl -u thingsboard -f | grep -i modbus
           ```
       - Перевірити статистику помилок:
           ```bash
           cat /var/log/thingsboard/thingsboard.log | grep -i modbus | sort | uniq -c | sort -nr
           ```
       - Моніторинг трафіку:
           ```bash
           iftop -i eth0
           nethogs eth0
           ```

Помилка підключення OPC UA:
  Симптоми:
    - Помилка сертифікату
    - Відмова в аутентифікації
    - Переривання зв'язку
  
  Рішення:
    1. Сертифікати:
       - Перевірка сертифікатів:
           ```bash
           openssl x509 -in client-cert.pem -text -noout
           openssl verify -CAfile ca.pem client-cert.pem
           ```
       - Оновлення довірених сертифікатів:
           ```bash
           cp client-cert.pem /etc/thingsboard/conf/opcua/trusted/
           chown thingsboard:thingsboard /etc/thingsboard/conf/opcua/trusted/*
           systemctl restart thingsboard
           ```
    
    2. Безпека:
       - Перевірка з'єднання:
           ```bash
           opcua-client -u opc.tcp://server:4840/ -c client-cert.pem -k client-key.pem
           uas -u opc.tcp://server:4840/ -l debug
           ```
       - Діагностика:
           ```bash
           netstat -an | grep 4840
           tcpdump -i any port 4840
           ```

{{ ... }}

  Діагностика:
    1. Моніторинг ресурсів:
       - CPU та пам'ять:
           ```bash
           top -p $(pgrep -d',' -f thingsboard)
           ps aux | grep java
           free -h
           ```
       - Диск:
           ```bash
           df -h /var/lib/postgresql
           du -sh /var/lib/thingsboard
           iostat -x 1
           ```
       - Мережа:
           ```bash
           iftop -i eth0
           nethogs
           ```
    
    2. Аналіз логів:
       - Помилки в логах:
           ```bash
           grep -r "ERROR" /var/log/thingsboard/
           tail -f /var/log/thingsboard/thingsboard.log | grep -i error
           ```
       - Статистика помилок:
           ```bash
           cat /var/log/thingsboard/thingsboard.log | grep -i error | sort | uniq -c | sort -nr
           ```
       - Аналіз SQL:
           ```bash
           psql -U postgres thingsboard -c "SELECT query, calls, total_time FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;"
           ```

{{ ... }}

  Рішення:
    1. Превентивні заходи:
       - Налаштування буферизації:
           ```bash
           sysctl -w net.core.rmem_max=26214400
           sysctl -w net.core.wmem_max=26214400
           ```
       - Моніторинг вільного місця:
           ```bash
           watch -n 60 "df -h /var/lib/postgresql"
           ```
       - Резервне копіювання:
           ```bash
           pg_dump -U postgres thingsboard > backup.sql
           tar czf tb-data-$(date +%Y%m%d).tar.gz /var/lib/thingsboard
           ```
    
    2. Відновлення:
       - Перевірка цілісності БД:
           ```bash
           psql -U postgres thingsboard -c "VACUUM ANALYZE;"
           psql -U postgres thingsboard -c "REINDEX DATABASE thingsboard;"
           ```
       - Відновлення з бекапу:
           ```bash
           psql -U postgres thingsboard < backup.sql
           tar xzf tb-data-20231209.tar.gz -C /
           chown -R thingsboard:thingsboard /var/lib/thingsboard
           ```
       - Очищення старих даних:
           ```bash
           psql -U postgres thingsboard -c "DELETE FROM ts_kv WHERE ts < (EXTRACT(EPOCH FROM NOW() - INTERVAL '90 days') * 1000);"
           ```
```

## Приклади Rule Chain для виробничих процесів

### 1. Елеватор та зберігання зерна
```yaml
Опис: Контроль умов зберігання зерна в силосах

Rule Chain:
  1. Збір даних з датчиків:
     ```javascript
     // Дані з силосу
     {
       siloId: msg.siloId,
       measurements: {
         temperature: msg.temperature,    // Температура зерна
         humidity: msg.humidity,          // Вологість
         co2: msg.co2,                   // Рівень CO2
         level: msg.level                // Рівень заповнення
       },
       ventilation: msg.ventStatus,       // Статус вентиляції
       lastUpdate: new Date().getTime()
     }
     ```

  2. Аналіз умов зберігання:
     ```javascript
     // Перевірка умов
     function checkConditions(data) {
       var alerts = [];
       
       // Температура
       if (data.measurements.temperature > 25) {
         alerts.push({
           type: 'HIGH_TEMPERATURE',
           value: data.measurements.temperature,
           threshold: 25
         });
       }
       
       // Вологість
       if (data.measurements.humidity > 14) {
         alerts.push({
           type: 'HIGH_HUMIDITY',
           value: data.measurements.humidity,
           threshold: 14
         });
       }
       
       // CO2
       if (data.measurements.co2 > 1000) {
         alerts.push({
           type: 'HIGH_CO2',
           value: data.measurements.co2,
           threshold: 1000
         });
       }
       
       return {
         siloId: data.siloId,
         alerts: alerts,
         needsVentilation: alerts.length > 0
       };
     }
     ```

  3. Керування вентиляцією:
     ```javascript
     // Логіка керування вентиляцією
     if (msg.needsVentilation && !msg.ventilation.active) {
       // Перевірка зовнішніх умов
       var outdoor = getOutdoorConditions();
       
       if (outdoor.temperature < msg.measurements.temperature 
           && outdoor.humidity < msg.measurements.humidity) {
         // Включення вентиляції
         return {
           method: 'setVentilation',
           params: {
             siloId: msg.siloId,
             command: 'start',
             speed: calculateOptimalSpeed(msg.measurements)
           }
         };
       }
     }
     ```

  4. Моніторинг та звітність:
     ```javascript
     // Збереження даних для звітів
     var reportData = {
       ts: new Date().getTime(),
       values: {
         siloId: msg.siloId,
         temperature: msg.measurements.temperature,
         humidity: msg.measurements.humidity,
         co2: msg.measurements.co2,
         ventilationHours: calculateVentilationHours(msg),
         energyUsed: calculateEnergyUsage(msg),
         qualityIndex: calculateQualityIndex(msg)
       }
     };
     
     // Генерація щоденного звіту
     if (isEndOfDay()) {
       generateReport({
         type: 'STORAGE_CONDITIONS',
         siloId: msg.siloId,
         date: new Date(),
         data: aggregateDailyData(msg.siloId)
       });
     }
     ```

Додаткові функції:
  1. Прогнозування самозігрівання:
     ```javascript
     // Аналіз тренду температури
     function predictSelfHeating(history) {
       var trend = calculateTemperatureTrend(history);
       var prediction = {
         timeToAlert: calculateTimeToThreshold(trend, 25),
         confidence: calculateConfidence(trend)
       };
       
       if (prediction.timeToAlert < 48) { // менше 48 годин
         createAlert({
           type: 'SELF_HEATING_PREDICTION',
           siloId: msg.siloId,
           timeToAlert: prediction.timeToAlert,
           confidence: prediction.confidence
         });
       }
       
       return prediction;
     }
     ```

  2. Оптимізація енергоспоживання:
     ```javascript
     // Розрахунок оптимального режиму вентиляції
     function optimizeVentilation(conditions) {
       var schedule = [];
       
       // Перевірка тарифів на електроенергію
       var powerRates = getPowerRates();
       
       // Планування вентиляції на періоди з низьким тарифом
       powerRates.forEach(rate => {
         if (rate.price < threshold && isGoodConditions(conditions, rate.time)) {
           schedule.push({
             startTime: rate.time,
             duration: calculateDuration(conditions),
             speed: calculateOptimalSpeed(conditions)
           });
         }
       });
       
       return schedule;
     }
     ```
```

### 2. Процес сушіння
```yaml
Опис: Керування сушаркою з контролем якості

Rule Chain:
  1. Контроль параметрів:
     ```javascript
     // Дані процесу сушіння
     {
       dryerId: msg.dryerId,
       process: {
         inletTemperature: msg.inletTemp,
         outletTemperature: msg.outletTemp,
         productTemperature: msg.productTemp,
         humidity: msg.humidity,
         airFlow: msg.airFlow,
         productFlow: msg.productFlow
       },
       status: msg.status
     }
     ```

  2. Регулювання режиму:
     ```javascript
     // Розрахунок параметрів керування
     function adjustDryingParams(data) {
       var targetHumidity = getTargetHumidity(data.productType);
       var delta = data.process.humidity - targetHumidity;
       
       return {
         temperature: calculateTemperature(delta),
         airFlow: calculateAirFlow(delta),
         productFlow: calculateProductFlow(delta)
       };
     }
     ```

  3. Контроль якості:
     ```javascript
     // Перевірка якості сушіння
     function checkQuality(data) {
       var quality = {
         humidity: {
           value: data.process.humidity,
           inRange: isInRange(data.process.humidity, 
                            getHumidityRange(data.productType))
         },
         temperature: {
           value: data.process.productTemperature,
           inRange: isInRange(data.process.productTemperature,
                            getTemperatureRange(data.productType))
         }
       };
       
       if (!quality.humidity.inRange || !quality.temperature.inRange) {
         createAlert({
           type: 'QUALITY_ALERT',
           dryerId: data.dryerId,
           quality: quality
         });
       }
       
       return quality;
     }
     ```

  4. Енергоефективність:
     ```javascript
     // Моніторинг енергоефективності
     function monitorEfficiency(data) {
       var efficiency = {
         energyUsage: calculateEnergyUsage(data),
         throughput: data.process.productFlow,
         specificEnergy: calculateSpecificEnergy(data)
       };
       
       // Порівняння з базовими показниками
       var comparison = compareWithBaseline(efficiency);
       
       if (comparison.deviation > 10) { // відхилення більше 10%
         createAlert({
           type: 'EFFICIENCY_ALERT',
           dryerId: data.dryerId,
           efficiency: efficiency,
           deviation: comparison.deviation
         });
       }
       
       return efficiency;
     }
     ```
```

```

## Приклади Rule Chain

Детальні приклади Rule Chain для різних виробничих процесів доступні в окремих файлах:

1. [Елеватор та зберігання зерна](rule-chains/01-grain-storage.md)
   - Контроль умов зберігання
   - Керування вентиляцією
   - Прогнозування самозігрівання
   - Оптимізація енергоспоживання

2. [Процес сушіння](rule-chains/02-drying-process.md)
   - Контроль параметрів сушіння
   - Регулювання режиму
   - Контроль якості
   - CIP-мийка
   - Енергоефективність та облік

3. [Виробництво напоїв](rule-chains/03-beverage-production.md)
   - Керування рецептурою
   - Контроль процесу змішування
   - Контроль якості
   - CIP-мийка
   - Енергоефективність та облік
