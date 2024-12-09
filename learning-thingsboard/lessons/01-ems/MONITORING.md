# Налаштування моніторингу енергоефективності

## Відповідність стандартам та інтеграція

Цей документ описує технічну реалізацію системи моніторингу енергоефективності в ThingsBoard PE у відповідності до вимог:

- [ISO 50001](ISO_50001.md) - вимоги до системи енергетичного менеджменту
- [ISO 50006](ISO_50006.md) - вимірювання показників енергоефективності
- [ISO 50015](ISO_50015.md) - верифікація результатів

Система моніторингу інтегрується з:
- [Оптимізація](OPTIMIZATION.md) - для реалізації стратегій оптимізації
- [Інтеграція](INTEGRATION.md) - для роботи з обладнанням та системами

## Архітектура системи моніторингу

### 1. Структура даних
```yaml
Ієрархія активів:
  - Підприємство
  - Будівлі/Цехи
  - Системи
  - Обладнання
  - Точки вимірювання
```

### 2. Типи телеметрії
```yaml
Параметри:
  - Енергетичні:
      - Активна потужність
      - Реактивна потужність
      - Напруга
      - Струм
      - Коефіцієнт потужності
  
  - Теплові:
      - Температура
      - Витрата
      - Тиск
      - Теплова потужність
  
  - Виробничі:
      - Обсяг продукції
      - Час роботи
      - Завантаження
      - Якість продукції
```

## Налаштування збору даних

### 1. Конфігурація пристроїв
```javascript
// Профіль пристрою для лічильника електроенергії
{
  "name": "Energy Meter Profile",
  "type": "DEFAULT",
  "transportType": "MQTT",
  "provisionType": "DISABLED",
  "profileData": {
    "configuration": {
      "type": "DEFAULT",
      "transport": {
        "type": "MQTT",
        "clientId": "${deviceName}",
        "cleanSession": true,
        "topicFilters": [
          "v1/devices/me/telemetry",
          "v1/devices/me/attributes"
        ]
      }
    },
    "transportConfiguration": {
      "type": "MQTT",
      "deviceAttributesTopic": "v1/devices/me/attributes",
      "deviceTelemetryTopic": "v1/devices/me/telemetry",
      "sendAckOnValidationException": true
    }
  }
}

// Мапінг даних згідно ISO 50006
{
  "deviceNameJsonExpression": "${serialNumber}",
  "attributes": {
    "model": "${model}",
    "firmware": "${firmware}",
    "protocol": "${protocol}"
  },
  "timeseries": {
    "voltage": "${voltage}",
    "current": "${current}",
    "activePower": "${activePower}",
    "reactivePower": "${reactivePower}",
    "powerFactor": "${powerFactor}",
    "frequency": "${frequency}",
    "energy": "${energy}"
  }
}
```

### 2. Rule Chain для обробки даних
```javascript
// Валідація даних згідно ISO 50015
{
  "ruleChain": {
    "name": "Energy Data Validation",
    "type": "CORE",
    "firstRuleNodeId": "validate-data",
    "nodes": [
      {
        "id": "validate-data",
        "type": "FILTER",
        "name": "Validate Measurements",
        "configuration": {
          "jsScript": `
            var voltage = msg.voltage;
            var current = msg.current;
            var power = msg.activePower;
            
            // Перевірка діапазонів згідно ISO 50015
            if (voltage < 180 || voltage > 250) return false;
            if (current < 0 || current > 100) return false;
            if (power < 0 || power > 25000) return false;
            
            // Перевірка узгодженості
            var calculatedPower = voltage * current;
            if (Math.abs(power - calculatedPower) > calculatedPower * 0.1) return false;
            
            return true;
          `
        }
      },
      {
        "id": "calculate-enpi",
        "type": "TRANSFORMATION",
        "name": "Calculate EnPI",
        "configuration": {
          "jsScript": `
            var energy = msg.energy;
            var production = metadata.productionVolume;
            
            // Розрахунок EnPI згідно ISO 50006
            msg.specificConsumption = energy / production;
            msg.efficiency = production / energy;
            
            return {msg: msg, metadata: metadata, msgType: msgType};
          `
        }
      }
    ]
  }
}
```

### 3. Налаштування алармів
```javascript
// Конфігурація алармів згідно ISO 50001
{
  "alarms": [
    {
      "name": "High Power Consumption",
      "type": "High Power",
      "severity": "MAJOR",
      "createRules": {
        "condition": {
          "spec": {
            "type": "SIMPLE",
            "value": {
              "defaultValue": 20000,
              "dynamicValue": {
                "sourceType": "CURRENT_DEVICE",
                "sourceAttribute": "powerThreshold"
              }
            },
            "operation": "GREATER"
          }
        },
        "schedule": null,
        "alarmDetails": "Power consumption exceeded threshold: ${power} W"
      },
      "clearRule": {
        "condition": {
          "spec": {
            "type": "SIMPLE",
            "value": {
              "defaultValue": 19000,
              "dynamicValue": {
                "sourceType": "CURRENT_DEVICE",
                "sourceAttribute": "powerThreshold"
              }
            },
            "operation": "LESS"
          }
        }
      }
    }
  ]
}
```

## Візуалізація даних

### 1. Дашборди
```javascript
// Конфігурація віджетів згідно ISO 50006
{
  "widgets": [
    {
      "type": "timeseries",
      "title": "Power Consumption",
      "config": {
        "datasources": [
          {
            "type": "entity",
            "entityAliasId": "power_meter",
            "dataKeys": [
              {
                "name": "activePower",
                "label": "Active Power",
                "color": "#2196f3",
                "settings": {
                  "showLines": true,
                  "fillLines": false,
                  "showPoints": false
                }
              }
            ]
          }
        ],
        "timewindow": {
          "realtime": {
            "timewindowMs": 86400000
          }
        }
      }
    },
    {
      "type": "latest",
      "title": "Energy Efficiency",
      "config": {
        "datasources": [
          {
            "type": "entity",
            "entityAliasId": "production_line",
            "dataKeys": [
              {
                "name": "specificConsumption",
                "label": "Specific Consumption",
                "color": "#4caf50",
                "settings": {
                  "decimals": 2,
                  "units": "kWh/unit"
                }
              }
            ]
          }
        ]
      }
    }
  ]
}
```

### 2. Звіти
```javascript
// Шаблон звіту згідно ISO 50001
{
  "name": "Energy Consumption Report",
  "type": "PDF",
  "configuration": {
    "timeRange": "LAST_30_DAYS",
    "sections": [
      {
        "type": "text",
        "content": "Energy Consumption Analysis"
      },
      {
        "type": "chart",
        "entityId": "${entityId}",
        "keys": ["activePower", "energy"],
        "aggregation": "AVG",
        "interval": "1h"
      },
      {
        "type": "table",
        "entityId": "${entityId}",
        "keys": ["specificConsumption", "efficiency"],
        "aggregation": "AVG",
        "interval": "1d"
      }
    ]
  }
}
```

## Аналіз даних

### 1. Базова аналітика
- Трендовий аналіз згідно ISO 50006
- Порівняння періодів
- Виявлення аномалій
- Прогнозування споживання

### 2. Розширена аналітика
- Регресійний аналіз згідно ISO 50015
- Кореляційний аналіз
- Декомпозиція часових рядів
- Кластерний аналіз

## Інтеграція з іншими системами

### 1. Експорт даних
```yaml
Формати:
  - CSV
  - JSON
  - XML
  - Excel
```

### 2. API інтеграції
```yaml
Методи:
  - REST API
  - WebSocket
  - MQTT
  - gRPC
```

## Додаткові матеріали

- [Приклади конфігурацій](examples/configs/)
- [Шаблони дашбордів](examples/dashboards/)
- [Зразки звітів](examples/reports/)
