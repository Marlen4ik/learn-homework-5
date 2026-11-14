from collections.abc import Generator
from contextlib import contextmanager

import psycopg
from psycopg.rows import TupleRow
from psycopg.connection import Connection

"""Задание 11.1: подключение к PostgreSQL. Условия в docs/python-tasks.md."""


def connect() -> Connection[TupleRow]:
    """Верни новое открытое соединение Psycopg с autocommit=False.

    Прочитай PGHOST, PGPORT, PGDATABASE, PGUSER из окружения.
    По умолчанию: localhost, 5432, library_extended, postgres.
    Пароль запроси через getpass.getpass при каждом вызове.
    Здесь соединение не закрывай: вызывающая функция использует with connect().
    """
    return psycopg.connect(
        "postgresql://user@localhost/library_extended?password=pass", autocommit=False
    )
