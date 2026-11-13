-- 1. Таблицы и ограничения
-- Подробный порядок выполнения: README.md. Требования к полям: docs/schema.md.

-- 1. Создай public.readers по docs/schema.md.
-- TODO: напиши решение здесь.

CREATE table public.readers(
    id INT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NULL,
    city TEXT NOT NULL,
    registered_on DATE NOT NULL,
    active BOOLEAN NOT NULL DEFAULT true
    );


-- 2. Создай public.authors и public.categories.
-- TODO: напиши решение здесь.

CREATE table public.authors(
    id INT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE table public.categories(
    id int PRIMARY key,
    title text NOT NULL UNIQUE
);

-- 3. Создай public.books, включая внешний ключ и все CHECK.
-- TODO: напиши решение здесь.

CREATE table public.books(
    id INT PRIMARY KEY,
    title TEXT NOT NULL,
    category_id INT NOT NULL REFERENCES categories(id),
    copies INT NOT NULL DEFAULT 0 CHECK(copies>=0),
    price NUMERIC(10,2) NOT NULL CHECK(price>=0),
    published_year INT NOT NULL CHECK(published_year BETWEEN 1900 AND 2026)
);

-- 4. Создай public.book_authors с составным первичным ключом и двумя внешними ключами.
-- TODO: напиши решение здесь.

CREATE table public.book_authors(
    book_id INT NOT NULL REFERENCES books(id),
    author_id INT NOT NULL REFERENCES authors(id),
    PRIMARY KEY(book_id, author_id)
);

-- 5. Создай public.loans с внешними ключами и согласованием returned/returned_date.
-- TODO: напиши решение здесь.

CREATE table public.loans(
    id INT PRIMARY KEY,
    reader_id INT NOT NULL REFERENCES readers(id),
    book_id INT NOT NULL REFERENCES books(id),
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL CHECK (due_date >= loan_date),
    returned BOOLEAN NOT NULL DEFAULT false,
    returned_date DATE,
    CHECK (
    (returned = false and returned_date is null)
    OR
    (returned = true and returned_date is NOT NULL)
    )
);

ALTER table loans
add constraint check_returned_date
CHECK (
(returned = false and returned_date is null)
OR
(returned = true and returned_date is NOT NULL)
);

-- 6. Посмотри структуру каждой таблицы в pgAdmin. В docs/report.md запиши ограничения и связи, которые проверил.
-- TODO: напиши решение здесь.

-- Запускать команду в psql
-- \d + название таблицы
