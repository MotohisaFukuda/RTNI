# -*- coding: utf-8 -*-




##### 6.1.1 #####

from IHU_source import *

e1 = [["U", 1, "out", 1], ["X", 1, "in", 1]]
e2 = [["Y", 1, "out", 1], ["U", 1, "in", 1]]
e3 = [["U*", 1, "out", 1], ["Y", 1, "in", 1]]
e4 = [["X", 1, "out", 1], ["U*", 1, "in", 1]]
g = [e1, e2, e3, e4]
gw = [g,1]
print(gw)
visualizeTN(gw)

d = symbols('d')
Eg = integrateHaarUnitary(gw, ["U", [d], [d], d])
print(Eg)
visualizeTN(Eg)



##### 6.1.2 #####
from IHU_source import *

e1 = [["U", 1, "out", 1], ["X", 1, "in", 1]]
e2 = [["Y", 1, "out", 1], ["U", 1, "in", 1]]
e3 = [["U*", 1, "out", 1], ["Y", 1,"in", 1]]
g = [e1, e2, e3]
gw = [g,1]

d = symbols('d')
Eg = integrateHaarUnitary(gw, ["U", [d], [d], d])
print(Eg)
visualizeTN(Eg)



##### 6.2 #####
from IHU_source import *

e1 = [["A", 1, "out", 1], ["U", 1,  "in", 1]]
e2 = [["A", 1, "out", 2], ["U", 1, "in", 2]]
e3 = [["U*", 1, "out", 1], ["A", 1, "in", 1]]
e4 = [["U*", 1, "out", 2], ["A", 1, "in", 2]]
e5 = [["U", 1, "out", 2], ["U*", 1, "in", 2]]
g = [e1, e2, e3, e4, e5]
gw = [g,1]
print(gw)
visualizeTN(gw)

k,n = symbols('k,n')
Eg = integrateHaarUnitary(gw, ["U", [n, k], [n, k], n*k])
print(Eg)
visualizeTN(Eg)


##### 6.3 #####
from IHU_source import *

e1 = [["X", 1, "out", 1], ["U", 1, "in", 1]]
e2 = [["U*", 1, "out", 1], ["X", 1, "in", 1]]
e3 = [["X", 1, "out", 2], ["U", 2, "in", 1]]
e4 = [["U*", 2, "out", 1], ["X", 1, "in", 2]]
g = [e1, e2, e3, e4]
gw = [g,1]
print(gw)
visualizeTN(gw)

d = symbols('d')
Eg = integrateHaarUnitary(gw, ["U", [d], [d], d])
print(Eg)
visualizeTN(Eg)


#### 6.4 ####
from IHU_source import *
d,k,n = symbols('d,k,n')
e1 = [["U*", 2, "out", 1], ["U", 1, "in", 1]]
e2 = [["U*", 1, "out", 1], ["U", 2, "in", 1]]
e3 = [["U", 1, "out", 1], ["U*", 1, "in", 1]]
e4 = [["U", 2, "out", 1], ["U*", 2, "in", 1]]
e5 = [["U", 1, "out", 2], ["U*", 2, "in", 2]]
e6 = [["U", 2, "out", 2], ["U*", 1, "in", 2]]
g = [e1, e2, e3, e4, e5, e6]
gw = [[g, 1/(d* k)]]
print(gw)
visualizeTN(gw)

Eg = integrateHaarUnitary(gw, ["U", [d], [n, k], n*k])
print(Eg)
#visualizeTN(Eg)

from sympy import limit, oo
t = symbols('t')
Egt =  Eg[0][1].subs(d,t*k*n)
Egt_lim = simplify(limit(Egt,n,oo))
print(Egt_lim)

