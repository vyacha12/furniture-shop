#!/bin/bash
# Комбинированный бэкап одним кликом

echo "=== STARTING COMPLETE BACKUP ==="
echo "Time: $(date)"

# 1. Git commit и push
echo "1. Pushing to GitHub..."
cd /home/$(whoami)/diploma_project
git add .
git commit -m "Manual backup: $(date +%Y%m%d_%H%M%S)"
git push origin main

# 2. Бэкап проекта
echo "2. Backing up project files..."
/home/$(whoami)/diploma_project/scripts/backup_project.sh

# 3. Бэкап БД (если есть)
echo "3. Backing up database..."
/home/$(whoami)/diploma_project/scripts/backup_db.sh 2>/dev/null || echo "Database backup skipped (DB not configured yet)"

echo "=== BACKUP COMPLETE ==="
echo "Files saved to:"
echo "1. GitHub: https://github.com/your-username/diploma-furniture-shop"
echo "2. Local: ~/diploma_project/backups/"
echo "3. Windows: D:\Diploma_Project\backups\"
