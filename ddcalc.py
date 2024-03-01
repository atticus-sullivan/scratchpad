from functools import reduce
from decimal import Decimal
from terminaltables import SingleTable

def avg(lst):
    return reduce(lambda a, b: a + b, lst) / len(lst)

def table(foo, min:int, max:int, step:Decimal):
    i = Decimal(min)
    tab = [["var", "val"]]
    while i <= Decimal(max):
        tab.append([i, foo(i)])
        i += step

    table = SingleTable(tab)
    table.justify_columns[0] = 'right'
    table.justify_columns[1] = 'right'
    print(table.table)

def tableL(foo, li:list):
    li = map(lambda x: Decimal(str(x)), li)
    tab = [["var", "val"]]
    for i in li:
        tab.append([i, foo(i)])
    table = SingleTable(tab)
    table.justify_columns[0] = 'right'
    table.justify_columns[1] = 'right'
    print(table.table)

def sec2Str(i:int):
    ret = ""
    for suff,dur in [('s',60), ('m',60), ('h',60), ('d',24), ('mon30',30)]:
        ret = "%d%s " % (i % dur, suff) + ret
        i //= dur
        if i <= 0:
            return ret
    return ret




print('ceil floor fabs fmod fsum factorial log(x,base) ** sqrt pi e sec2Str, datetime timedelta')
