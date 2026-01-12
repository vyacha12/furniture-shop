#!/bin/bash
# Скрипт резервного копирования базы данных

# Настройки
DB_NAME="furniture_shop"
DB_USER="django_user"
DB_PASS="ваш_пароль_сюда"  # ПОКА НЕ НУЖЕН (MySQL еще не установлен)
BACKUP_DIR="/home/$(whoami)/diploma_project/backups/db"
SHARED_DIR="/media/sf_Diploma_Project/backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Создаем директории, если их нет
mkdir -p $BACKUP_DIR
mkdir -p $SHARED_DIR

echo "Backing up database $DB_NAME..."

# Проверяем, установлен ли MySQL клиент
if ! command -v mysqldump &> /dev/null; then
    echo "MySQL client not installed. Creating empty backup for structure."
    echo "Database not configured yet" > $BACKUP_DIR/db_backup_$DATE.txt
    echo "Database not configured yet" > $SHARED_DIR/db_backup_$DATE.txt
else
    # Дамп базы данных (когда будет установлена)
    mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql 2>/dev/null || {
        echo "Database doesn't exist or credentials wrong"
        echo "No database to backup" > $BACKUP_DIR/db_backup_$DATE.txt
    }
    
    # Сжимаем если файл существует
    if [ -f "$BACKUP_DIR/db_backup_$DATE.sql" ]; then
        gzip $BACKUP_DIR/db_backup_$DATE.sql
        cp $BACKUP_DIR/db_backup_$DATE.sql.gz $SHARED_DIR/
    else
        cp $BACKUP_DIR/db_backup_$DATE.txt $SHARED_DIR/
    fi
fi

# Удаляем старые бэкапы (старше 7 дней)
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete 2>/dev/null
find $BACKUP_DIR -name "*.txt" -mtime +7 -delete 2>/dev/null
find $SHARED_DIR -name "*.sql.gz" -mtime +7 -delete 2>/dev/null
find $SHARED_DIR -name "*.txt" -mtime +7 -delete 2>/dev/null

echo "Backup completed"
echo "Location 1: $BACKUP_DIR/"
echo "Location 2: $SHARED_DIR/"
