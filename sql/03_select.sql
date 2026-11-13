-- 3. SELECT: 16 запросов
-- Подробный порядок выполнения: README.md. Требования к полям: docs/schema.md.

-- 1. Все читатели: id, name, city. Сортировка по name, затем id.
-- TODO: напиши решение здесь.

SELECT id, name, city
FROM public.readers
ORDER BY name, id;

-- 2. Название, цена и copies каждой книги. Сортировка по id книги.
-- TODO: напиши решение здесь.

SELECT title, price, copies
FROM public.books
ORDER BY id;

-- 3. Все читатели из Москвы. Сортировка по id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.readers
WHERE city = 'Москва'
ORDER BY id;

-- 4. Активные читатели из Казани. Сортировка по id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.readers
WHERE city = 'Казань' and active is true
ORDER BY id;

-- 5. Читатели без email. Сортировка по id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.readers
WHERE email is NULL
ORDER BY id;

-- 6. Читатели с заполненным email. Сортировка по id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.readers
WHERE email is NOT NULL
ORDER BY id;

-- 7. Читатели, зарегистрированные с 2026-03-01 включительно. Сортировка по registered_on, затем id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.readers
WHERE registered_on >= '2026-03-01'
ORDER BY id;

-- 8. Книги с copies=0. Сортировка по id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.books
WHERE copies = 0
ORDER BY id;

-- 9. Книги с price от 1500 до 2000 включительно. Сортировка по price, затем id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.books
WHERE price >= 1500 and price <= 2000
ORDER BY id;

-- 10. Книги категории 1 или 2, у которых copies>0. Правильно расставь скобки при использовании OR и AND. Сортировка по id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.books
WHERE (category_id = 1 or category_id = 2 ) and copies > 0
ORDER BY id;

-- 11. Три самые дорогие книги. При одинаковой цене сначала меньший id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.books
ORDER BY price DESC, id ASC
LIMIT 3;

-- 12. Одна книга с максимальным copies. При равенстве сначала меньший id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.books
ORDER BY price DESC, id ASC
LIMIT 1;

-- 13. Все незакрытые выдачи. Сортировка по due_date, затем id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.loans
WHERE returned IS false
ORDER BY due_date, id;

-- 14. Просроченные незакрытые выдачи на DATE '2026-06-01'. Просрочка означает due_date < этой даты. Сортировка по id.
-- TODO: напиши решение здесь.

SELECT *
FROM public.loans
WHERE due_date < '2026-06-01' and returned is false
ORDER BY id;

-- 15. Книги, которые вернули позже срока: returned_date > due_date. Сортировка по id выдачи.
-- TODO: напиши решение здесь.

SELECT *
FROM public.loans
WHERE returned_date > due_date
ORDER BY id;

-- 16. Сравни два запроса поиска отсутствующего email: через = NULL и IS NULL. Первый оставь рабочим SELECT, в комментарии объясни разницу результатов.
-- TODO: напиши решение здесь.

SELECT *
FROM public.readers
WHERE email is NULL;

SELECT *
FROM public.readers
WHERE email = NULL;

-- Второй запрос ничего не вернёт. Всё из-за того что Null это маркер неизвестности
-- илм отсутсвия данных. Любое сравнение с NULL возвращает unknown,
-- из-за чего результат выполнения второго запроса будет пустым.
-- В то время как IS проверяет состояние (true, false, unknown, null)

-- Вообще можно было не писать order by id
-- Как я понял, postgres это делает сам
