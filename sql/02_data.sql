-- 2. Заполнение
-- Подробный порядок выполнения: README.md. Требования к полям: docs/schema.md.

-- 1. Напиши INSERT для всех 12 строк data/readers.csv. Пустой email передай как NULL.
-- TODO: напиши решение здесь.

INSERT INTO public.readers (id, name, email, city, registered_on, active)
VALUES
    (1, 'Алиса', 'alice@example.test', 'Москва', '2026-01-10', True),
    (2, 'Максим', NULL, 'Казань', '2026-01-12', True),
    (3, 'Олег', 'oleg@example.test', 'Москва', '2026-02-01', True),
    (4, 'Ирина', NULL, 'Пермь', '2026-02-10', False),
    (5, 'Света', 'sveta@example.test', 'Казань', '2026-02-15', True),
    (6, 'Денис', 'denis@example.test', 'Пермь', '2026-03-01', True),
    (7, 'Нина', NULL, 'Москва', '2026-03-05', True),
    (8, 'Роман', 'roman@example.test', 'Казань', '2026-03-10', True),
    (9, 'Вера', 'vera@example.test', 'Омск', '2026-04-01', False),
    (10, 'Тимур', NULL, 'Омск', '2026-04-15', True),
    (11, 'Алиса', 'alice.perm@example.test', 'Пермь', '2026-05-01', True),
    (12, 'Лев', NULL, 'Москва', '2026-05-20', True);


-- 2. Добавь 7 авторов и 5 категорий из CSV.
-- TODO: напиши решение здесь.

-- 3. Добавь все 10 книг. Не уменьшай copies при загрузке исходных данных.
-- TODO: напиши решение здесь.

-- 4. Добавь все 13 пар book_authors.
-- TODO: напиши решение здесь.

-- 5. Добавь все 16 выдач. Пустой returned_date передай как NULL.
-- TODO: напиши решение здесь.

-- 6. Покажи данные всех шести таблиц. Сортировка по id, для book_authors по book_id, author_id. Сверь количество строк с docs/checkpoints.md.
-- TODO: напиши решение здесь.
