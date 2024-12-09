# Rule Chain: Моніторинг енергоефективності

## Опис
Система моніторингу та оптимізації енергоспоживання згідно з ISO 50001, ISO 50006 та ISO 50015.

## Компоненти системи

### 1. Збір та валідація даних
```javascript
// Структура даних енергоспоживання
{
  deviceId: msg.deviceId,
  timestamp: msg.ts,
  measurements: {
    activeEnergy: msg.activeEnergy,      // кВт*год
    reactiveEnergy: msg.reactiveEnergy,  // кВАр*год
    activePower: msg.activePower,        // кВт
    powerFactor: msg.powerFactor,        // cos φ
    voltage: msg.voltage,                // В
    current: msg.current                 // А
  },
  metadata: {
    deviceType: msg.deviceType,
    location: msg.location,
    processArea: msg.processArea
  }
}

// Валідація даних
function validateEnergyData(data) {
  var validationRules = {
    activeEnergy: {
      min: 0,
      max: 999999,
      required: true
    },
    activePower: {
      min: 0,
      max: 1000,
      required: true
    },
    powerFactor: {
      min: 0,
      max: 1,
      required: true
    }
  };
  
  return validateMeasurements(data.measurements, validationRules);
}
```

### 2. Розрахунок EnPI
```javascript
// Розрахунок показників енергоефективності
function calculateEnPI(data, baseline) {
  var production = getProductionData(data.timestamp);
  var weather = getWeatherData(data.timestamp);
  
  return {
    timestamp: data.timestamp,
    indicators: {
      // Питоме енергоспоживання
      specificEnergy: data.measurements.activeEnergy / production.volume,
      
      // Коефіцієнт використання потужності
      powerUtilization: data.measurements.activePower / data.nominalPower,
      
      // Енергоефективність відносно базової лінії
      performanceImprovement: calculateImprovement(data, baseline),
      
      // Нормалізовані показники
      normalizedConsumption: normalizeByFactors(data, weather)
    },
    factors: {
      production: production,
      weather: weather,
      schedule: getOperationalSchedule(data.timestamp)
    }
  };
}

// Нормалізація за факторами впливу
function normalizeByFactors(data, factors) {
  return {
    weatherNormalized: adjustForWeather(data, factors.weather),
    productionNormalized: adjustForProduction(data, factors.production),
    scheduleNormalized: adjustForSchedule(data, factors.schedule)
  };
}
```

### 3. Аналіз трендів та прогнозування
```javascript
// Аналіз трендів споживання
function analyzeConsumptionTrends(history) {
  return {
    // Добовий профіль
    dailyProfile: calculateDailyProfile(history),
    
    // Тижневий тренд
    weeklyTrend: calculateWeeklyTrend(history),
    
    // Сезонність
    seasonality: {
      pattern: detectSeasonalPattern(history),
      factors: calculateSeasonalFactors(history)
    },
    
    // Прогноз
    forecast: {
      nextDay: forecastNextDay(history),
      nextWeek: forecastNextWeek(history),
      nextMonth: forecastNextMonth(history)
    }
  };
}

// Виявлення аномалій
function detectAnomalies(data, history) {
  var anomalies = [];
  
  // Перевірка відхилень від норми
  if (isStatisticalAnomaly(data, history)) {
    anomalies.push({
      type: 'STATISTICAL_ANOMALY',
      value: data.measurements.activeEnergy,
      expected: calculateExpectedValue(history),
      deviation: calculateDeviation(data, history)
    });
  }
  
  // Перевірка різких змін
  if (isSuddenChange(data, history)) {
    anomalies.push({
      type: 'SUDDEN_CHANGE',
      value: data.measurements.activePower,
      changeRate: calculateChangeRate(data, history)
    });
  }
  
  return anomalies;
}
```

### 4. Оптимізація та керування
```javascript
// Оптимізація енергоспоживання
function optimizeEnergyConsumption(data) {
  var schedule = getProductionSchedule();
  var tariffs = getEnergyTariffs();
  var weather = getWeatherForecast();
  
  return {
    // Оптимальний графік роботи
    optimalSchedule: calculateOptimalSchedule(schedule, tariffs),
    
    // Рекомендації щодо навантаження
    loadRecommendations: generateLoadRecommendations(data, tariffs),
    
    // Налаштування обладнання
    equipmentSettings: optimizeEquipmentSettings(data, weather),
    
    // Прогноз економії
    savingsForecast: calculatePotentialSavings(data, tariffs)
  };
}

// Керування навантаженням
function managePowerLoad(data) {
  var currentLoad = data.measurements.activePower;
  var targetLoad = calculateTargetLoad(data);
  
  if (currentLoad > targetLoad) {
    return {
      action: 'REDUCE_LOAD',
      devices: prioritizeLoadReduction(data),
      targetReduction: currentLoad - targetLoad,
      strategy: determineReductionStrategy(data)
    };
  }
  
  return {
    action: 'MAINTAIN',
    currentStatus: 'OPTIMAL',
    nextCheck: calculateNextCheckTime(data)
  };
}
```

### 5. Звітність та верифікація
```javascript
// Генерація звіту з енергоефективності
function generateEnergyReport(period) {
  var data = getEnergyData(period);
  var baseline = getBaselineData(period);
  var targets = getEnergyTargets(period);
  
  return {
    period: period,
    consumption: {
      total: calculateTotalConsumption(data),
      bySource: getConsumptionBySource(data),
      byProcess: getConsumptionByProcess(data)
    },
    performance: {
      enpi: calculatePeriodEnPI(data, baseline),
      savings: calculateEnergySavings(data, baseline),
      targetAchievement: checkTargetAchievement(data, targets)
    },
    analysis: {
      trends: analyzePeriodTrends(data),
      anomalies: detectPeriodAnomalies(data),
      recommendations: generateRecommendations(data)
    },
    verification: {
      methodology: 'ISO 50015',
      dataCoverage: checkDataCoverage(data),
      accuracy: assessDataAccuracy(data),
      uncertainties: calculateUncertainties(data)
    }
  };
}

// Верифікація результатів
function verifyResults(data, baseline) {
  return {
    // Перевірка якості даних
    dataQuality: {
      completeness: checkDataCompleteness(data),
      accuracy: checkDataAccuracy(data),
      consistency: checkDataConsistency(data)
    },
    
    // Верифікація розрахунків
    calculations: {
      methodology: describeMethodology(),
      assumptions: listAssumptions(),
      uncertainties: calculateUncertainties(data)
    },
    
    // Підтвердження економії
    savings: {
      calculated: calculateSavings(data, baseline),
      verified: verifySavings(data, baseline),
      confidence: calculateConfidenceLevel(data)
    }
  };
}
```
