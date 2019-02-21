# -*- coding: utf-8 -*-
"""
Created on Tue Sep 18 23:20:40 2018

@author: M
"""

from sympy import Matrix, Symbol, simplify
import pickle
from sympy.combinatorics import Permutation
from sympy.utilities.iterables import multiset_permutations
import random

k = 8



n= Symbol('n') 

Permutations = [p for p in  multiset_permutations(list(range(k)))]    
#print(Permutations)
L = len(Permutations)

def mm(i,j):
    a = Permutations[i]
    b = Permutations[j]
    b_inv = [b.index(i) for i in range(k)]
    return n**(Permutation(a)*Permutation(b_inv)).cycles
#M = Matrix(L,L,mm)
#print(M)

with open("Weingarten/functions{}.pkl".format(k), "rb") as file:   
    WF = pickle.load(file)
WF_Dic = {str(wf[0]):wf[1] for wf in WF}

#print(WF_Dic )

def nn(i,j):
    a = Permutations[i]
    b = Permutations[j]
    b_inv = [b.index(i) for i in range(k)]
    c = (Permutation(a) * Permutation(b_inv)).full_cyclic_form
    Cycle = sorted([ len(cycle) for cycle in c],reverse=True)
    return WF_Dic[str(Cycle)]
#print(nn(0,1))
#N = Matrix(L,L,nn)

# the following matrix calculation can be done upto k = 4 on my laptop.
#print(simplify(M*N))


##### Picking a random sample #####
# this method barely works on my laptop upto k = 8    

x = random.choice(range(L))
y = random.choice(range(L))

def e(x,y):
    s=0
    for i in range(L):
        s += mm(x,i) * nn(y,i)
    return simplify(s)
print(x,y)
print(e(x,y))

#print(e(26884,26884))