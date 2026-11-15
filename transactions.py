from multiprocessing import Value
from os.path import curdir

from database import connect
from datetime import date
"""Две обязательные транзакции Python. Полные условия в docs/python-tasks.md."""


def issue_book(loan_id, reader_id, book_id, loan_date, due_date,
               *, fail_after_update=False):
    """Выдай книгу: уменьшение copies и INSERT loans в одной транзакции.

    Даты — datetime.date. При успехе верни loan_id после подтверждения.
    Нет читателя/он заблокирован, нет доступной книги или некорректный
    порядок дат: ValueError. Ошибки драйвера, включая повтор id, не скрывай.
    Уменьшай copies только при copies>0; проверь число изменённых строк.
    Если fail_after_update=True, после уменьшения copies, ДО INSERT,
    подними RuntimeError("Учебная ошибка выдачи"). Изменения откатываются.
    Используй одно соединение, autocommit=False и with для всей операции.
    """
    if due_date<loan_date:
        raise ValueError('Дата конца должнаа быть позже даты займа')

    with connect() as con:
        cur = con.cursor()
        cur.execute("""
            SELECT *
            FROM public.readers
            WHERE id = %s;
            """, (reader_id,),)
        if cur.rowcount == 0:
            raise ValueError('Читатель не найден')

        cur.execute("""
            SELECT copies
            FROM public.books
            WHERE id = %s;
            """, (book_id,),)
        copies: tuple[int] | None = cur.fetchone()
        if copies is None:
            raise ValueError('Книга не найдена, или нет экземпляров')
        if copies[0] < 1:
            raise ValueError('Книга не найдена, или нет экземпляров')
        if fail_after_update:
            raise RuntimeError('Учебная ошибка выдачи')

        cur.execute("""
            INSERT INTO public.loans (id, reader_id, book_id, loan_date, due_date)
            VALUES
                (%s, %s, %s, %s, %s)
            """, (loan_id, reader_id, book_id, loan_date, due_date,),)
        cur.close()
        con.commit()

    with connect().cursor() as cur:
        cur.execute("""
            SELECT id
            FROM public.loans
            WHERE id = %s
            """, (loan_id,),)
        res: tuple[int] | None = cur.fetchone()
        if res is None:
            raise ValueError('Запись не найдена')
        return res[0]

def return_book(loan_id, returned_on, *, fail_after_update=False):
    """Верни книгу: закрытие выдачи и увеличение copies в одной транзакции.

    returned_on — datetime.date. При успехе верни book_id после подтверждения.
    Закрывай только открытую выдачу, получи book_id через UPDATE ... RETURNING.
    Нет строки результата (не найдена/уже закрыта): ValueError.
    Дата раньше loan_date: ошибка CHECK PostgreSQL, передай её наружу.
    Если fail_after_update=True, после закрытия выдачи, ДО увеличения copies,
    подними RuntimeError("Учебная ошибка возврата"). Откатываются обе части.
    Повторный возврат не должен увеличивать copies второй раз.
    Используй одно соединение, autocommit=False и with для всей операции.
    """

    with connect() as _, connect().cursor() as cur:
        cur.execute("""
            SELECT returned
            FROM public.loans
            WHERE id = %s;
            """, (loan_id,),)
        is_closed: tuple[bool] | None = cur.fetchone()
        if is_closed is None:
            raise ValueError('Выдача не найдена или закрыта')
        if is_closed[0]:
            raise ValueError('Выдача не найдена или закрыта')
        cur.execute("""
            UPDATE public.loans
            SET
                returned = TRUE,
                returned_date = %s
            WHERE id = %s
            RETURNING book_id;
            """, (returned_on, loan_id,),)
        book_id: tuple[int] | None = cur.fetchone()
        if book_id is None:
            raise ValueError('Выдача не найдена или закрыта')
        if fail_after_update:
            raise RuntimeError('Учебная ошибка возврата')
        cur.execute("""
            UPDATE books
            SET
                copies = copies + 1
            WHERE id = %s
            RETURNING id;
            """, (book_id[0],),)
        res = cur.fetchone()
        if res is None:
            raise ValueError('Ошибка')

        return res[0]
