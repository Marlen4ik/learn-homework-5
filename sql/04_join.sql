-- 4. JOIN: 10 запросов
-- Подробный порядок выполнения: README.md. Требования к полям: docs/schema.md.

-- 1. Для каждой выдачи покажи id выдачи, имя читателя, название книги, returned. Сортировка по id выдачи.
-- TODO: напиши решение здесь.

SELECT l.id, r.name AS reader_name, b.title AS book_name, l.returned
FROM public.loans l
JOIN public.readers r ON l.reader_id = r.id
JOIN public.books b ON l.book_id = b.id;

-- 2. Только текущие выдачи: имя читателя, название книги и due_date. Сортировка по due_date, затем id выдачи.
-- TODO: напиши решение здесь.

SELECT l.id, r.name AS reader_name, b.title AS book_name, l.due_date
FROM public.loans l
JOIN public.readers r ON l.reader_id = r.id
JOIN public.books b ON l.book_id = b.id
ORDER BY l.due_date, l.id;

-- 3. Отчёт по просрочке на 2026-06-01: имя, email, книга, due_date. Используй только ещё не возвращённые книги. Сортировка по id выдачи.
-- TODO: напиши решение здесь.

SELECT l.id, r.name AS reader_name, r.email AS email, b.title AS book_name, l.due_date
FROM public.loans l
JOIN public.readers r ON l.reader_id = r.id
JOIN public.books b ON l.book_id = b.id
WHERE l.due_date < '2026-06-01' AND returned IS false
ORDER BY l.due_date, l.id;

-- 4. Все книги и названия их категорий, включая книги с copies=0. Сортировка по id книги.
-- TODO: напиши решение здесь.

SELECT
    b.*,
    c.title as category_name
FROM public.books b
JOIN public.categories c ON c.id = b.category_id;

-- 5. Все пары книга/автор через book_authors. Покажи book_id, title и имя автора. Сортировка по book_id, затем author_id.
-- TODO: напиши решение здесь.

SELECT ba.book_id, b.title, a.name
FROM public.book_authors ba
JOIN public.books b ON b.id = ba.book_id
JOIN public.authors a ON a.id = ba.author_id
ORDER BY ba.book_id, ba.author_id;

-- 6. Читатели, у которых никогда не было выдач. Используй LEFT JOIN. Выведи id, name, порядок по id.
-- TODO: напиши решение здесь.

SELECT r.id, r.name
FROM public.readers r
LEFT JOIN public.loans l ON r.id = l.reader_id
WHERE l.reader_id is NULL;

-- 7. Книги, которые ни разу не выдавали. Используй LEFT JOIN, порядок по id книги.
-- TODO: напиши решение здесь.

SELECT b.id, b.title
FROM public.books b
LEFT JOIN public.loans l ON b.id = l.book_id
WHERE l.book_id is NULL;


-- 8. Авторы без книг. Используй LEFT JOIN, порядок по id автора.
-- TODO: напиши решение здесь.

SELECT *
FROM public.authors a
LEFT JOIN public.book_authors b ON a.id = b.author_id
WHERE b.author_id is NULL;

-- 9. Пустые категории. Используй LEFT JOIN, порядок по id категории.
-- TODO: напиши решение здесь.

SELECT *
FROM public.categories c
LEFT JOIN public.books b ON b.category_id = c.id
WHERE b.category_id is NULL;

-- 10. Два варианта отчёта по всем читателям и их текущим выдачам: (а) returned=FALSE в WHERE после LEFT JOIN; (б) то же условие в ON. В обоих выведи reader_id, name, loan_id, порядок по reader_id и loan_id. Объясни, какие читатели исчезли в первом варианте и почему.
-- TODO: напиши решение здесь.

-- a)
SELECT r.id AS reader_id, r.name AS reader_name, l.id as loan_id
FROM public.readers as r
LEFT JOIN public.loans l ON l.reader_id = r.id
WHERE returned is false
ORDER BY reader_id, loan_id;

-- b)

SELECT r.id AS reader_id, r.name AS reader_name, l.id as loan_id
FROM public.readers as r
LEFT JOIN public.loans l ON l.reader_id = r.id AND returned is false
ORDER BY reader_id, loan_id;

-- В первом варианте можно увидеть что фильтр применяется после операции объединения таблиц
-- По итогу в первой таблице исчезли все читатели без долгов по выдачам
-- Во второй так как в начале убираются все поля где returned = false
-- И таблица слепливается со всеми существующими читателями
-- остаются записи с клиентами которые не имеют займов
