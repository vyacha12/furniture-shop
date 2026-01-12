#!/bin/bash
# Скрипт резервного копирования всего проекта

PROJECT_DIR="/home/$(whoami)/diploma_project"
BACKUP_DIR="/home/$(whoami)/diploma_project/backups/project"
SHARED_DIR="/media/sf_Diploma_Project/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR
mkdir -p $SHARED_DIR

echo "Backing up project directory..."
tar -czf $BACKUP_DIR/project_backup_$DATE.tar.gz \
  --exclude='__pycache__' \
  --exclude='node_modules' \
  --exclude='*.log' \
  --exclude='*.sqlite3' \
  -C $PROJECT_DIR .

# Копируем в общую папку
cp $BACKUP_DIR/project_backup_$DATE.tar.gz $SHARED_DIR/

# Удаляем старые бэкапы
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
find $SHARED_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Project backup completed: project_backup_$DATE.tar.gz"

