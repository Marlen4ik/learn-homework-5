-- 5. INSERT, UPDATE, DELETE
-- Подробный порядок выполнения: README.md. Требования к полям: docs/schema.md.

-- 1. В одной транзакции добавь читателя id=90 с корректными полями, покажи его, измени email и город, снова покажи, удали его и покажи отсутствие строки. Заверши ROLLBACK. Исходные данные должны сохраниться.
-- TODO: напиши решение здесь.

BEGIN;

    INSERT INTO public.readers(id, name, email, city, registered_on, active)
    VALUES
        (90, 'Марлен', 'marlen@example.test', 'shymkent', '2026-01-10', True);

    SELECT *
    FROM public.readers
    WHERE id = 90;

    UPDATE public.readers
    SET email = 'lol@mail.com',
        city = 'Almaty'
    WHERE id = 90;

    SELECT *
    FROM public.readers
    WHERE id = 90;

    DELETE FROM public.readers
    WHERE id = 90;


    SELECT *
    FROM readers
    WHERE id = 90;


ROLLBACK;

-- 2. В отдельной транзакции добавь категорию 90, автора 90, книгу 900 этой категории с copies=2, price=1000, published_year=2026 и связь книги с автором. Покажи их одним JOIN.
-- TODO: напиши решение здесь.

BEGIN;

INSERT INTO public.categories (id, title)
VALUES (90, 'что-то');

INSERT INTO public.authors (id, name)
VALUES
(90, 'кто-то');

INSERT INTO public.books (id, title, category_id, copies, price, published_year)
VALUES
(900, 'Основы Python', 90, 2, 1000.00, 2026);

INSERT INTO public.book_authors (book_id, author_id)
VALUES
(900, 90);

SELECT *
FROM public.book_authors ba
JOIN public.books b ON b.id = ba.book_id
JOIN public.authors a ON a.id = ba.author_id
WHERE book_id = 900 or author_id = 90;


-- 3. В той же транзакции увеличь цену только книги 900 на 10 процентов и copies на 3. Покажи новые значения.
-- TODO: напиши решение здесь.

UPDATE public.books
SET price = price * 1.1,
    copies = copies + 3
WHERE id = 900;

SELECT *
FROM public.books
WHERE id = 900;


-- 4. В той же транзакции удали созданные строки в порядке, который не нарушает внешние ключи. Заверши ROLLBACK.
-- TODO: напиши решение здесь.

DELETE FROM public.book_authors
WHERE book_id = 900 and author_id = 90;

DELETE FROM public.books
WHERE id = 900;

DELETE FROM public.authors
WHERE id = 90;


DELETE FROM public.categories
WHERE id = 90;

ROLLBACK;

-- 5. В новой транзакции увеличь copies всех книг категории 2 на 1. Перед UPDATE покажи строки, которые он затронет, после покажи результат. Заверши ROLLBACK.
-- TODO: напиши решение здесь.

BEGIN;

SELECT *
FROM public.books
WHERE category_id = 2;

UPDATE public.books
SET copies = copies + 1
WHERE category_id = 2;

SELECT *
FROM public.books
WHERE category_id = 2;

ROLLBACK;

-- 6. В новой транзакции добавь книгу 901 в существующую категорию с ценой 1000 и годом 2026, пропустив copies в списке полей. Проверь DEFAULT, затем ROLLBACK.
-- TODO: напиши решение здесь.

BEGIN;

INSERT INTO public.books (id, title, category_id, price, published_year)
VALUES (901, 'Хроники epstein айланда', 1, 1000, 2026);

SELECT *
FROM public.books
WHERE id = 901;

ROLLBACK;
