# Запуск 
1. Создание тестовых логов :
    > python3 log_generator.py ./logs

_MAX_LOG_SIZE_BYTES в log_generator отвечает за размер логов.

2. Объединение логов:
    > python3 merge_logs.py logs/log_a.jsonl logs/log_b.jsonl -o result/

