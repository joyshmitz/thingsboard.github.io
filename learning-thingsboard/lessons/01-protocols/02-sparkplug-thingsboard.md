# Урок 1.2: Інтеграція Sparkplug B з ThingsBoard

## Зміст
1. [Налаштування профілю пристрою](#налаштування-профілю-пристрою)
2. [Створення пристрою](#створення-пристрою)
3. [Робота з телеметрією та атрибутами](#робота-з-телеметрією-та-атрибутами)
4. [Практичний приклад](#практичний-приклад)

## Налаштування профілю пристрою

### Крок 1: Створення профілю MQTT EoN Node
1. Перейдіть до сторінки "Device profiles"
2. Натисніть "+" для створення нового профілю
3. Введіть назву (наприклад, "MQTT EoN Node")
4. Перейдіть до вкладки "Transport configuration"
5. Виберіть тип транспорту MQTT
6. Увімкніть опцію "MQTT Sparkplug B Edge of Network (EoN) node"
7. Вкажіть метрики Sparkplug, які потрібно зберігати як атрибути

```json
{
    "metrics": [
        "Device Control/Scan Rate",
        "Properties/Version",
        "Outputs/LEDs/*"
    ]
}
```

## Створення пристрою

### Крок 2: Налаштування Edge Node пристрою
1. Перейдіть до сторінки "Devices"
2. Створіть новий пристрій
3. Виберіть створений профіль "MQTT EoN Node"
4. Отримайте access token для автентифікації

### Крок 3: Оновлення нашого Python коду
```python
# sparkplug_thingsboard.py
import time
import json
from paho.mqtt import client as mqtt

# Налаштування ThingsBoard
THINGSBOARD_HOST = "demo.thingsboard.io"
ACCESS_TOKEN = "YOUR_ACCESS_TOKEN"

# Налаштування Sparkplug B
GROUP_ID = "Group1"
EDGE_NODE_ID = "Python-Edge-Node"
DEVICE_ID = "Sensor-01"

class SparkplugThingsBoard:
    def __init__(self):
        self.client = mqtt.Client(EDGE_NODE_ID)
        self.client.username_pw_set(ACCESS_TOKEN)
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        self.seq = 0
        
    def connect(self):
        print("Підключення до ThingsBoard...")
        self.client.connect(THINGSBOARD_HOST, 1883, 60)
        
    def publish_birth_certificate(self):
        topic = f"spBv1.0/{GROUP_ID}/NBIRTH/{EDGE_NODE_ID}"
        payload = {
            "timestamp": int(time.time() * 1000),
            "metrics": [
                {
                    "name": "Device Control/Scan Rate",
                    "value": 1000,
                    "type": "Int32"
                },
                {
                    "name": "Properties/Version",
                    "value": "v1.0",
                    "type": "String"
                },
                {
                    "name": "Outputs/LEDs/Green",
                    "value": True,
                    "type": "Boolean"
                },
                {
                    "name": "Outputs/LEDs/Yellow",
                    "value": False,
                    "type": "Boolean"
                }
            ],
            "seq": self.seq
        }
        self.client.publish(topic, json.dumps(payload), qos=0, retain=True)
        self.seq += 1
        
    def publish_data(self, temperature, humidity):
        topic = f"spBv1.0/{GROUP_ID}/NDATA/{EDGE_NODE_ID}"
        payload = {
            "timestamp": int(time.time() * 1000),
            "metrics": [
                {
                    "name": "Sensors/Temperature",
                    "value": temperature,
                    "type": "Double"
                },
                {
                    "name": "Sensors/Humidity",
                    "value": humidity,
                    "type": "Double"
                }
            ],
            "seq": self.seq
        }
        self.client.publish(topic, json.dumps(payload), qos=0)
        self.seq += 1
        
    def on_connect(self, client, userdata, flags, rc):
        if rc == 0:
            print("Успішно підключено до ThingsBoard!")
            self.publish_birth_certificate()
            # Підписка на команди
            topic = f"spBv1.0/{GROUP_ID}/NCMD/{EDGE_NODE_ID}/+"
            self.client.subscribe(topic, qos=0)
        else:
            print(f"Помилка підключення, код: {rc}")
            
    def on_message(self, client, userdata, msg):
        print(f"Отримано повідомлення: {msg.topic}")
        try:
            payload = json.loads(msg.payload.decode())
            print(f"Payload: {payload}")
            
            # Обробка команд
            if "NCMD" in msg.topic:
                self.handle_command(payload)
        except Exception as e:
            print(f"Помилка обробки повідомлення: {e}")
            
    def handle_command(self, payload):
        if "metrics" in payload:
            for metric in payload["metrics"]:
                name = metric["name"]
                value = metric["value"]
                print(f"Отримано команду: {name} = {value}")
                
                # Обробка специфічних команд
                if name == "Device Control/Scan Rate":
                    print(f"Зміна частоти сканування на {value} мс")
                elif name.startswith("Outputs/LEDs/"):
                    print(f"Зміна стану LED: {name} = {value}")
    
    def start(self):
        self.connect()
        self.client.loop_start()
        
        try:
            while True:
                # Симуляція даних сенсорів
                temperature = 25.5 + (time.time() % 1)
                humidity = 60 + (time.time() % 5)
                self.publish_data(temperature, humidity)
                time.sleep(5)
        except KeyboardInterrupt:
            print("Завершення роботи...")
            self.client.loop_stop()
            self.client.disconnect()

if __name__ == "__main__":
    node = SparkplugThingsBoard()
    node.start()
```

## Робота з телеметрією та атрибутами

### Перегляд даних в ThingsBoard
1. Відкрийте сторінку пристрою
2. Перейдіть на вкладку "Latest telemetry"
3. Ви побачите дані температури та вологості
4. На вкладці "Attributes" будуть доступні налаштування LED та інші конфігураційні параметри

### Керування пристроєм
1. Зміна атрибутів:
   - Відкрийте вкладку "Shared attributes"
   - Змініть значення "Outputs/LEDs/Green"
   - Пристрій отримає оновлення через MQTT

2. Відправка команд:
   - Використовуйте RPC для відправки команд
   - Можна змінювати частоту сканування
   - Керувати станом LED

## Практичний приклад

### Створення дашборду
1. Створіть новий дашборд
2. Додайте віджети:
   - Графік температури
   - Графік вологості
   - Перемикачі для LED
   - Поле введення для частоти сканування

### Налаштування віджетів
1. Для графіків:
   - Використовуйте telemetry keys: "Sensors/Temperature" та "Sensors/Humidity"
   - Налаштуйте інтервал оновлення

2. Для перемикачів:
   - Використовуйте shared attributes: "Outputs/LEDs/Green" та "Outputs/LEDs/Yellow"
   - Налаштуйте RPC виклики

## Додаткові можливості

### Обробка помилок
1. Додайте механізм перепідключення
2. Обробляйте втрату зв'язку
3. Зберігайте дані локально при відсутності зв'язку

### Безпека
1. Використовуйте SSL/TLS
2. Налаштуйте правила доступу
3. Моніторинг підключень

## Корисні поради
1. Використовуйте унікальні ідентифікатори для Group ID та Edge Node ID
2. Зберігайте послідовність повідомлень (seq)
3. Обробляйте всі можливі стани пристрою
4. Логуйте важливі події для діагностики
