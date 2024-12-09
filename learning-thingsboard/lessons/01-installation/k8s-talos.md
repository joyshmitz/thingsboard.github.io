# Встановлення ThingsBoard на Kubernetes з Talos Linux

## Що таке Kubernetes та Talos Linux?

### Kubernetes
Kubernetes (K8s) - це система оркестрації контейнерів, яка автоматизує розгортання, масштабування та управління контейнеризованими застосунками. Переваги використання Kubernetes для ThingsBoard:
- Автоматичне масштабування
- Самовідновлення при збоях
- Балансування навантаження
- Керування конфігурацією
- Автоматичні оновлення

### Talos Linux
Talos Linux - це сучасний Linux-дистрибутив, спеціально розроблений для Kubernetes. Особливості:
- Мінімалістична операційна система
- Безпека за замовчуванням
- Незмінна інфраструктура
- Автоматичні оновлення системи

## Системні вимоги

### Мінімальні вимоги для кластера
- 3 вузли для Control Plane
- 2 вузли для Worker
- Кожен вузол:
  - CPU: 4 ядра
  - RAM: 8GB
  - Диск: 50GB
- Мережа:
  - 1Gbps між вузлами
  - Статичні IP-адреси
  - Доступ до Інтернету

### Мережеві порти
- Control Plane:
  - 6443: Kubernetes API
  - 2379-2380: etcd
  - 10250: Kubelet API
- Worker Nodes:
  - 10250: Kubelet API
  - 30000-32767: NodePort Services

## Покрокове встановлення

### 1. Підготовка Talos Linux

#### 1.1. Створення конфігурації Talos
```bash
# Генерація секретів
talosctl gen secrets

# Створення конфігурації для Control Plane
talosctl gen config talos-k8s-cluster https://cluster-endpoint:6443 --with-secrets secrets.yaml

# Налаштування для високої доступності
talosctl gen config talos-k8s-cluster https://cluster-endpoint:6443 \
  --with-secrets secrets.yaml \
  --config-patch @controlplane.yaml \
  --config-patch-control-plane @controlplane.yaml \
  --config-patch-worker @worker.yaml
```

#### 1.2. Встановлення Talos на вузли
```bash
# Встановлення на Control Plane вузли
talosctl apply-config --insecure \
  --nodes control1.example.com \
  --file controlplane-1.yaml

# Встановлення на Worker вузли
talosctl apply-config --insecure \
  --nodes worker1.example.com \
  --file worker-1.yaml
```

### 2. Налаштування Kubernetes кластера

#### 2.1. Ініціалізація кластера
```bash
# Створення kubeconfig
talosctl kubeconfig --nodes control1.example.com

# Перевірка стану кластера
kubectl get nodes
kubectl get pods -A
```

#### 2.2. Встановлення необхідних компонентів

```bash
# Встановлення Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Встановлення Ingress Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx

# Встановлення Cert Manager (для SSL)
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true
```

### 3. Встановлення ThingsBoard

#### 3.1. Підготовка Helm chart
```bash
# Додавання репозиторію ThingsBoard
helm repo add thingsboard https://charts.thingsboard.io
helm repo update

# Створення namespace
kubectl create namespace thingsboard
```

#### 3.2. Налаштування values.yaml
```yaml
global:
  # Налаштування для високої доступності
  highAvailability:
    enabled: true
    
  # Налаштування бази даних
  postgresql:
    ha:
      enabled: true
    persistence:
      size: 50Gi
      
  # Налаштування Kafka для черги повідомлень
  kafka:
    enabled: true
    replicaCount: 3
    
# Налаштування компонентів ThingsBoard
tb-node:
  replicaCount: 3
  resources:
    requests:
      cpu: "2"
      memory: "4Gi"
    limits:
      cpu: "4"
      memory: "8Gi"
      
tb-web-ui:
  replicaCount: 2
  
# Налаштування транспортних вузлів
tb-mqtt-transport:
  replicaCount: 2
tb-http-transport:
  replicaCount: 2
tb-coap-transport:
  replicaCount: 2
```

#### 3.3. Встановлення ThingsBoard
```bash
# Встановлення через Helm
helm install thingsboard thingsboard/thingsboard \
  -n thingsboard \
  -f values.yaml

# Перевірка статусу
kubectl get pods -n thingsboard
kubectl get services -n thingsboard
```

### 4. Налаштування доступу

#### 4.1. Налаштування Ingress
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: thingsboard
  namespace: thingsboard
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - tb.example.com
    secretName: thingsboard-tls
  rules:
  - host: tb.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: tb-web-ui
            port:
              number: 8080
```

#### 4.2. Налаштування SSL
```bash
# Створення ClusterIssuer для Let's Encrypt
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```

### 5. Моніторинг та обслуговування

#### 5.1. Встановлення моніторингу
```bash
# Встановлення Prometheus Stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace

# Налаштування Grafana дашбордів для ThingsBoard
kubectl apply -f thingsboard-dashboards.yaml
```

#### 5.2. Команди для обслуговування
```bash
# Перевірка логів
kubectl logs -f -l app=tb-node -n thingsboard

# Масштабування компонентів
kubectl scale deployment tb-node --replicas=5 -n thingsboard

# Оновлення ThingsBoard
helm upgrade thingsboard thingsboard/thingsboard \
  -n thingsboard \
  -f values.yaml

# Резервне копіювання
kubectl exec -it $(kubectl get pod -l app=postgresql -n thingsboard -o name) \
  -n thingsboard -- pg_dump -U postgres thingsboard > backup.sql
```

### 6. Типові проблеми та їх вирішення

1. **Проблема: Pods в статусі Pending**
   ```bash
   # Перевірка причини
   kubectl describe pod POD_NAME -n thingsboard
   
   # Перевірка ресурсів вузлів
   kubectl describe nodes
   ```

2. **Проблема: Помилки підключення до бази даних**
   ```bash
   # Перевірка статусу PostgreSQL
   kubectl get pods -l app=postgresql -n thingsboard
   
   # Перевірка логів PostgreSQL
   kubectl logs -l app=postgresql -n thingsboard
   ```

3. **Проблема: Недоступність через Ingress**
   ```bash
   # Перевірка статусу Ingress
   kubectl get ingress -n thingsboard
   
   # Перевірка логів Ingress контролера
   kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
   ```

## Корисні посилання
- [Документація Talos Linux](https://www.talos.dev/latest/introduction/what-is-talos/)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [ThingsBoard Helm Charts](https://github.com/thingsboard/thingsboard-helm-chart)
- [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Cert Manager Documentation](https://cert-manager.io/docs/)

### 7. Безпека кластера

#### 7.1. Налаштування RBAC
```yaml
# Створення ServiceAccount для ThingsBoard
apiVersion: v1
kind: ServiceAccount
metadata:
  name: thingsboard-sa
  namespace: thingsboard

---
# Створення Role з обмеженими правами
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: thingsboard-role
  namespace: thingsboard
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "statefulsets"]
  verbs: ["get", "list", "watch", "update"]

---
# Прив'язка Role до ServiceAccount
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: thingsboard-rolebinding
  namespace: thingsboard
subjects:
- kind: ServiceAccount
  name: thingsboard-sa
  namespace: thingsboard
roleRef:
  kind: Role
  name: thingsboard-role
  apiGroup: rbac.authorization.k8s.io
```

#### 7.2. Мережева політика
```yaml
# Обмеження мережевого доступу
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: thingsboard-network-policy
  namespace: thingsboard
spec:
  podSelector:
    matchLabels:
      app: thingsboard
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: thingsboard
    ports:
    - protocol: TCP
      port: 5432  # PostgreSQL
    - protocol: TCP
      port: 9092  # Kafka
```

#### 7.3. Шифрування даних
```bash
# Створення секрету для шифрування
kubectl create secret generic tb-encryption-key \
  --from-literal=key=$(openssl rand -base64 32) \
  -n thingsboard

# Налаштування шифрування etcd
kubectl -n kube-system edit cm kubeadm-config
```

#### 7.4. Сканування безпеки
```bash
# Встановлення Trivy для сканування вразливостей
kubectl apply -f https://raw.githubusercontent.com/aquasecurity/trivy-operator/main/deploy/static/trivy-operator.yaml

# Сканування образів
trivy image thingsboard/tb-node:latest

# Сканування Kubernetes ресурсів
trivy k8s --report summary cluster
```

### 8. Оптимізація продуктивності

#### 8.1. Налаштування JVM для ThingsBoard
```yaml
# Додайте ці параметри до values.yaml
tb-node:
  env:
    - name: JAVA_OPTS
      value: >-
        -Xms4g
        -Xmx8g
        -XX:+UseG1GC
        -XX:+UseStringDeduplication
        -XX:+ParallelRefProcEnabled
        -XX:MaxGCPauseMillis=200
```

#### 8.2. Оптимізація PostgreSQL
```yaml
postgresql:
  postgresql:
    config:
      max_connections: 500
      shared_buffers: 2GB
      effective_cache_size: 6GB
      maintenance_work_mem: 512MB
      checkpoint_completion_target: 0.9
      wal_buffers: 16MB
      default_statistics_target: 100
      random_page_cost: 1.1
      effective_io_concurrency: 200
      work_mem: 5242kB
      min_wal_size: 1GB
      max_wal_size: 4GB
```

#### 8.3. Налаштування Kafka
```yaml
kafka:
  config:
    num.partitions: 8
    default.replication.factor: 3
    min.insync.replicas: 2
    log.retention.hours: 24
    log.retention.bytes: 1073741824
    log.segment.bytes: 536870912
```

#### 8.4. Горизонтальне масштабування
```yaml
# Автоматичне масштабування для tb-node
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: tb-node-hpa
  namespace: thingsboard
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: tb-node
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

#### 8.5. Моніторинг продуктивності
```bash
# Встановлення метрик-сервера
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Налаштування Prometheus правил для алертів
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: thingsboard-alerts
  namespace: monitoring
spec:
  groups:
  - name: thingsboard
    rules:
    - alert: HighCPUUsage
      expr: container_cpu_usage_seconds_total{namespace="thingsboard"} > 0.8
      for: 5m
      labels:
        severity: warning
      annotations:
        description: "High CPU usage detected"
    - alert: HighMemoryUsage
      expr: container_memory_usage_bytes{namespace="thingsboard"} > 0.85
      for: 5m
      labels:
        severity: warning
      annotations:
        description: "High memory usage detected"

### 9. Відмовостійкість та висока доступність

#### 9.1. Налаштування Pod Disruption Budget
```yaml
# Захист від одночасного видалення подів
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: tb-node-pdb
  namespace: thingsboard
spec:
  minAvailable: 2  # або maxUnavailable: 1
  selector:
    matchLabels:
      app: tb-node
```

#### 9.2. Налаштування анти-афінності
```yaml
# Розподіл подів по різних нодах
tb-node:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - tb-node
        topologyKey: "kubernetes.io/hostname"
```

#### 9.3. Налаштування Liveness та Readiness проб
```yaml
tb-node:
  livenessProbe:
    httpGet:
      path: /api/v1/health
      port: 8080
    initialDelaySeconds: 300
    periodSeconds: 30
    timeoutSeconds: 5
    failureThreshold: 3
  readinessProbe:
    httpGet:
      path: /api/v1/health
      port: 8080
    initialDelaySeconds: 60
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 3
```

#### 9.4. Автоматичне відновлення після збоїв
```yaml
# Налаштування Restart Policy
spec:
  template:
    spec:
      restartPolicy: Always
      containers:
      - name: tb-node
        startupProbe:
          httpGet:
            path: /api/v1/health
            port: 8080
          failureThreshold: 30
          periodSeconds: 10
```

### 10. Резервне копіювання та відновлення

#### 10.1. Налаштування Velero для резервного копіювання
```bash
# Встановлення Velero
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.2.0 \
  --bucket backup-bucket \
  --secret-file ./credentials-velero \
  --backup-location-config region=eu-central-1 \
  --snapshot-location-config region=eu-central-1

# Створення розкладу резервного копіювання
velero schedule create thingsboard-daily \
  --schedule="@daily" \
  --include-namespaces thingsboard
```

#### 10.2. Резервне копіювання PostgreSQL
```yaml
# Створення CronJob для бекапу PostgreSQL
apiVersion: batch/v1
kind: CronJob
metadata:
  name: pg-backup
  namespace: thingsboard
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: pg-backup
            image: bitnami/postgresql:latest
            command:
            - /bin/sh
            - -c
            - |
              TIMESTAMP=$(date +%Y%m%d_%H%M%S)
              pg_dump -h postgresql -U postgres -d thingsboard | gzip > /backup/tb_backup_$TIMESTAMP.sql.gz
            env:
            - name: PGPASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgresql
                  key: postgres-password
            volumeMounts:
            - name: backup
              mountPath: /backup
          volumes:
          - name: backup
            persistentVolumeClaim:
              claimName: backup-pvc
          restartPolicy: OnFailure
```

#### 10.3. Процедура відновлення
```bash
# Відновлення з Velero бекапу
velero restore create --from-backup thingsboard-daily-20231209

# Відновлення PostgreSQL
kubectl exec -it postgresql-0 -n thingsboard -- bash
gunzip < /backup/tb_backup_20231209_020000.sql.gz | psql -U postgres -d thingsboard
```

### 11. Моніторинг безпеки

#### 11.1. Встановлення Falco
```bash
# Встановлення Falco через Helm
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm install falco falcosecurity/falco \
  --namespace falco \
  --create-namespace
```

#### 11.2. Налаштування правил Falco
```yaml
# Створення користувацьких правил
apiVersion: v1
kind: ConfigMap
metadata:
  name: falco-rules
  namespace: falco
data:
  custom-rules.yaml: |
    - rule: Unauthorized Access to ThingsBoard API
      desc: Detect unauthorized access attempts to ThingsBoard API
      condition: evt.type=connect and container.name contains "tb-node" and not user.name=thingsboard
      output: "Unauthorized access attempt to ThingsBoard API (user=%user.name container=%container.name)"
      priority: WARNING
```

#### 11.3. Інтеграція з SIEM
```yaml
# Налаштування відправки логів в Elasticsearch
falco:
  jsonOutput: true
  jsonIncludeOutputProperty: true
  programOutput:
    enabled: true
    keepAlive: false
    program: "curl -X POST -H 'Content-Type: application/json' http://elasticsearch:9200/falco/_doc -d @-"
```

#### 11.4. Моніторинг аудиту Kubernetes
```yaml
# Налаштування аудиту кластера
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  resources:
  - group: ""
    resources: ["secrets", "configmaps"]
- level: RequestResponse
  resources:
  - group: ""
    resources: ["pods"]
    namespaces: ["thingsboard"]
```

#### 11.5. Сповіщення про інциденти безпеки
```yaml
# Налаштування AlertManager для безпекових інцидентів
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: security-alerts
  namespace: monitoring
spec:
  groups:
  - name: security
    rules:
    - alert: UnauthorizedAccess
      expr: rate(falco_alerts{rule="Unauthorized Access to ThingsBoard API"}[5m]) > 0
      for: 1m
      labels:
        severity: critical
      annotations:
        description: "Виявлено спробу несанкціонованого доступу до ThingsBoard API"
    - alert: SuspiciousActivity
      expr: rate(falco_alerts{priority="Critical"}[5m]) > 0
      for: 1m
      labels:
        severity: critical
      annotations:
        description: "Виявлено підозрілу активність в кластері"

```

### 12. AI-моніторинг за допомогою k8sgpt

#### 12.1. Встановлення k8sgpt
```bash
# Встановлення k8sgpt CLI
brew install k8sgpt-ai/k8sgpt/k8sgpt

# Налаштування OpenAI API
k8sgpt auth configure --model gpt-4 --backend openai --api-key "your-api-key"

# Встановлення k8sgpt оператора
helm repo add k8sgpt https://charts.k8sgpt.ai/
helm repo update
helm install k8sgpt k8sgpt/k8sgpt \
  --namespace k8sgpt \
  --create-namespace \
  --set backend.type=openai \
  --set backend.openai.apiKey="your-api-key"
```

#### 12.2. Налаштування автоматичного аналізу
```yaml
# Створення CRD для автоматичного аналізу
apiVersion: core.k8sgpt.ai/v1alpha1
kind: K8sGPTAnalysis
metadata:
  name: thingsboard-analysis
  namespace: k8sgpt
spec:
  schedule: "*/30 * * * *"  # Кожні 30 хвилин
  target:
    namespaces:
      - thingsboard
  filters:
    - Pods
    - Services
    - StatefulSets
    - ConfigMaps
    - Secrets
    - PersistentVolumes
  explain: true
  language: ukrainian
```

#### 12.3. Інтеграція з Prometheus та AlertManager
```yaml
# Налаштування k8sgpt-operator для роботи з метриками
apiVersion: core.k8sgpt.ai/v1alpha1
kind: K8sGPTConfig
metadata:
  name: k8sgpt-prometheus
  namespace: k8sgpt
spec:
  prometheus:
    enabled: true
    endpoint: http://prometheus-server.monitoring:9090
  alerts:
    enabled: true
    threshold: warning
    provider: alertmanager
    endpoint: http://alertmanager-operated.monitoring:9093
```

#### 12.4. Користувацькі правила аналізу
```yaml
# Додавання специфічних правил для ThingsBoard
apiVersion: core.k8sgpt.ai/v1alpha1
kind: K8sGPTAnalysisRule
metadata:
  name: thingsboard-rules
  namespace: k8sgpt
spec:
  rules:
    - name: high-memory-usage
      description: "Аналіз високого використання пам'яті"
      query: |
        container_memory_usage_bytes{namespace="thingsboard"} 
        / 
        container_spec_memory_limit_bytes{namespace="thingsboard"} 
        > 0.85
    - name: slow-database-queries
      description: "Аналіз повільних запитів до бази даних"
      query: |
        rate(pg_stat_activity_max_tx_duration{namespace="thingsboard"}[5m]) > 30
    - name: api-latency
      description: "Аналіз затримок API"
      query: |
        histogram_quantile(0.95, 
          rate(http_request_duration_seconds_bucket{
            namespace="thingsboard",
            service="tb-node"
          }[5m])
        ) > 1
```

#### 12.5. Налаштування сповіщень
```yaml
# Інтеграція з Slack
apiVersion: v1
kind: Secret
metadata:
  name: k8sgpt-slack
  namespace: k8sgpt
type: Opaque
stringData:
  token: "your-slack-token"
  channel: "#k8sgpt-alerts"
---
apiVersion: core.k8sgpt.ai/v1alpha1
kind: K8sGPTNotifier
metadata:
  name: slack-notifications
  namespace: k8sgpt
spec:
  provider: slack
  secretRef:
    name: k8sgpt-slack
  filters:
    minSeverity: warning
  template: |
    *K8sGPT Аналіз ThingsBoard*
    Severity: {{ .Severity }}
    Resource: {{ .Resource }}
    Problem: {{ .Problem }}
    Рекомендації: {{ .Explanation }}
```

#### 12.6. Приклади використання k8sgpt CLI
```bash
# Аналіз всього namespace
k8sgpt analyze --namespace thingsboard

# Аналіз конкретного компонента
k8sgpt analyze --filter Pods --name tb-node

# Отримання рекомендацій щодо оптимізації
k8sgpt suggest --namespace thingsboard

# Перегляд історії аналізу
k8sgpt history

# Експорт результатів аналізу
k8sgpt analyze --output json > analysis.json
```

#### 12.7. Автоматизація виправлень
```yaml
# Налаштування автоматичного застосування рекомендацій
apiVersion: core.k8sgpt.ai/v1alpha1
kind: K8sGPTAutofix
metadata:
  name: thingsboard-autofix
  namespace: k8sgpt
spec:
  enabled: true
  approvalRequired: true  # Потрібне підтвердження перед застосуванням
  filters:
    - type: resource
      include:
        - ConfigMaps
        - Deployments
    - type: severity
      include:
        - low
        - warning
  notifications:
    slack:
      enabled: true
      channel: "#k8sgpt-autofix"
  schedule: "0 * * * *"  # Щогодини
