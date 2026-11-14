-- 7. Выдача и возврат: четыре сценария
-- Подробный порядок выполнения: README.md. Требования к полям: docs/schema.md.

-- 1. Сценарий А, откат: начни транзакцию, уменьши copies книги 10 с 3 до 2, добавь выдачу 200 для читателя 3 (loan_date=2026-06-01, due_date=2026-06-15, returned=FALSE), затем ROLLBACK. Проверь copies=3 и отсутствие выдачи 200.
-- TODO: напиши решение здесь.

BEGIN;

UPDATE public.books
SET copies = 2
WHERE id = 10;

INSERT INTO public.loans (id, reader_id, book_id, loan_date, due_date, returned)
VALUES
(200, 3, 10, '2026-06-01', '2026-06-15', FALSE);

ROLLBACK;

SELECT *
FROM public.loans
WHERE id = 200;

SELECT *
FROM public.books
WHERE id = 10;

-- 2. Сценарий Б, ошибка: начни транзакцию, уменьши copies книги 10 на 1, затем попробуй добавить выдачу 201 читателю 999. Ошибка ожидается.
--  После неё отдельно выполни SELECT этой книги и запиши реакцию сервера. Затем отдельно ROLLBACK и проверку copies=3. Перед сдачей весь сценарий Б
-- оставь закомментированным.
-- TODO: напиши решение здесь.

-- BEGIN;
--
-- UPDATE public.books
-- SET copies = copies - 1
-- WHERE id = 10;
--
--
-- INSERT INTO public.loans (id, reader_id, book_id, loan_date, due_date, returned)
-- VALUES
-- (201, 999, 10, '2026-06-01', '2026-06-15', FALSE);
--
-- SELECT *
-- FROM public.books
-- WHERE id = 10;
--
-- ROLLBACK;
--
-- -- ERROR:  insert or update on table "loans" violates foreign key constraint "loans_reader_id_fkey"
-- -- DETAIL:  Key (reader_id)=(999) is not present in table "readers".
-- -- ERROR:  current transaction is aborted, commands ignored until end of transaction block
--
-- SELECT *
-- FROM public.books
-- WHERE id = 10;

-- 3. Сценарий В, подтверждение: повтори сценарий А с выдачей 200, но заверши COMMIT. Проверь copies=2 и существование открытой выдачи 200.
-- TODO: напиши решение здесь.

BEGIN;

UPDATE public.books
SET copies = 2
WHERE id = 10;

INSERT INTO public.loans (id, reader_id, book_id, loan_date, due_date, returned)
VALUES
(200, 3, 10, '2026-06-01', '2026-06-15', FALSE);

COMMIT;

SELECT *
FROM public.loans
WHERE id = 200;

SELECT *
FROM public.books
WHERE id = 10;

-- 4. Сценарий Г, возврат: в новой транзакции закрой выдачу 200 (returned=TRUE, returned_date=2026-06-02) и увеличь copies книги 10 на 1. Заверши COMMIT. Проверь copies=3 и закрытую выдачу 200.
-- TODO: напиши решение здесь.

BEGIN;
UPDATE public.loans
SET returned = TRUE,
    returned_date = '2026-06-02'
WHERE id = 200;

UPDATE public.books
SET copies = copies + 1
WHERE id = 10;

COMMIT;

SELECT *
FROM public.loans
WHERE id = 200;

SELECT *
FROM public.books
WHERE id = 10;

-- 5. Проверь, что повторная попытка возврата не должна повторно увеличивать copies:
-- в отдельной транзакции попробуй изменить выдачу 200 только при returned=FALSE.
-- Если обновлено 0 строк, не выполняй увеличение copies. Заверши ROLLBACK и объясни решение в отчёте.
-- Ветвление выполняй вручную по числу изменённых строк в pgAdmin.
-- TODO: напиши решение здесь.

BEGIN;

UPDATE public.loans
SET returned = FALSE,
    returned_date = NULL
WHERE id = 200;

UPDATE public.loans
SET returned = TRUE,
    returned_date = '2026-06-02'
WHERE id = 200;

ROLLBACK;

--Не понятное задание. После обновления ничего не изменится

-- 6. Книга 30 имеет copies=0. В новой транзакции выполни уменьшение только при copies>0. Проверь число изменённых строк. При 0 строк не добавляй выдачу, сделай ROLLBACK и запиши, почему одного FOREIGN KEY недостаточно для этой проверки.
-- TODO: напиши решение здесь.

BEGIN;

SELECT *
FROM public.books
WHERE id = 30;

ROLLBACK;
-- Это тоже не понятное
