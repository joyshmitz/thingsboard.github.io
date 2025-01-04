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
      
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.0'
          
      - name: Install dependencies
        run: |
          gem install bundler
          bundle install
          
      - name: Build site
        run: bundle exec jekyll build
        
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./_site
EOF

    # Створюємо workflow для лінтера
    cat > .github/workflows/lint.yml << 'EOF'
name: Lint

on: [push, pull_request]

jobs:
  markdown-lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'
          
      - name: Install dependencies
        run: npm install -g markdownlint-cli
        
      - name: Run Markdown lint
        run: markdownlint '**/*.md'
EOF

    git add .
    git commit -m "Setup: GitHub Actions workflows"
}

# 5. Створення документації для контриб'юторів
setup_contribution_docs() {
    echo "📝 Створення документації для контриб'юторів..."
    
    cd "$TARGET_REPO"
    
    # Створюємо CONTRIBUTING.md
    cat > CONTRIBUTING.md << 'EOF'
# Contributing to ThingsBoard Learning

We love your input! We want to make contributing to ThingsBoard Learning as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## We Develop with Github
We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## We Use [Github Flow](https://guides.github.com/introduction/flow/index.html)
Pull requests are the best way to propose changes to the codebase.

## Any contributions you make will be under the MIT Software License
In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project.

## Report bugs using Github's [issue tracker](https://github.com/joyshmitz/thingsboard-learning/issues)
We use GitHub issues to track public bugs.

## Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## License
By contributing, you agree that your contributions will be licensed under its MIT License.

## References
This document was adapted from the open-source contribution guidelines for [Facebook's Draft](https://github.com/facebook/draft-js/blob/a9316a723f9e918afde44dea68b5f9f39b7d9b00/CONTRIBUTING.md).
EOF

    # Створюємо шаблони для issues
    mkdir -p .github/ISSUE_TEMPLATE
    
    # Bug report template
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

    # Feature request template
    cat > .github/ISSUE_TEMPLATE/feature_request.md << 'EOF'
---
name: Feature request
about: Suggest an idea for this project
title: ''
labels: enhancement
assignees: ''

---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is. Ex. I'm always frustrated when [...]

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
EOF

    git add .
    git commit -m "Setup: Contributing guidelines and issue templates"
}

# Головна функція
main() {
    echo "🎬 Початок процесу міграції..."
    
    setup_new_repo
    migrate_content
    update_links
    setup_github_actions
    setup_contribution_docs
    
    echo "✅ Міграція завершена успішно!"
    echo "⚠️ Наступні кроки:"
    echo "1. Створіть репозиторій на GitHub: https://github.com/new"
    echo "2. Виконайте push: git push -u origin main"
    echo "3. Налаштуйте GitHub Pages в налаштуваннях репозиторію"
    echo "4. Перевірте всі посилання та форматування"
}

# Запуск скрипта
main
