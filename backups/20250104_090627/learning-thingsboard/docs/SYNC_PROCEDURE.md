# Процедура синхронізації з Upstream репозиторієм

## Загальна інформація

Цей документ описує процедуру синхронізації локальної гілки з upstream репозиторієм ThingsBoard.

## Передумови

1. Налаштовані remote репозиторії:
   ```bash
   $ git remote -v
   joyshmitz    https://github.com/joyshmitz/thingsboard.github.io.git (fetch)
   joyshmitz    https://github.com/joyshmitz/thingsboard.github.io.git (push)
   new-repo     https://github.com/joyshmitz/thingsboard-learning.git (fetch)
   new-repo     https://github.com/joyshmitz/thingsboard-learning.git (push)
   origin       https://github.com/joyshmitz/thingsboard.github.io.git (fetch)
   origin       https://github.com/joyshmitz/thingsboard.github.io.git (push)
   upstream     https://github.com/thingsboard/thingsboard.github.io.git (fetch)
   upstream     https://github.com/thingsboard/thingsboard.github.io.git (push)
   ```

## Кроки синхронізації

1. Отримати останні зміни з upstream:
   ```bash
   git fetch upstream
   ```

2. Перевірити поточну гілку:
   ```bash
   git branch --show-current
   # Має показати: feature/thingsboard-lessons
   ```

3. Виконати rebase поточної гілки на upstream/master:
   ```bash
   git rebase upstream/master
   ```

4. Запушити зміни до форку (force push через rebase):
   ```bash
   git push origin feature/thingsboard-lessons --force
   ```

## Важливі примітки

- Використовуйте `--force` з обережністю, тільки коли впевнені, що це не зашкодить іншим розробникам
- Перед синхронізацією переконайтеся, що всі локальні зміни закомічені або збережені
- Якщо виникають конфлікти під час rebase, вирішіть їх перед продовженням

## Перевірка результату

Після синхронізації:
1. Ваша локальна гілка буде оновлена останніми змінами з upstream
2. Форк на GitHub буде синхронізовано з вашою локальною гілкою
3. Історія комітів буде чистою та лінійною
