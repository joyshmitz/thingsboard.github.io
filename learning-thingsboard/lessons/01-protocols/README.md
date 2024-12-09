# Урок 1: Основні протоколи ThingsBoard - MQTT та Modbus

## Зміст
1. [MQTT та Sparkplug B](#mqtt-та-sparkplug-b)
2. [Modbus протокол](#modbus-протокол)
3. [Практичні приклади](#практичні-приклади)

## MQTT та Sparkplug B

### Що таке MQTT?
MQTT (Message Queuing Telemetry Transport) - це легкий протокол обміну повідомленнями, який працює за принципом publish/subscribe. Він ідеально підходить для IoT пристроїв через:
- Низьке споживання ресурсів
- Мінімальний мережевий трафік
- Надійність доставки повідомлень
- Підтримку QoS (Quality of Service)

### Sparkplug B специфікація

#### Основні концепції Sparkplug B
Sparkplug B - це специфікація, що визначає:
- Стандартизований спосіб використання MQTT для промислових додатків
- Чітко визначену структуру топіків
- Формат корисного навантаження (payload)
- Стан сесії та народження/смерть вузлів

#### Структура топіків Sparkplug B
```
spBv1.0/{group_id}/{message_type}/{edge_node_id}/{device_id}
```
де:
- `spBv1.0` - версія протоколу
- `group_id` - ідентифікатор групи
- `message_type` - тип повідомлення (NBIRTH, NDEATH, DBIRTH, DDEATH, NDATA, DDATA, NCMD, DCMD)
- `edge_node_id` - ідентифікатор крайового вузла
- `device_id` - ідентифікатор пристрою (опціонально)

#### Типи повідомлень Sparkplug B
1. **BIRTH повідомлення**
   - `NBIRTH` (Node Birth) - публікується при підключенні вузла
   - `DBIRTH` (Device Birth) - публікується при підключенні пристрою

2. **DEATH повідомлення**
   - `NDEATH` (Node Death) - публікується при відключенні вузла
   - `DDEATH` (Device Death) - публікується при відключенні пристрою

3. **DATA повідомлення**
   - `NDATA` (Node Data) - дані від вузла
   - `DDATA` (Device Data) - дані від пристрою

4. **COMMAND повідомлення**
   - `NCMD` (Node Command) - команди для вузла
   - `DCMD` (Device Command) - команди для пристрою

#### Приклад Sparkplug B повідомлення
```json
{
    "timestamp": 1638364800000,
    "metrics": [
        {
            "name": "Temperature",
            "value": 25.5,
            "type": "Double",
            "timestamp": 1638364800000
        },
        {
            "name": "Status",
            "value": "Running",
            "type": "String",
            "timestamp": 1638364800000
        }
    ],
    "seq": 0
}
```

#### Налаштування Sparkplug B в ThingsBoard

1. **Конфігурація з'єднання**
```python
import paho.mqtt.client as mqtt
from sparkplug_b import *

# Налаштування клієнта
client = mqtt.Client("Edge Node 1")
client.username_pw_set("YOUR_ACCESS_TOKEN")

# Налаштування Sparkplug B
groupId = "Group1"
edgeNode = "Edge1"
deviceId = "Device1"

# Створення NBIRTH повідомлення
def create_nbirth():
    payload = {
        "timestamp": current_time_millis(),
        "metrics": [
            {"name": "Node Control/Scan Rate", "value": 1000, "type": "Int32"},
            {"name": "Properties/Version", "value": "v1.0", "type": "String"}
        ]
    }
    return payload

# Публікація NBIRTH
def publish_nbirth():
    topic = f"spBv1.0/{groupId}/NBIRTH/{edgeNode}"
    payload = create_nbirth()
    client.publish(topic, json.dumps(payload), qos=0, retain=True)
```

2. **Обробка подій**
```python
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        publish_nbirth()
        # Підписка на команди
        topic = f"spBv1.0/{groupId}/NCMD/{edgeNode}/+"
        client.subscribe(topic, qos=0)

def on_message(client, userdata, msg):
    # Обробка вхідних повідомлень
    topic = msg.topic
    payload = json.loads(msg.payload.decode())
    
    if "NCMD" in topic:
        handle_command(payload)
```

### Найкращі практики Sparkplug B

1. **Керування станом**
   - Завжди публікуйте BIRTH повідомлення при підключенні
   - Використовуйте Last Will and Testament (LWT) для DEATH повідомлень
   - Підтримуйте послідовність номерів (seq) для виявлення пропущених повідомлень

2. **Метрики**
   - Використовуйте узгоджені імена метрик
   - Включайте часові мітки для кожної метрики
   - Групуйте пов'язані метрики

3. **Безпека**
   - Використовуйте TLS для шифрування
   - Налаштуйте автентифікацію на рівні клієнта
   - Контролюйте доступ до топіків

### Моніторинг та діагностика

1. **Відстеження стану вузлів**
```python
def monitor_node_state():
    # Підписка на DEATH повідомлення
    death_topic = f"spBv1.0/{groupId}/NDEATH/{edgeNode}"
    client.subscribe(death_topic, qos=0)
    
    # Налаштування LWT
    client.will_set(death_topic, json.dumps({
        "timestamp": current_time_millis(),
        "metrics": []
    }), qos=0, retain=True)
```

2. **Логування подій**
```python
def log_sparkplug_event(event_type, details):
    logger.info(f"Sparkplug B Event: {event_type}")
    logger.debug(f"Details: {details}")
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
