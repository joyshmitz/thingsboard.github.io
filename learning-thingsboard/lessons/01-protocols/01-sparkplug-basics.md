# Урок 1.1: Основи Sparkplug B для початківців

## Що ми вивчимо
1. Розуміння архітектури MQTT та Sparkplug B
2. Встановлення необхідного програмного забезпечення
3. Створення першого Sparkplug B додатку
4. Тестування та перевірка роботи

## Передумови
Перед початком вам потрібно:
1. Базове розуміння що таке IoT
2. Встановлений Python 3.7 або новіший
3. Базові навички роботи з терміналом

## 1. Розуміння архітектури

### 1.1 Що таке MQTT?
MQTT - це протокол обміну повідомленнями, який працює за принципом "публікація/підписка". Уявіть собі поштову скриньку:
- Відправник (Publisher) кладе лист у скриньку
- Отримувач (Subscriber) перевіряє скриньку і забирає лист
- Поштова скринька - це брокер MQTT

### 1.2 Що таке Sparkplug B?
Sparkplug B - це стандарт, який визначає:
- Як правильно використовувати MQTT для промислових пристроїв
- Як структурувати дані
- Як забезпечити надійну комунікацію

Уявіть Sparkplug B як правила написання листів:
- Конверт має бути певного формату (структура топіків)
- Лист має бути написаний за певними правилами (формат даних)
- Потрібно підтверджувати отримання (механізм Birth/Death)

## 2. Встановлення необхідного ПЗ

### 2.1 Встановлення Python
```bash
# Перевірка версії Python
python3 --version

# Якщо Python не встановлено, встановіть його з python.org
```

### 2.2 Встановлення необхідних бібліотек
```bash
# Створення віртуального середовища
python3 -m venv sparkplug_env
source sparkplug_env/bin/activate  # для Linux/Mac
# або
.\sparkplug_env\Scripts\activate  # для Windows

# Встановлення бібліотек
pip install paho-mqtt
pip install sparkplug-client
```

## 3. Перший Sparkplug B додаток

### 3.1 Структура проекту
```
sparkplug_project/
├── sparkplug_env/
├── config.py
├── edge_node.py
└── requirements.txt
```

### 3.2 Створення конфігураційного файлу (config.py)
```python
# config.py

# Налаштування MQTT брокера
MQTT_HOST = "localhost"
MQTT_PORT = 1883

# Налаштування Sparkplug B
GROUP_ID = "SparkplugDemo"
EDGE_NODE_ID = "Python-Edge-Node"
DEVICE_ID = "Sensor-01"

# Налаштування безпеки
USERNAME = "your_username"
PASSWORD = "your_password"
```

### 3.3 Створення Edge Node (edge_node.py)
```python
# edge_node.py
import time
import json
from paho.mqtt import client as mqtt
import config

class SparkplugEdgeNode:
    def __init__(self):
        # Створення MQTT клієнта
        self.client = mqtt.Client(config.EDGE_NODE_ID)
        self.client.username_pw_set(config.USERNAME, config.PASSWORD)
        
        # Налаштування обробників подій
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        
        # Лічильник послідовності
        self.seq = 0
    
    def connect(self):
        """Підключення до MQTT брокера"""
        print("Підключення до брокера...")
        self.client.connect(config.MQTT_HOST, config.MQTT_PORT, 60)
    
    def on_connect(self, client, userdata, flags, rc):
        """Обробник події підключення"""
        if rc == 0:
            print("Успішно підключено до брокера!")
            self.publish_node_birth()
        else:
            print(f"Помилка підключення, код: {rc}")
    
    def publish_node_birth(self):
        """Публікація NBIRTH повідомлення"""
        topic = f"spBv1.0/{config.GROUP_ID}/NBIRTH/{config.EDGE_NODE_ID}"
        
        payload = {
            "timestamp": int(time.time() * 1000),
            "metrics": [
                {
                    "name": "Node Control/Scan Rate",
                    "value": 1000,
                    "type": "Int32"
                },
                {
                    "name": "Properties/Version",
                    "value": "v1.0",
                    "type": "String"
                }
            ],
            "seq": self.seq
        }
        
        print("Відправка NBIRTH повідомлення...")
        self.client.publish(topic, json.dumps(payload), qos=0, retain=True)
        self.seq += 1
    
    def publish_data(self, value):
        """Публікація даних"""
        topic = f"spBv1.0/{config.GROUP_ID}/NDATA/{config.EDGE_NODE_ID}"
        
        payload = {
            "timestamp": int(time.time() * 1000),
            "metrics": [
                {
                    "name": "Sensor/Value",
                    "value": value,
                    "type": "Double"
                }
            ],
            "seq": self.seq
        }
        
        print(f"Відправка даних: {value}")
        self.client.publish(topic, json.dumps(payload), qos=0)
        self.seq += 1
    
    def on_message(self, client, userdata, msg):
        """Обробник вхідних повідомлень"""
        print(f"Отримано повідомлення: {msg.topic}")
        print(f"Payload: {msg.payload.decode()}")
    
    def start(self):
        """Запуск Edge Node"""
        self.connect()
        self.client.loop_start()
        
        # Основний цикл роботи
        try:
            while True:
                # Симуляція даних сенсора
                sensor_value = 25.5  # Можна замінити на реальні дані
                self.publish_data(sensor_value)
                time.sleep(5)  # Пауза 5 секунд
        except KeyboardInterrupt:
            print("Завершення роботи...")
            self.client.loop_stop()
            self.client.disconnect()

if __name__ == "__main__":
    node = SparkplugEdgeNode()
    node.start()
```

## 4. Запуск та тестування

### 4.1 Підготовка до запуску
1. Переконайтеся, що у вас запущений MQTT брокер
2. Активуйте віртуальне середовище:
```bash
source sparkplug_env/bin/activate  # для Linux/Mac
# або
.\sparkplug_env\Scripts\activate  # для Windows
```

### 4.2 Запуск програми
```bash
python edge_node.py
```

### 4.3 Що відбувається?
1. Програма підключається до MQTT брокера
2. Відправляє NBIRTH повідомлення
3. Починає публікувати дані кожні 5 секунд
4. Обробляє вхідні повідомлення

### 4.4 Перевірка роботи
1. Використовуйте MQTT клієнт (наприклад, MQTT Explorer) для перегляду повідомлень
2. Перевірте топіки:
   - `spBv1.0/SparkplugDemo/NBIRTH/Python-Edge-Node`
   - `spBv1.0/SparkplugDemo/NDATA/Python-Edge-Node`

## Додаткові матеріали

### Корисні інструменти
1. MQTT Explorer - для перегляду MQTT повідомлень
2. Wireshark - для аналізу мережевого трафіку
3. Python debugger (pdb) - для налагодження коду

### Наступні кроки
1. Додавання обробки помилок
2. Реалізація механізму DEATH повідомлень
3. Робота з реальними сенсорами
4. Налаштування безпеки

## Часті питання (FAQ)

1. **Що робити, якщо не вдається підключитися до брокера?**
   - Перевірте, чи запущений брокер
   - Перевірте налаштування host та port
   - Перевірте облікові дані

2. **Чому важливо використовувати seq (послідовність)?**
   - Для виявлення пропущених повідомлень
   - Для забезпечення порядку повідомлень
   - Для відстеження стану сесії

3. **Як часто потрібно відправляти дані?**
   - Залежить від вашого випадку використання
   - Типово від 1 секунди до кількох хвилин
   - Враховуйте обмеження мережі та пристроїв
