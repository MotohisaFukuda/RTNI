# -*- coding: utf-8 -*-
"""
Created on Sun Oct  7 22:12:14 2018

@author: M

A Translator form pickle to text.
"""
import pickle
for k in range(0,21,1):
    with open("functions{}.pkl".format(k), "rb") as file:   
        WF = pickle.load(file)
    with open("functions{}.txt".format(k), "w") as output:
        output.write(str(WF))


