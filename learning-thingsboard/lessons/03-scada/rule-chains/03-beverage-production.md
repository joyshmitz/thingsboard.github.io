# Rule Chain: Виробництво напоїв

## Опис
Система автоматизації лінії виробництва напоїв з контролем якості, рецептурою та CIP-мийкою.

## Компоненти системи

### 1. Керування рецептурою
```javascript
// Структура рецепту
{
  recipeId: msg.recipeId,
  product: {
    name: msg.productName,
    batchSize: msg.batchSize,
    ingredients: msg.ingredients.map(i => ({
      id: i.id,
      name: i.name,
      quantity: i.quantity,
      unit: i.unit,
      temperature: i.temperature
    })),
    mixingParams: {
      speed: msg.mixingSpeed,
      time: msg.mixingTime,
      temperature: msg.mixingTemp
    }
  }
}

// Керування дозуванням
function controlDosing(recipe, tank) {
  var sequence = [];
  
  recipe.ingredients.forEach(ingredient => {
    sequence.push({
      type: 'DOSING',
      params: {
        ingredientId: ingredient.id,
        targetQuantity: calculateQuantity(ingredient, recipe.batchSize),
        flowRate: getOptimalFlowRate(ingredient),
        tank: tank
      }
    });
  });
  
  return sequence;
}
```

### 2. Контроль процесу змішування
```javascript
// Моніторинг параметрів змішування
function monitorMixing(data) {
  var status = {
    temperature: data.temperature,
    speed: data.mixerSpeed,
    power: data.mixerPower,
    time: data.elapsedTime,
    viscosity: calculateViscosity(data)
  };
  
  // Перевірка параметрів
  if (!isWithinLimits(status)) {
    adjustMixingParams(status);
    logAdjustment(status);
  }
  
  return status;
}

// Корекція параметрів
function adjustMixingParams(status) {
  if (status.viscosity > targetViscosity) {
    return {
      adjustSpeed: true,
      newSpeed: calculateNewSpeed(status),
      adjustTemp: status.temperature < maxTemp,
      newTemp: Math.min(status.temperature + 2, maxTemp)
    };
  }
  return null;
}
```

### 3. Контроль якості
```javascript
// Перевірка якості продукту
function checkProductQuality(batch) {
  var tests = [
    checkDensity(batch.density),
    checkPH(batch.ph),
    checkBrix(batch.brix),
    checkColor(batch.color),
    checkTurbidity(batch.turbidity)
  ];
  
  var results = {
    batchId: batch.id,
    timestamp: new Date().getTime(),
    tests: tests,
    passed: tests.every(t => t.passed),
    recommendations: []
  };
  
  // Аналіз відхилень
  tests.filter(t => !t.passed).forEach(test => {
    results.recommendations.push(
      generateCorrectiveAction(test)
    );
  });
  
  return results;
}
```

### 4. CIP-мийка
```javascript
// Керування CIP-мийкою
function controlCIP(equipment) {
  var phases = [
    {
      name: 'PRE_RINSE',
      params: {
        solution: 'WATER',
        temperature: 40,
        duration: 600,
        flowRate: 100
      }
    },
    {
      name: 'CAUSTIC',
      params: {
        solution: 'NAOH',
        concentration: 2,
        temperature: 75,
        duration: 1200,
        flowRate: 120
      }
    },
    {
      name: 'INTERMEDIATE_RINSE',
      params: {
        solution: 'WATER',
        temperature: 40,
        duration: 300,
        flowRate: 100
      }
    },
    {
      name: 'ACID',
      params: {
        solution: 'HNO3',
        concentration: 1,
        temperature: 65,
        duration: 900,
        flowRate: 120
      }
    },
    {
      name: 'FINAL_RINSE',
      params: {
        solution: 'WATER',
        temperature: 20,
        duration: 600,
        flowRate: 100
      }
    }
  ];
  
  return {
    equipmentId: equipment.id,
    phases: phases,
    totalDuration: phases.reduce((sum, p) => sum + p.duration, 0),
    monitoring: {
      conductivity: true,
      temperature: true,
      flow: true,
      pressure: true
    }
  };
}

// Моніторинг процесу CIP
function monitorCIP(phase, data) {
  var status = {
    phaseId: phase.name,
    parameters: {
      conductivity: data.conductivity,
      temperature: data.temperature,
      flow: data.flow,
      pressure: data.pressure
    },
    limits: getCIPLimits(phase)
  };
  
  // Перевірка параметрів
  if (!checkCIPParams(status)) {
    createAlert({
      type: 'CIP_PARAMETER_VIOLATION',
      phase: phase.name,
      parameters: status.parameters,
      limits: status.limits
    });
  }
  
  return status;
}
```

### 5. Енергоефективність та облік
```javascript
// Моніторинг споживання ресурсів
function trackResources(batch) {
  return {
    batchId: batch.id,
    timestamp: new Date().getTime(),
    energy: {
      mixing: batch.mixingEnergy,
      heating: batch.heatingEnergy,
      cooling: batch.coolingEnergy,
      total: calculateTotalEnergy(batch)
    },
    water: {
      process: batch.processWater,
      cip: batch.cipWater,
      total: batch.processWater + batch.cipWater
    },
    chemicals: {
      caustic: batch.causticUsed,
      acid: batch.acidUsed
    },
    costs: calculateBatchCosts(batch)
  };
}

// Розрахунок KPI
function calculateBatchKPI(batch) {
  var resources = trackResources(batch);
  
  return {
    energyPerUnit: resources.energy.total / batch.productionVolume,
    waterPerUnit: resources.water.total / batch.productionVolume,
    chemicalsPerUnit: (resources.chemicals.caustic + 
                      resources.chemicals.acid) / batch.productionVolume,
    costPerUnit: resources.costs / batch.productionVolume,
    productivity: batch.productionVolume / batch.duration
  };
}
```
