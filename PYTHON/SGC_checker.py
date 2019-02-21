# -*- coding: utf-8 -*-
"""
Created on Sun Oct  7 22:33:30 2018

@author: M
"""

from sympy import Symbol, simplify
import pickle
from sympy.utilities.iterables import ordered_partitions, multiset_permutations
from sympy.combinatorics import Permutation
import random


k = 20

n= Symbol('n') 
with open("SGC/table{}.pkl".format(k), "rb") as file:   
    T = pickle.load(file)
#print(T)

Partitions= [p[::-1] for p in ordered_partitions(k)]  
#print(Permutations)

def eCol(x,y):
    s=0
    for p in Partitions:
        s += T[str(p)+str(x)]*T[str(p)+str(y)]
    return simplify(s)

x1 = random.choice(Partitions)
y1 = random.choice(Partitions)

print(x1,y1)
print(eCol(x1,y1))

"""
Permutations = [p for p in  multiset_permutations(list(range(k)))]  
def eRow(x,y):
    s=0
    for p in Permutations:
        c = Permutation(p).full_cyclic_form
        Cycle = sorted([ len(cycle) for cycle in c],reverse=True)
        s += T[str(x)+str(Cycle)] * T[str(y)+str(Cycle)]
    return simplify(s)

x2 = random.choice(Partitions)
y2 = random.choice(Partitions)


print(x2,y2)
print(eRow(x2,y2))
"""
