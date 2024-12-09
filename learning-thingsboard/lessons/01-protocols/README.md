# Урок 1: Основні протоколи ThingsBoard - MQTT та Modbus

## Зміст
1. [MQTT протокол](#mqtt-протокол)
2. [Modbus протокол](#modbus-протокол)
3. [Практичні приклади](#практичні-приклади)

## MQTT протокол

### Що таке MQTT?
MQTT (Message Queuing Telemetry Transport) - це легкий протокол обміну повідомленнями, який працює за принципом publish/subscribe. Він ідеально підходить для IoT пристроїв через:
- Низьке споживання ресурсів
- Мінімальний мережевий трафік
- Надійність доставки повідомлень
- Підтримку QoS (Quality of Service)

### Основні концепції MQTT в ThingsBoard
1. **Топіки (Topics)**
   - `v1/devices/me/telemetry` - для відправки телеметрії
   - `v1/devices/me/attributes` - для роботи з атрибутами
   - `v1/devices/me/rpc/request/+` - для RPC запитів
   - `v1/devices/me/rpc/response/+` - для RPC відповідей

2. **Формат повідомлень**
```json
{
    "temperature": 24.5,
    "humidity": 68,
    "timestamp": 1638364800000
}
```

3. **Аутентифікація**
   - Використання Access Token
   - SSL/TLS сертифікати
   - Basic аутентифікація

### Приклад підключення через MQTT
```python
import paho.mqtt.client as mqtt
import json
import time

# Налаштування MQTT клієнта
client = mqtt.Client()
client.username_pw_set("YOUR_ACCESS_TOKEN")
client.connect("demo.thingsboard.io", 1883, 60)

# Відправка телеметрії
def send_telemetry():
    telemetry = {
        "temperature": 25.5,
        "humidity": 56
    }
    client.publish('v1/devices/me/telemetry', json.dumps(telemetry))

# Основний цикл
client.loop_start()
send_telemetry()
```

## Modbus протокол

### Що таке Modbus?
Modbus - це протокол прикладного рівня для промислових пристроїв, який дозволяє здійснювати зв'язок між обладнанням за принципом клієнт-сервер (master-slave).

### Типи Modbus
1. **Modbus RTU**
   - Послідовний інтерфейс (RS-485/RS-232)
   - Бінарний формат даних
   - Використовується в промисловості

2. **Modbus TCP**
   - Працює через TCP/IP
   - Простіша інтеграція з сучасними мережами
   - Підтримує більше пристроїв

### Налаштування Modbus в ThingsBoard

1. **Конфігурація Modbus-пристрою**
```json
{
    "deviceName": "Modbus Device",
    "deviceType": "default",
    "connectRequests": [
        {
            "host": "192.168.1.100",
            "port": 502,
            "unitId": 1,
            "encoding": "RTU",
            "timeout": 3000
        }
    ],
    "attributes": [
        {
            "tag": "serialNumber",
            "type": "string",
            "functionCode": 3,
            "address": 100,
            "registerCount": 4
        }
    ],
    "timeseries": [
        {
            "tag": "temperature",
            "type": "double",
            "functionCode": 4,
            "address": 200,
            "registerCount": 2,
            "multiplier": 0.1
        }
    ]
}
```

2. **Функціональні коди Modbus**
   - FC01: Read Coils
   - FC02: Read Discrete Inputs
   - FC03: Read Holding Registers
   - FC04: Read Input Registers
   - FC05: Write Single Coil
   - FC06: Write Single Register
   - FC15: Write Multiple Coils
   - FC16: Write Multiple Registers

## Практичні приклади

### 1. Підключення MQTT пристрою
1. Створіть новий пристрій в ThingsBoard
2. Отримайте Access Token
3. Використовуйте наведений вище Python-код для підключення
4. Перевірте отримання даних в ThingsBoard

### 2. Налаштування Modbus пристрою
1. Додайте новий Modbus пристрій
2. Налаштуйте конфігурацію згідно прикладу вище
3. Перевірте з'єднання
4. Налаштуйте відображення даних на дашборді

## Додаткові ресурси
- [Офіційна документація MQTT в ThingsBoard](https://thingsboard.io/docs/reference/mqtt-api/)
- [Документація Modbus інтеграції](https://thingsboard.io/docs/user-guide/integrations/modbus/)
- [Приклади MQTT клієнтів](https://thingsboard.io/docs/reference/mqtt-api/#client-side-rpc)
