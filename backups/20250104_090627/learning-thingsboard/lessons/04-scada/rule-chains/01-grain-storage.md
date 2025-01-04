# Rule Chain: Елеватор та зберігання зерна

## Опис
Система автоматизації для контролю умов зберігання зерна в силосах з функціями моніторингу, автоматичного керування вентиляцією та оптимізації енергоспоживання.

## Компоненти системи

### 1. Збір даних з датчиків
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

### 2. Аналіз умов зберігання
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

### 3. Керування вентиляцією
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

### 4. Моніторинг та звітність
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

## Додаткові функції

### 1. Прогнозування самозігрівання
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

### 2. Оптимізація енергоспоживання
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
