# Система енергетичного менеджменту на базі ThingsBoard PE

## Відповідність стандартам

### ISO 50001 - Система енергетичного менеджменту
```yaml
Компоненти системи:
  1. Енергетична політика:
     - Визначення цілей та зобов'язань
     - Встановлення KPI
     - Планування заходів
  
  2. Енергетичне планування:
     - Аналіз енергоспоживання
     - Визначення базового рівня
     - Ідентифікація можливостей
  
  3. Впровадження та функціонування:
     - Збір даних в реальному часі
     - Моніторинг показників
     - Автоматизація процесів
  
  4. Перевірка:
     - Моніторинг та вимірювання
     - Внутрішній аудит
     - Коригувальні дії
  
  5. Аналіз з боку керівництва:
     - Огляд результатів
     - Прийняття рішень
     - Оновлення цілей
```

### ISO 50006 - Вимірювання рівня досягнутої/досяжної енергоефективності
```yaml
Методологія:
  1. Визначення показників:
     - EnPI (Energy Performance Indicators)
     - Базові лінії енергоспоживання
     - Цільові показники
  
  2. Збір даних:
     - Автоматизований збір
     - Валідація даних
     - Зберігання історії
  
  3. Аналіз:
     - Нормалізація даних
     - Кореляційний аналіз
     - Виявлення трендів
  
  4. Звітність:
     - Динаміка показників
     - Порівняння з базовою лінією
     - Прогнозування
```

### ISO 50015 - Вимірювання та верифікація енергоефективності
```yaml
Процеси:
  1. План вимірювань:
     - Визначення меж
     - Вибір методології
     - Визначення періодів
  
  2. Збір даних:
     - Точки вимірювання
     - Частота збору
     - Якість даних
  
  3. Верифікація:
     - Перевірка достовірності
     - Коригування даних
     - Оцінка невизначеності
  
  4. Звітність:
     - Документування результатів
     - Аналіз відхилень
     - Рекомендації
```

## Реалізація в ThingsBoard

### 1. Структура активів
```javascript
{
  "assets": {
    "EnMS": {
      "type": "EnMS",
      "name": "Система енергоменеджменту",
      "children": {
        "buildings": [
          {
            "type": "Building",
            "name": "Будівля 1",
            "attributes": {
              "area": 1500,
              "purpose": "office",
              "workingHours": "8:00-18:00"
            }
          }
        ],
        "equipment": [
          {
            "type": "Equipment",
            "name": "Котельня 1",
            "attributes": {
              "nominalPower": 500,
              "efficiency": 0.92
            }
          }
        ]
      }
    }
  }
}
```

### 2. Rule Chain для енергомоніторингу
```javascript
// Розрахунок EnPI
function calculateEnPI(data) {
  return {
    timestamp: data.ts,
    values: {
      // Питоме енергоспоживання
      specificEnergy: data.energy / data.production,
      
      // Коефіцієнт використання потужності
      powerFactor: data.actualPower / data.nominalPower,
      
      // Ефективність використання
      efficiency: calculateEfficiency(data)
    },
    // Порівняння з базовою лінією
    baseline: {
      deviation: calculateBaselineDeviation(data),
      normalized: normalizeConsumption(data)
    }
  };
}

// Аналіз трендів
function analyzeTrends(history) {
  return {
    daily: calculateDailyTrend(history),
    weekly: calculateWeeklyTrend(history),
    seasonal: calculateSeasonalFactors(history),
    // Прогноз на наступний період
    forecast: forecastConsumption(history)
  };
}

// Генерація сповіщень
function generateAlerts(enpi) {
  var alerts = [];
  
  // Перевищення базової лінії
  if (enpi.baseline.deviation > threshold) {
    alerts.push({
      type: 'HIGH_CONSUMPTION',
      value: enpi.baseline.deviation,
      timestamp: enpi.timestamp
    });
  }
  
  // Аномальне споживання
  if (isAnomaly(enpi.values)) {
    alerts.push({
      type: 'CONSUMPTION_ANOMALY',
      details: detectAnomalySource(enpi)
    });
  }
  
  return alerts;
}
```

### 3. Дашборди для енергомоніторингу
```javascript
// Конфігурація віджетів
{
  "dashboards": {
    "energy_overview": {
      "title": "Огляд енергоспоживання",
      "widgets": [
        {
          "type": "timeseries",
          "title": "Споживання енергії",
          "dataKeys": [
            {
              "name": "activeEnergy",
              "label": "Активна енергія",
              "type": "timeseries"
            },
            {
              "name": "baseline",
              "label": "Базова лінія",
              "type": "timeseries"
            }
          ]
        },
        {
          "type": "latest",
          "title": "Поточні EnPI",
          "dataKeys": [
            {
              "name": "specificEnergy",
              "label": "Питоме споживання"
            },
            {
              "name": "efficiency",
              "label": "Ефективність"
            }
          ]
        }
      ]
    },
    "energy_analysis": {
      "title": "Аналіз енергоефективності",
      "widgets": [
        {
          "type": "chart",
          "title": "Тренди споживання",
          "dataKeys": [
            {
              "name": "dailyConsumption",
              "label": "Добове споживання"
            },
            {
              "name": "forecast",
              "label": "Прогноз"
            }
          ]
        }
      ]
    }
  }
}
```

### 4. Звіти та верифікація
```javascript
// Генерація звітів
function generateEnergyReport(period) {
  return {
    period: period,
    consumption: {
      total: calculateTotalConsumption(period),
      bySource: getConsumptionBySource(period),
      normalized: normalizeByFactors(period)
    },
    performance: {
      enpi: calculatePeriodEnPI(period),
      savings: calculateEnergySavings(period),
      targets: checkTargetAchievement(period)
    },
    analysis: {
      trends: analyzePeriodTrends(period),
      factors: identifyInfluencingFactors(period),
      recommendations: generateRecommendations(period)
    },
    verification: {
      dataCoverage: checkDataCoverage(period),
      accuracy: assessDataAccuracy(period),
      uncertainties: calculateUncertainties(period)
    }
  };
}

// Верифікація даних
function verifyEnergyData(data) {
  return {
    validity: checkDataValidity(data),
    completeness: checkDataCompleteness(data),
    accuracy: {
      measurements: assessMeasurementAccuracy(data),
      calculations: assessCalculationAccuracy(data)
    },
    corrections: generateDataCorrections(data),
    uncertainties: {
      measurement: calculateMeasurementUncertainty(data),
      modeling: calculateModelingUncertainty(data)
    }
  };
}
```

## Інтеграція з обладнанням

### 1. Лічильники електроенергії
```yaml
configuration:
  devices:
    - name: "PowerMeter1"
      type: "Modbus"
      transport: "TCP"
      parameters:
        - name: "ActivePower"
          register: 30001
          type: "FLOAT32"
        - name: "Energy"
          register: 30003
          type: "FLOAT32"
        - name: "PowerFactor"
          register: 30005
          type: "FLOAT32"
```

### 2. Теплолічильники
```yaml
configuration:
  devices:
    - name: "HeatMeter1"
      type: "MBus"
      parameters:
        - name: "Energy"
          type: "FLOAT32"
        - name: "Flow"
          type: "FLOAT32"
        - name: "Temperature"
          type: "FLOAT32"
```

### 3. Датчики параметрів середовища
```yaml
configuration:
  devices:
    - name: "EnvironmentalSensor1"
      type: "MQTT"
      parameters:
        - name: "Temperature"
          topic: "sensors/temp"
        - name: "Humidity"
          topic: "sensors/humidity"
        - name: "CO2"
          topic: "sensors/co2"
```

## Рекомендації з впровадження

1. **Підготовчий етап**:
   - Енергетичний аудит
   - Визначення базової лінії
   - Встановлення цілей
   - Розробка плану впровадження

2. **Встановлення обладнання**:
   - Вибір точок вимірювання
   - Монтаж лічильників
   - Налаштування зв'язку
   - Тестування збору даних

3. **Налаштування системи**:
   - Конфігурація активів
   - Налаштування Rule Chain
   - Створення дашбордів
   - Налаштування звітності

4. **Навчання персоналу**:
   - Робота з системою
   - Аналіз даних
   - Реагування на події
   - Підготовка звітів

5. **Верифікація та валідація**:
   - Перевірка точності даних
   - Калібрування системи
   - Налаштування алгоритмів
   - Документування результатів
