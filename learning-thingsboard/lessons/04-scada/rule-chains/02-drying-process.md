# Rule Chain: Процес сушіння

## Опис
Система керування сушаркою з контролем якості продукту та оптимізацією енергоспоживання.

## Компоненти системи

### 1. Контроль параметрів
```javascript
// Дані процесу сушіння
{
  dryerId: msg.dryerId,
  process: {
    inletTemperature: msg.inletTemp,
    outletTemperature: msg.outletTemp,
    productTemperature: msg.productTemp,
    humidity: msg.humidity,
    airFlow: msg.airFlow,
    productFlow: msg.productFlow
  },
  status: msg.status
}
```

### 2. Регулювання режиму
```javascript
// Розрахунок параметрів керування
function adjustDryingParams(data) {
  var targetHumidity = getTargetHumidity(data.productType);
  var delta = data.process.humidity - targetHumidity;
  
  return {
    temperature: calculateTemperature(delta),
    airFlow: calculateAirFlow(delta),
    productFlow: calculateProductFlow(delta)
  };
}
```

### 3. Контроль якості
```javascript
// Перевірка якості сушіння
function checkQuality(data) {
  var quality = {
    humidity: {
      value: data.process.humidity,
      inRange: isInRange(data.process.humidity, 
                       getHumidityRange(data.productType))
    },
    temperature: {
      value: data.process.productTemperature,
      inRange: isInRange(data.process.productTemperature,
                       getTemperatureRange(data.productType))
    }
  };
  
  if (!quality.humidity.inRange || !quality.temperature.inRange) {
    createAlert({
      type: 'QUALITY_ALERT',
      dryerId: data.dryerId,
      quality: quality
    });
  }
  
  return quality;
}
```

### 4. Енергоефективність
```javascript
// Моніторинг енергоефективності
function monitorEfficiency(data) {
  var efficiency = {
    energyUsage: calculateEnergyUsage(data),
    throughput: data.process.productFlow,
    specificEnergy: calculateSpecificEnergy(data)
  };
  
  // Порівняння з базовими показниками
  var comparison = compareWithBaseline(efficiency);
  
  if (comparison.deviation > 10) { // відхилення більше 10%
    createAlert({
      type: 'EFFICIENCY_ALERT',
      dryerId: data.dryerId,
      efficiency: efficiency,
      deviation: comparison.deviation
    });
  }
  
  return efficiency;
}
```
