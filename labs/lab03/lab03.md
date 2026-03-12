---
title: "Отчёт по лабораторной работе №3\nАдминистрациа Система Linux"
subtitle: "Администрациа Система Linux"
author: "Выполнил: Лемуш Мариу Франсишку
 НПИбд-01-24, 1032239162"
lang: ru-RU
toc: true
toc-depth: 2
lof: true
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
mainfont: DejaVu Serif
sansfont: DejaVu Sans
monofont: DejaVu Sans Mono
figureTitle: "Рис."
tableTitle: "Таблица"
lofTitle: "Список иллюстраций"
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float}
  - \floatplacement{figure}{H}
---

# Цель работы

- Развить навыки администрирования ОС Linux. 
- Получить первое практическое знакомство с технологией SELinux. 
- Проверить работу SELinux на практике совместно с веб-сервером Apache.

# Теоретическое введение

SELinux (Security-Enhanced Linux) обеспечивает усиление защиты путем внесения изменений как на уровне ядра, так и на уровне пространства пользователя.

# Выполнение лабораторной работы

Требуется создать структуру каталогов с разными разрешениями доступа для разных групп пользователей.

1. Откройте терминал с учётной записью root

![Проверка работы в режиме enforcing политики targeted](image/1.png){ width=100% }

2. В корневом каталоге создайте каталоги /data/main и /data/third:
```bash
mkdir -p /data/main /data/third
