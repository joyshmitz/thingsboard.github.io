#!/bin/bash

# Скрипт для міграції контенту в новий репозиторій thingsboard-learning
set -e

# Конфігурація
SOURCE_REPO="/Users/sd/GitHub/tb/thingsboard.github.io"
TARGET_REPO="/Users/sd/GitHub/tb/thingsboard-learning"
GITHUB_USER="joyshmitz"
REPO_NAME="thingsboard-learning"

echo "🚀 Починаємо міграцію в новий репозиторій..."

# 1. Створення та налаштування нового репозиторію
setup_new_repo() {
    echo "📁 Створення нового репозиторію..."
    
    # Створюємо директорію якщо її не існує
    mkdir -p "$TARGET_REPO"
    
    # Ініціалізуємо новий репозиторій
    cd "$TARGET_REPO"
    git init
    
    # Створюємо базову структуру
    mkdir -p docs lessons examples assets
    
    # Створюємо базові файли
    echo "# ThingsBoard Learning" > README.md
    echo "theme: jekyll-theme-minimal" > _config.yml
    
    # Початковий коміт
    git add .
    git commit -m "Initial commit: Basic repository structure"
    
    # Додаємо remote
    git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
}

# 2. Міграція контенту
migrate_content() {
    echo "📚 Міграція контенту..."
    
    cd "$SOURCE_REPO"
    
    # Копіюємо learning-thingsboard
    cp -r learning-thingsboard/* "$TARGET_REPO/lessons/"
    
    # Копіюємо docs
    cp -r docs/* "$TARGET_REPO/docs/"
    
    # Копіюємо спільні ресурси
    cp -r images "$TARGET_REPO/assets/"
    
    cd "$TARGET_REPO"
    git add .
    git commit -m "Content migration: Lessons and documentation"
}

# 3. Оновлення посилань
update_links() {
    echo "🔗 Оновлення посилань..."
    
    cd "$TARGET_REPO"
    
    # Оновлюємо посилання в markdown файлах
    find . -type f -name "*.md" -exec sed -i '' \
        -e 's|/docs/|/thingsboard-learning/docs/|g' \
        -e 's|/learning-thingsboard/|/thingsboard-learning/lessons/|g' {} +
    
    git add .
    git commit -m "Update: Fix internal links"
}

# 4. Налаштування GitHub Actions
setup_github_actions() {
    echo "⚙️ Налаштування GitHub Actions..."
    
    cd "$TARGET_REPO"
    mkdir -p .github/workflows
    
    # Створюємо workflow для GitHub Pages
    cat > .github/workflows/pages.yml << 'EOF'
name: GitHub Pages

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node
        uses: actions/setup-node@v2
        with:
          node-version: '14'
      - name: Install dependencies
        run: npm install
      - name: Build
        run: npm run build
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build
EOF

    # Створюємо шаблони для issues
    mkdir -p .github/ISSUE_TEMPLATE
    
    # Шаблон для баг-репорту
    cat > .github/ISSUE_TEMPLATE/bug_report.md << 'EOF'
---
name: Bug report
about: Create a report to help us improve
title: ''
labels: bug
assignees: ''
---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Additional context**
Add any other context about the problem here.
EOF

    # Шаблон для feature request
    cat > .github/ISSUE_TEMPLATE/feature_request.md << 'EOF'
---
name: Feature request
about: Suggest an idea for this project
title: ''
labels: enhancement
assignees: ''
---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is.

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
EOF

    git add .
    git commit -m "Setup: GitHub Actions and issue templates"
}

# Головна функція
main() {
    setup_new_repo
    migrate_content
    update_links
    setup_github_actions
    
    echo "✅ Міграція завершена успішно!"
    echo "📝 Наступні кроки:"
    echo "1. Перевірте результат міграції"
    echo "2. Запушіть зміни: git push -u origin main"
    echo "3. Налаштуйте GitHub Pages в налаштуваннях репозиторію"
}

# Запуск скрипта
main
