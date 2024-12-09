# Інтеграція системи енергоменеджменту

## Відповідність стандартам та інтеграція

Цей документ описує інтеграцію системи енергоменеджменту з обладнанням та системами у відповідності до вимог:

- [ISO 50001](ISO_50001.md) - вимоги до інтеграції з бізнес-процесами
- [ISO 50006](ISO_50006.md) - вимоги до збору даних
- [ISO 50015](ISO_50015.md) - вимоги до якості даних

Інтеграція забезпечує дані для:
- [Моніторинг](MONITORING.md) - збір та обробка даних
- [Оптимізація](OPTIMIZATION.md) - керування обладнанням

## Протоколи зв'язку

### 1. Modbus TCP/RTU
```javascript
// Конфігурація Modbus пристрою згідно ISO 50006
{
  "device": {
    "name": "Energy Meter",
    "type": "Modbus Device",
    "protocol": "Modbus TCP",
    "configuration": {
      "host": "192.168.1.100",
      "port": 502,
      "unitId": 1,
      "encoding": "UTF-8",
      "timeout": 3000,
      "registers": [
        {
          "tag": "voltage",
          "address": 3000,
          "type": "HOLDING",
          "dataType": "FLOAT32",
          "multiplier": 1.0
        },
        {
          "tag": "current",
          "address": 3002,
          "type": "HOLDING",
          "dataType": "FLOAT32",
          "multiplier": 1.0
        },
        {
          "tag": "power",
          "address": 3004,
          "type": "HOLDING",
          "dataType": "FLOAT32",
          "multiplier": 1.0
        }
      ]
    }
  }
}
```

### 2. OPC UA
```javascript
// Конфігурація OPC UA клієнта згідно ISO 50006
{
  "client": {
    "name": "SCADA Integration",
    "type": "OPC UA Client",
    "configuration": {
      "serverUrl": "opc.tcp://server:4840",
      "securityPolicy": "Basic256Sha256",
      "securityMode": "SignAndEncrypt",
      "authentication": {
        "type": "username",
        "username": "${username}",
        "password": "${password}"
      },
      "nodes": [
        {
          "nodeId": "ns=2;s=Device1.Temperature",
          "tag": "temperature",
          "dataType": "Double",
          "scanRate": 1000
        },
        {
          "nodeId": "ns=2;s=Device1.Pressure",
          "tag": "pressure",
          "dataType": "Double",
          "scanRate": 1000
        }
      ]
    }
  }
}
```

### 3. BACnet
```javascript
// Конфігурація BACnet пристрою згідно ISO 50006
{
  "device": {
    "name": "HVAC Controller",
    "type": "BACnet Device",
    "configuration": {
      "deviceId": 1234,
      "networkNumber": 1,
      "macAddress": "10",
      "objects": [
        {
          "type": "analogInput",
          "instanceNumber": 1,
          "tag": "roomTemperature",
          "units": "degreesCelsius",
          "scanRate": 5000
        },
        {
          "type": "analogOutput",
          "instanceNumber": 1,
          "tag": "setpoint",
          "units": "degreesCelsius",
          "writeable": true
        }
      ]
    }
  }
}
```

## Інтеграція обладнання

### 1. Лічильники електроенергії
```javascript
// Конфігурація інтеграції лічильника згідно ISO 50006
function configureMeter(meter) {
  return {
    // Базова конфігурація
    basic: {
      manufacturer: meter.manufacturer,
      model: meter.model,
      serialNumber: meter.serialNumber,
      protocol: meter.protocol
    },
    
    // Параметри вимірювання згідно ISO 50015
    measurements: {
      voltage: configureVoltage(meter),
      current: configureCurrent(meter),
      power: configurePower(meter),
      energy: configureEnergy(meter)
    },
    
    // Налаштування зв'язку
    communication: {
      interface: configureInterface(meter),
      protocol: configureProtocol(meter),
      security: configureSecurity(meter)
    }
  };
}
```

### 2. Системи автоматизації
```javascript
// Інтеграція з SCADA згідно ISO 50001
function integrateSCADA(system) {
  return {
    // Точки даних згідно ISO 50006
    dataPoints: {
      inputs: mapInputs(system),
      outputs: mapOutputs(system),
      parameters: mapParameters(system)
    },
    
    // Керування
    control: {
      commands: mapCommands(system),
      feedback: mapFeedback(system),
      alarms: mapAlarms(system)
    },
    
    // Синхронізація
    synchronization: {
      data: configureSyncData(system),
      time: configureSyncTime(system),
      events: configureSyncEvents(system)
    }
  };
}
```

## Обробка даних

### 1. Перетворення даних
```javascript
// Rule Chain для обробки даних згідно ISO 50015
{
  "ruleChain": {
    "name": "Data Integration",
    "type": "CORE",
    "firstRuleNodeId": "process-data",
    "nodes": [
      {
        "id": "process-data",
        "type": "TRANSFORMATION",
        "name": "Process Measurements",
        "configuration": {
          "jsScript": `
            // Конвертація одиниць вимірювання
            function convertUnits(value, from, to) {
              switch(from + '_to_' + to) {
                case 'wh_to_kwh':
                  return value / 1000;
                case 'w_to_kw':
                  return value / 1000;
                default:
                  return value;
              }
            }
            
            // Обробка вимірювань згідно ISO 50006
            var processed = {};
            for (var key in msg) {
              if (metadata.units && metadata.units[key]) {
                processed[key] = convertUnits(
                  msg[key],
                  metadata.units[key].from,
                  metadata.units[key].to
                );
              } else {
                processed[key] = msg[key];
              }
            }
            
            return {msg: processed, metadata: metadata, msgType: msgType};
          `
        }
      }
    ]
  }
}
```

### 2. Валідація даних
```javascript
// Валідація вимірювань згідно ISO 50015
function validateMeasurements(data) {
  return {
    // Перевірка діапазонів
    range: {
      min: checkMinValues(data),
      max: checkMaxValues(data),
      rate: checkRateOfChange(data)
    },
    
    // Перевірка якості
    quality: {
      completeness: checkCompleteness(data),
      consistency: checkConsistency(data),
      accuracy: checkAccuracy(data)
    },
    
    // Коригування даних
    correction: {
      filtering: filterOutliers(data),
      interpolation: interpolateGaps(data),
      averaging: calculateAverages(data)
    }
  };
}
```

## Безпека

### 1. Автентифікація та авторизація
```javascript
// Налаштування безпеки згідно ISO 50001
{
  "security": {
    "authentication": {
      "type": "certificate",
      "certificate": {
        "type": "X.509",
        "format": "PEM",
        "location": "/certs/device.crt"
      },
      "privateKey": {
        "format": "PEM",
        "location": "/certs/device.key"
      }
    },
    "authorization": {
      "type": "role-based",
      "roles": [
        {
          "name": "operator",
          "permissions": ["read", "write"]
        },
        {
          "name": "admin",
          "permissions": ["read", "write", "configure"]
        }
      ]
    }
  }
}
```

### 2. Шифрування даних
```yaml
Методи:
  - TLS для передачі даних
  - AES для зберігання даних
  - RSA для обміну ключами
```

## Діагностика та обслуговування

### 1. Моніторинг з'єднань
```javascript
// Діагностика підключень згідно ISO 50015
function monitorConnections(devices) {
  return {
    // Стан з'єднання
    status: {
      online: checkOnlineStatus(devices),
      latency: measureLatency(devices),
      quality: assessConnectionQuality(devices)
    },
    
    // Діагностика проблем
    diagnostics: {
      errors: collectErrors(devices),
      timeouts: detectTimeouts(devices),
      retries: countRetries(devices)
    }
  };
}
```

### 2. Обслуговування
```yaml
Процедури згідно ISO 50001:
  - Резервне копіювання конфігурації
  - Оновлення прошивки
  - Калібрування обладнання
  - Планове обслуговування
```

## Додаткові матеріали

- [Приклади конфігурацій](examples/configs/)
- [Шаблони інтеграції](examples/templates/)
- [Протоколи тестування](examples/testing/)
