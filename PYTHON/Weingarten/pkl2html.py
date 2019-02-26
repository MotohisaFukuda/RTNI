# -*- coding: utf-8 -*-
"""
Created on Mon Feb 25 14:50:43 2019

@author: home
"""

def latexIt(s):
    return sympy.latex(sympy.sympify(s))

import os
from yattag import Doc
import pickle
import sympy

location = os.getcwd()
counter = 0


for file in os.listdir(location):
    try:
        if file.endswith(".pkl"):
            print ("pkl file found:\t", file)
            counter = counter+1
            
            doc, tag, text = Doc().tagtext()
            doc.asis('<!DOCTYPE html>')
                       
            # parse input file
            wg = pickle.load(open(file,"rb"))
            
            p = int(file[9:-4])

            with tag('html'):
                with tag('head'):
                    doc.asis('<script type="text/javascript" async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/latest.js?config=TeX-MML-AM_CHTML"></script>')                 
                with tag('body'):        
                    with tag('h1'):
                        text('Weingarten functions for p = ' + str(p))
                    text('Below are the values of the ')
                    with tag('a', ('href','https://en.wikipedia.org/wiki/Weingarten_function')):
                        text('Weingarten function')
                    text(' for permutation size p = '+str(p)+'. The input is given as a partition of p. You can also download them as a text ')
                    with tag('a', ('href',file[:-3]+'txt')):
                        text('file')      
                    text(' or as a python pickle ')
                    with tag('a', ('href',file)):
                        text('file') 
                    text('.\n\n')
                    for part in wg:
                        text("\[\operatorname{Wg}("+str(part[0])+") = "+latexIt(str(part[1]))+"\]\n");
                        
                            
            # write html in file
            fout = open(file[:-3]+"html", "w")
            fout.write(doc.getvalue()) 
            fout.close()

      
    except Exception as e:
        raise e
        print ("No files found!")

print ("Total pickle files found:\t", counter)

