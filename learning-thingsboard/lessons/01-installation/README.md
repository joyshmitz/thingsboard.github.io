# Встановлення та налаштування ThingsBoard

## 1. Встановлення за допомогою Docker Compose

### Що таке Docker і навіщо він потрібен?
Docker - це платформа для розробки, доставки і запуску застосунків у контейнерах. Контейнери - це легкі, автономні пакети, які містять все необхідне для запуску програми: код, середовище виконання, системні інструменти, бібліотеки та налаштування.

Переваги використання Docker для ThingsBoard:
- Швидке розгортання
- Ізоляція компонентів
- Простота оновлення
- Однакове середовище на різних машинах

### Передумови

#### Системні вимоги
- CPU: 2 ядра (рекомендовано 4)
- RAM: мінімум 4GB (рекомендовано 8GB)
- Диск: мінімум 10GB вільного місця
- Операційна система: Linux (Ubuntu 20.04 або новіше рекомендовано)

#### Необхідне програмне забезпечення
1. **Docker Engine**
   ```bash
   # Встановлення Docker на Ubuntu
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   sudo usermod -aG docker $USER  # Додавання користувача до групи docker
   ```

2. **Docker Compose**
   ```bash
   # Встановлення Docker Compose
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

#### Відкриті порти
ThingsBoard використовує наступні порти:
- 9090: Web UI та API
- 1883: MQTT протокол (для пристроїв)
- 5683/5684: CoAP протокол (для пристроїв)
- 7070: Edge RPC (для edge обчислень)
- 9003: Transport RPC

```bash
# Перевірка чи порти вільні
sudo netstat -tulpn | grep -E '9090|1883|5683|7070|9003'
```

### Покрокове встановлення

#### 1. Створення робочої директорії
```bash
# Створюємо директорію для ThingsBoard
mkdir ~/thingsboard
cd ~/thingsboard

# Створюємо директорії для даних та логів
mkdir -p ~/.mytb-data && sudo chown -R 799:799 ~/.mytb-data
mkdir -p ~/.mytb-logs && sudo chown -R 799:799 ~/.mytb-logs
```

#### 2. Створення docker-compose.yml
Створіть файл `docker-compose.yml` з наступним вмістом:

```yaml
version: '3.0'
services:
  mytb:
    restart: always
    image: thingsboard/tb-postgres
    ports:
      - "9090:9090"
      - "1883:1883"
      - "7070:7070"
      - "5683-5684:5683-5684/udp"
      - "9003:9003"
    environment:
      TB_QUEUE_TYPE: in-memory  # Тип черги повідомлень (для початку використовуємо in-memory)
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/thingsboard
      SPRING_DATASOURCE_USERNAME: postgres
      SPRING_DATASOURCE_PASSWORD: postgres
    volumes:
      - ~/.mytb-data:/data
      - ~/.mytb-logs:/var/log/thingsboard
    depends_on:
      - postgres

  postgres:
    restart: always
    image: postgres:12
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: thingsboard
      POSTGRES_PASSWORD: postgres
    volumes:
      - ~/.mytb-data/db:/var/lib/postgresql/data

volumes:
  mytb-data:
  mytb-logs:
  postgres-data:
```

> **Пояснення конфігурації:**
> - `restart: always`: автоматичний перезапуск контейнерів при збої або перезавантаженні системи
> - `volumes`: монтування локальних директорій для збереження даних
> - `environment`: змінні середовища для налаштування ThingsBoard
> - `depends_on`: визначає залежності між сервісами

#### 3. Запуск системи
```bash
# Завантаження образів
docker-compose pull

# Запуск у фоновому режимі
docker-compose up -d

# Перевірка статусу
docker-compose ps

# Перегляд логів
docker-compose logs -f
```

#### 4. Перевірка роботи
1. Відкрийте браузер і перейдіть за адресою: http://localhost:9090
2. Використовуйте стандартні облікові дані:
   - Системний адміністратор:
     - Email: sysadmin@thingsboard.org
     - Пароль: sysadmin
   - Tenant адміністратор:
     - Email: tenant@thingsboard.org
     - Пароль: tenant

### Базове обслуговування

#### Команди для щоденного використання
```bash
# Зупинка сервісів
docker-compose stop

# Запуск сервісів
docker-compose start

# Перезапуск сервісів
docker-compose restart

# Повна зупинка з видаленням контейнерів
docker-compose down

# Перегляд логів конкретного сервісу
docker-compose logs -f mytb
docker-compose logs -f postgres
```

#### Оновлення версії
```bash
# Зупинка сервісів
docker-compose stop

# Завантаження нових версій образів
docker-compose pull

# Оновлення бази даних
docker run -it -v ~/.mytb-data:/data --rm thingsboard/tb-postgres upgrade-tb.sh

# Запуск оновлених сервісів
docker-compose up -d
```

### Резервне копіювання

#### Backup бази даних
```bash
# Створення бекапу PostgreSQL
docker-compose exec postgres pg_dump -U postgres thingsboard > backup.sql

# Відновлення з бекапу
cat backup.sql | docker-compose exec -T postgres psql -U postgres thingsboard
```

#### Backup даних ThingsBoard
```bash
# Архівування директорій з даними
tar -czf thingsboard-data-backup.tar.gz ~/.mytb-data
tar -czf thingsboard-logs-backup.tar.gz ~/.mytb-logs
```

### Типові проблеми та їх вирішення

1. **Помилка "port is already allocated"**
   ```bash
   # Перевірка зайнятих портів
   sudo lsof -i :9090
   
   # Зупинка процесу, що використовує порт
   sudo kill -9 PID
   ```

2. **Недостатньо пам'яті**
   ```bash
   # Перевірка використання пам'яті
   docker stats
   
   # Збільшення swap файлу
   sudo fallocate -l 4G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```

3. **Проблеми з правами доступу**
   ```bash
   # Виправлення прав доступу
   sudo chown -R 799:799 ~/.mytb-data
   sudo chown -R 799:799 ~/.mytb-logs
   ```

## Корисні посилання
- [Офіційна документація ThingsBoard](https://thingsboard.io/docs/)
- [Docker документація](https://docs.docker.com/)
- [Docker Compose документація](https://docs.docker.com/compose/)
- [PostgreSQL документація](https://www.postgresql.org/docs/)
