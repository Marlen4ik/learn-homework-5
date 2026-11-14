-- 6. Ограничения: 12 ошибочных примеров
-- Подробный порядок выполнения: README.md. Требования к полям: docs/schema.md.
-- Каждый пример проверяй отдельно, вне BEGIN, с Auto commit.
-- В каждом примере нарушай только указанное ограничение.
-- Перед сдачей ошибочные команды оставь закомментированными.

-- 1. Нарушь PRIMARY KEY: повтор id существующего читателя.
-- TODO: напиши решение здесь.

INSERT INTO public.readers (id, name, email, city, registered_on, active)
VALUES
    (1, 'Marlen', 'marlen@example.test', 'Москва', '2026-01-10', True);

-- 2. Нарушь UNIQUE: новый читатель с существующим непустым email.
-- TODO: напиши решение здесь.

INSERT INTO public.readers (id, name, email, city, registered_on, active)
VALUES
    (123, 'Marlen', 'alice@example.test', 'Москва', '2026-01-10', True);

-- 3. Нарушь NOT NULL: новый читатель с name=NULL.
-- TODO: напиши решение здесь.

INSERT INTO public.readers (id, name, email, city, registered_on, active)
VALUES
    (321, NULL, 'mar@example.test', 'Москва', '2026-01-10', True);

-- 4. Нарушь CHECK copies: новая книга с copies=-1.
-- TODO: напиши решение здесь.

INSERT INTO public.books (id, title, category_id, copies, price, published_year)
VALUES
(10, 'Основы Python', 1, -1, 1500.00, 2024);

-- 5. Нарушь CHECK price: новая книга с нулевой ценой.
-- TODO: напиши решение здесь.

INSERT INTO public.books (id, title, category_id, copies, price, published_year)
VALUES
(12, 'Основы Python', 1, 2, 0, 2024);

-- 6. Нарушь CHECK published_year: новая книга с годом 1899.
-- TODO: напиши решение здесь.

INSERT INTO public.books (id, title, category_id, copies, price, published_year)
VALUES
(112, 'Основы Python', 1, 2, 2, 1899);

-- 7. Нарушь внешний ключ: новая книга с несуществующей category_id.
-- TODO: напиши решение здесь.


INSERT INTO public.books (id, title, category_id, copies, price, published_year)
VALUES
(112, 'Основы Python', 1123, 2, 2, 2024);


-- 8. Нарушь составной первичный ключ: повтор существующей пары book_authors.
-- TODO: напиши решение здесь.

INSERT INTO public.book_authors (book_id, author_id)
VALUES
(10, 1);

-- 9. Нарушь внешний ключ: выдача несуществующему читателю с существующей книгой.
-- TODO: напиши решение здесь.

INSERT INTO public.loans (id, reader_id, book_id, loan_date, due_date, returned, returned_date)
VALUES
(122, 112231, 10, '2026-05-01', '2026-05-15', FALSE, NULL);

-- 10. Нарушь согласованность дат: due_date раньше loan_date.
-- TODO: напиши решение здесь.

INSERT INTO public.loans (id, reader_id, book_id, loan_date, due_date, returned, returned_date)
VALUES
(122, 1, 10, '2026-05-01', '2024-05-15', FALSE, NULL);


-- 11. Нарушь согласованность возврата: returned=TRUE и returned_date=NULL.
-- TODO: напиши решение здесь.

INSERT INTO public.loans (id, reader_id, book_id, loan_date, due_date, returned, returned_date)
VALUES
(122, 1, 10, '2026-05-01', '2026-05-15', True, NULL);

-- 12. Попробуй удалить существующую категорию, на которую ссылаются книги. Объясни причину отказа.
-- TODO: напиши решение здесь.

DELETE FROM public.categories
WHERE id = 1;

-- Запрос не будет выполнен, так как данный ключ ссылаются с других таблиц
-- Также на него действует ограничение целостности данных
