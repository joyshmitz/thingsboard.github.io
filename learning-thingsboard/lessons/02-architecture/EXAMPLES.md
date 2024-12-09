# Практичні приклади та пояснення

## Приклад 1: Моніторинг температури в силосі

### Опис процесу
Розглянемо як працює система моніторингу температури в одному силосі:

```yaml
Обладнання:
  Датчики: 12 x PT100
  ПЛК: Siemens S7-1200
  Edge пристрій: Advantech WISE-5000

Розташування датчиків:
  Рівень 1 (нижній):
    - T1.1: Північ
    - T1.2: Схід
    - T1.3: Південь
    - T1.4: Захід
  
  Рівень 2 (середній):
    - T2.1: Північ
    - T2.2: Схід
    - T2.3: Південь
    - T2.4: Захід
  
  Рівень 3 (верхній):
    - T3.1: Північ
    - T3.2: Схід
    - T3.3: Південь
    - T3.4: Захід
```

### Потік даних

1. **Збір даних з датчиків**
```yaml
Датчик -> ПЛК:
  Протокол: Modbus RTU
  Регістри:
    40001: T1.1 (float)
    40003: T1.2 (float)
    40005: T1.3 (float)
    # і т.д.
  
  Частота опитування: 5 хвилин
  Формат даних: IEEE 754 float
```

2. **Обробка в ПЛК**
```javascript
// Приклад логіки в ПЛК
for each sensor (T1.1 to T3.4):
  // Перевірка достовірності
  if (sensor_value < -20 || sensor_value > 100):
    sensor_status = BAD_QUALITY
  else:
    sensor_status = GOOD_QUALITY
  
  // Розрахунок середньої температури по рівню
  level1_avg = (T1.1 + T1.2 + T1.3 + T1.4) / 4
  level2_avg = (T2.1 + T2.2 + T2.3 + T2.4) / 4
  level3_avg = (T3.1 + T3.2 + T3.3 + T3.4) / 4
  
  // Перевірка градієнту
  if (abs(sensor_value - prev_value) > 5):
    raise_alarm("High temperature gradient")
```

3. **Передача даних в Edge пристрій**
```yaml
ПЛК -> Edge:
  Протокол: Modbus TCP
  Дані:
    - Значення всіх датчиків
    - Статуси датчиків
    - Середні значення по рівнях
    - Аларми

Edge -> ThingsBoard:
  Протокол: MQTT
  Топік: v1/devices/silo1/telemetry
  Формат: JSON
  Приклад:
    {
      "ts": 1638360000000,
      "values": {
        "T1.1": 23.5,
        "T1.1_status": "GOOD",
        "T1.2": 23.7,
        "T1.2_status": "GOOD",
        // ...
        "level1_avg": 23.6,
        "level2_avg": 24.1,
        "level3_avg": 24.5,
        "gradient_alarm": false
      }
    }
```

### Візуалізація в ThingsBoard

1. **Температурна карта силосу**
```javascript
// Віджет з тепловою картою
{
  "type": "heatmap",
  "title": "Температура в силосі №1",
  "data": [
    ["T3.1", "T3.2", "T3.3", "T3.4"],
    ["T2.1", "T2.2", "T2.3", "T2.4"],
    ["T1.1", "T1.2", "T1.3", "T1.4"]
  ],
  "settings": {
    "min": 0,
    "max": 40,
    "colorScheme": "temperature"
  }
}
```

2. **Графік трендів**
```javascript
// Віджет з графіками
{
  "type": "timeseries",
  "title": "Тренди температур",
  "data": [
    "level1_avg",
    "level2_avg",
    "level3_avg"
  ],
  "timewindow": {
    "realtime": {
      "timewindowMs": 86400000 // 24 години
    }
  }
}
```

## Приклад 2: Процес зважування автомобіля

### Опис процесу
Розглянемо як працює система автомобільних ваг:

```yaml
Обладнання:
  - Ваги: CAS RW-15P
  - Світлофор: 2 шт
  - Камера номерів: Hikvision
  - ПЛК: Siemens S7-1200
  - Edge пристрій: Dell Edge Gateway

Процес:
  1. Автомобіль під'їжджає до ваг
  2. Камера розпізнає номер
  3. Водій чекає зеленого світла
  4. Заїзд на ваги
  5. Зважування
  6. Виїзд з ваг
```

### Потік даних

1. **Камера розпізнавання номерів**
```yaml
Камера -> Edge:
  Протокол: REST API
  Формат: JSON
  Приклад:
    {
      "timestamp": "2023-12-09T10:15:30",
      "plate": "AA1234BB",
      "confidence": 0.98,
      "image_url": "http://storage/plates/123.jpg"
    }
```

2. **Ваги**
```yaml
Ваги -> ПЛК:
  Протокол: Modbus RTU
  Регістри:
    40001: Вага (float)
    40003: Статус (int)
    40004: Стабільність (bool)

ПЛК -> Edge:
  Протокол: Modbus TCP
  Дані:
    - Поточна вага
    - Статус ваг
    - Стан світлофорів
```

3. **Обробка в Edge пристрої**
```javascript
// Логіка роботи
async function handleWeighing() {
  // 1. Очікування автомобіля
  while (weight < MIN_WEIGHT) {
    await sleep(100);
  }
  
  // 2. Перевірка стабільності
  let stableCount = 0;
  while (stableCount < 10) {
    if (isStable) {
      stableCount++;
    } else {
      stableCount = 0;
    }
    await sleep(100);
  }
  
  // 3. Формування даних
  const weighingData = {
    timestamp: Date.now(),
    plate: currentPlate,
    weight: currentWeight,
    image_url: plateImage,
    operator: currentOperator
  };
  
  // 4. Відправка в ThingsBoard
  await sendTelemetry("weighing", weighingData);
}
```

4. **Відправка в ThingsBoard**
```yaml
Edge -> ThingsBoard:
  Протокол: MQTT
  Топік: v1/devices/scale1/telemetry
  QoS: 1
  Формат: JSON
  Приклад:
    {
      "ts": 1638360000000,
      "values": {
        "operation_id": "W123456",
        "plate": "AA1234BB",
        "weight": 15780,
        "stable": true,
        "operator": "John Doe",
        "image_url": "http://storage/plates/123.jpg"
      }
    }
```

### Автоматизація в ThingsBoard

1. **Rule Chain для зважування**
```yaml
Правила:
  1. Перевірка даних:
    - Валідація номера
    - Перевірка ваги
    - Перевірка оператора
  
  2. Збагачення даних:
    - Додавання інформації про вантаж
    - Розрахунок нетто
    - Додавання часових міток
  
  3. Збереження:
    - Запис в базу даних
    - Створення документа
    - Відправка в ERP
  
  4. Сповіщення:
    - SMS водію
    - Email менеджеру
    - Telegram оператору
```

2. **Дашборд оператора**
```javascript
// Віджети на дашборді
{
  "layout": [
    {
      "type": "current-weight",
      "title": "Поточна вага",
      "settings": {
        "units": "кг",
        "decimals": 0
      }
    },
    {
      "type": "plate-recognition",
      "title": "Розпізнаний номер",
      "settings": {
        "showImage": true,
        "showConfidence": true
      }
    },
    {
      "type": "weighing-form",
      "title": "Оформлення зважування",
      "settings": {
        "fields": [
          "operator",
          "cargo_type",
          "destination",
          "notes"
        ]
      }
    }
  ]
}
```

## Приклад 3: Система аерації

### Опис процесу
Розглянемо як працює система аерації силосу:

```yaml
Обладнання:
  Вентилятори:
    - Тип: З частотним приводом
    - Потужність: 15 кВт
    - Керування: Modbus TCP
  
  Датчики:
    Температура зерна:
      - 12 точок по силосу
    Вологість зерна:
      - 4 точки по силосу
    Температура повітря:
      - Зовнішня
      - В силосі
    Вологість повітря:
      - Зовнішня
      - В силосі
```

### Алгоритм роботи

1. **Умови запуску аерації**
```python
def check_aeration_conditions():
    # Перевірка температури зерна
    grain_temp_avg = calculate_average(grain_temperatures)
    if grain_temp_avg > MAX_GRAIN_TEMP:
        return True
    
    # Перевірка вологості
    if grain_moisture > MAX_GRAIN_MOISTURE:
        return True
    
    # Перевірка умов повітря
    if (outside_temp < grain_temp_avg - 5 and
        outside_humidity < MAX_OUTSIDE_HUMIDITY):
        return True
    
    return False
```

2. **Керування вентиляторами**
```python
def control_ventilation():
    if check_aeration_conditions():
        # Розрахунок необхідної швидкості
        required_speed = calculate_required_speed(
            grain_temp_avg,
            outside_temp,
            grain_moisture
        )
        
        # Плавний пуск
        for speed in range(0, required_speed, 5):
            set_fan_speed(speed)
            wait(30)  # 30 секунд між кроками
        
        # Моніторинг процесу
        while check_aeration_conditions():
            # Збір даних
            current_data = collect_sensor_data()
            
            # Оптимізація швидкості
            optimize_fan_speed(current_data)
            
            # Перевірка енергоефективності
            check_energy_efficiency()
            
            wait(300)  # Перевірка кожні 5 хвилин
    else:
        # Плавна зупинка
        current_speed = get_fan_speed()
        for speed in range(current_speed, 0, -5):
            set_fan_speed(speed)
            wait(30)
```

### Моніторинг в ThingsBoard

1. **Телеметрія**
```yaml
Дані в реальному часі:
  - Температури по точках
  - Середня температура
  - Вологість зерна
  - Параметри повітря
  - Швидкість вентиляторів
  - Енергоспоживання

Агреговані дані:
  - Час роботи за добу
  - Спожита електроенергія
  - Ефективність охолодження
```

2. **Сповіщення**
```yaml
Аварійні:
  - Перегрів вентилятора
  - Відмова датчика
  - Відхилення від режиму

Інформаційні:
  - Початок/кінець циклу
  - Досягнення цільової температури
  - Планове обслуговування
```

3. **Звіти**
```yaml
Щоденні:
  - Графік роботи системи
  - Динаміка температур
  - Витрати електроенергії

Місячні:
  - Статистика роботи
  - Ефективність охолодження
  - Рекомендації з оптимізації
```
