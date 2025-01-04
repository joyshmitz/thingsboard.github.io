#!/bin/bash

# Скрипт для міграції та синхронізації навчальних матеріалів ThingsBoard
set -e

# Конфігурація
SOURCE_DIR="/Users/sd/GitHub/tb/thingsboard.github.io"
LEARNING_DIR="$SOURCE_DIR/learning-thingsboard"
BACKUP_DIR="$SOURCE_DIR/backups/$(date +%Y%m%d_%H%M%S)"

# Кольори для виводу
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Функція для логування
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Створення бекапу
create_backup() {
    log "Створення бекапу..."
    mkdir -p "$BACKUP_DIR"
    cp -r "$LEARNING_DIR" "$BACKUP_DIR/"
    log "Бекап створено в: $BACKUP_DIR"
}

# Перевірка структури директорій
check_structure() {
    log "Перевірка структури директорій..."
    
    if [ ! -d "$LEARNING_DIR" ]; then
        error "Директорія $LEARNING_DIR не існує"
    fi
    
    # Перевірка необхідних піддиректорій
    for dir in "lessons" "docs" "scripts"; do
        if [ ! -d "$LEARNING_DIR/$dir" ]; then
            warn "Створення директорії: $LEARNING_DIR/$dir"
            mkdir -p "$LEARNING_DIR/$dir"
        fi
    done
}

# Синхронізація файлів
sync_files() {
    log "Синхронізація файлів..."
    
    # Синхронізація уроків
    if [ -d "$SOURCE_DIR/docs/learning" ]; then
        log "Копіювання нових уроків..."
        rsync -av --ignore-existing "$SOURCE_DIR/docs/learning/" "$LEARNING_DIR/lessons/"
    fi
    
    # Синхронізація зображень
    if [ -d "$SOURCE_DIR/images/learning" ]; then
        log "Копіювання зображень..."
        rsync -av --ignore-existing "$SOURCE_DIR/images/learning/" "$LEARNING_DIR/assets/images/"
    fi
}

# Оновлення посилань
update_links() {
    log "Оновлення посилань в файлах..."
    
    find "$LEARNING_DIR" -type f -name "*.md" -exec sed -i '' \
        -e 's|/docs/learning/|/lessons/|g' \
        -e 's|/images/learning/|/assets/images/|g' {} +
}

# Головна функція
main() {
    log "🎬 Початок процесу синхронізації..."
    
    create_backup
    check_structure
    sync_files
    update_links
    
    log "✅ Синхронізація завершена успішно!"
}

# Запуск скрипта
main
