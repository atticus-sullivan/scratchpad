from functools import reduce

def avg(lst):
    return reduce(lambda a, b: a + b, lst) / len(lst)

print('ceil floor fabs factorial fmod fsum math.log(x,base) ** sqrt pi e convFormat')
