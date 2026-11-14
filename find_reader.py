import psycopg
from database import connect

"""Задание 11.2: параметризованный поиск. Условия в docs/python-tasks.md."""


def find_reader(reader_id: int):
    """Верни имя читателя по id или None, если его нет.

    Используй database.connect(), параметр %s и with для соединения.
    Подключение и запрос пароля реализуются только в database.py.
    Ошибки подключения и SQL не подменяй значением None.
    """
    with connect().cursor() as cur:
        cur.execute(
            """
            SELECT name
            FROM public.readers
            WHERE id = %s;""",
            (reader_id,),
        )
        result = cur.fetchone()
        return result

if __name__ == "__main__":
    print(find_reader(1))
