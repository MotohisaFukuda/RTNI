# -*- coding: utf-8 -*-
"""
Created on Sat Aug 18 22:36:03 2018

@author: M
"""
from IHU_source import *



##########Tr[(id \otimes Tr) A] aftere##########

d,k,n = symbols('d k n')

e1 = [["A" , 1 , "out" , 1] , ["U" , 1 , "in" , 1]]
e2 = [["A" , 1 , "out" , 2] , ["U" , 1 , "in" , 2]]
e3 = [["U*" , 1 , "out" , 1] , ["A" , 1 , "in" , 1]]
e4 = [["U*" , 1 , "out" , 2] , ["A" , 1 , "in" , 2]]
e5 = [["U" , 1 , "out" , 2] , ["U*" , 1 , "in" , 2]]
g=[e1,e2,e3,e4,e5]
gw=[g,1]
visualizeTN(gw)
rm = ["U",[n,k],[n,k],n*k]
Eg = integrateHaarUnitary(gw,rm)
print(Eg)
visualizeTN(Eg)

##########





"""

e1 = [["A", 1, "R", 1], ["B", 1, "L", 1]]
e2 = [["A", 1, "R", 2], ["B", 1, "L", 2]]
e3 = [["A", 2, "R", 1], ["B", 2, "L", 1]]
e4 = [["A", 2, "R", 2], ["B", 2, "L", 2]]
g1 = [e1, e2, e3, e4]

f2 = [["A", 1, "R", 2], ["B", 2, "L", 2]]
f4 = [["A", 2, "R", 2], ["B", 1, "L", 2]]
g2 = [e1, f2, e3, f4]

h1 = [["A", 1, "R", 1], ["B", 2, "L", 1]]
h2 = [["A", 1, "R", 2], ["B", 2, "L", 2]]
h3 = [["A", 2, "R", 1], ["B", 1, "L", 1]]
h4 = [["A", 2, "R", 2], ["B", 1, "L", 2]]
g3 = [h1,h2,h3,h4]

k1 = [["A", 1, "R", 1], ["B", 3, "L", 1]]
k2 = [["A", 1, "R", 2], ["B", 3, "L", 2]]
k3 = [["A", 2, "R", 1], ["B", 1, "L", 1]]
k4 = [["A", 2, "R", 2], ["B", 1, "L", 2]]
g4 = [k1,k2,k3,k4]


gwA=[[g1,1],[g2,1]]
gwB=[[g1,1],[g3,1]]
gwC=[[g1,1],[g4,1]]
rm = []
EgA = integrateHaarUnitary(gwA,rm)
EgB = integrateHaarUnitary(gwB,rm)
EgC = integrateHaarUnitary(gwC,rm)
print(EgA)
print(EgB)
print(EgC)
#visualizeTN(Eg)


"""


