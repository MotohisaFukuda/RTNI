# -*- coding: utf-8 -*-
"""
Created on Tue Jun 26 07:55:00 2018

@author: M
"""
import os.path
# import pickle
import math
import copy
import fractions
from sympy import Symbol, simplify, fraction
from sympy.utilities.iterables import ordered_partitions
from functools import reduce


########## Character Table ##########

# "PartsStocker(List).Dic" gives a dictionary of
# {# of removed boxes: [[List expression of valid border strip,signature],...]} 
# where 
# signature = (-1)^{height}
# 
class PartsStocker:
    def __init__(self,List):
        self.List = List
        Range = range(len(self.List))
        # enumerating BSTs to be removed.
        Collections = [[0]*i + x for i in Range for x in self.BS_Finder(self.List[i:])]
        Col_indexed = [ [sum(x),x] for x in Collections]
        # making a dictionary.
        self.Dic = {i+1:[] for i in range(sum(self.List))}
        for x in Col_indexed:
            # finding out what are left after each removal.
            # appending information on hights of removed BS.
            Leftover = [[self.List[i] -  x[1][i] for i in Range],\
                        (-1)**(len(Range) - x[1].count(0) -1)]
            # deleting 0's if some (bottom) rows vanish.
            L = [[x for x in Leftover[0] if x !=0],Leftover[1]]
            self.Dic[x[0]].append(L)

        

    # Input: List specifies Young diagram, 
    # Output: is a list=[b_1,...,b_n] specifying all valid border strips
    #            each b_j is  a list b_j=[e_1,\ldots,e_n] specifying a border strip
    #                              entry e_i specifies how many boxes belong to the i-th row of the border strip
    #            
    def BS_Finder(self,List):
        Length = len(List)
        # calculating the difference of neighboring rows.
        Gaps = [List[i] - (List + [0])[i+1] for i in range(Length)]

        # getting sizes of invalid border strips. The last one is redundent. 
        Bad = [sum(Gaps[0:i+1]) +i+1   for i in range(Length)]

        # enumerating all possible border strips, including invalid ones.
        r = [0]*Length
        BSs = []
        for i in range(Length):
            for j in range(Gaps[i]+1):
                r[i] += 1
                new = copy.copy(r)
                BSs.append(new)
                
        # removing invalid ones
        Ex = Bad[:-1][::-1]
        for i in Ex:
            del(BSs[i-1])
        # removing another redundant  border strip generated for some technical reason
        del(BSs[-1])
        return BSs



"""
class Character:
    def __init__(self,ListA,ListB):
        self.ListA = ListA
        self.ListB = ListB
        # quoting the class:PartsStocker.
        Deco = PartsStocker(self.ListA).Dic[self.ListB[0]]
        # preparing for the calculation of character.
        # we have set the character of [][] is 1 to deal with the case
        # where the leftover is empty. 
        Summand = [x[1] * Memo(sum(x[0])).Data[str(x[0])+str(self.ListB[1:])]\
                   for x in Deco]
        self.Char = sum(Summand)
"""
        

#print(Character([1],[1]).Char)
        
class CharacterTableCalculator:
    def __init__(self,k):
        self.k = k
        Partitions= [p[::-1] for p in ordered_partitions(self.k)]
        self.Dic = {}
        M = [Memo(i).Data for i in range(self.k)]
        for p in Partitions:
            Deco = PartsStocker(p).Dic
            
            for q in Partitions:
                self.Dic[str(p)+str(q)] =sum(\
                [x[1] * M[sum(x[0])][str(x[0])+str(q[1:])] for x in Deco[q[0]]])
                


""" 
    def Character(ListA,ListB):
        # quoting the class:PartsStocker.
        
        # preparing for the calculation of character.
        # we have set the character of [][] is 1 to deal with the case
        # where the leftover is empty. 
        Summand = [x[1] * Memo(sum(x[0])).Data[str(x[0])+str(self.ListB[1:])]\
                   for x in Deco]
        self.Char = sum(Summand)

"""

#print(CharacterTableCalculator(1).Dic)
#

          

            
# making instances of characters:Memo(k).
# if there is a file, reads it.
# otherwise, generates and writes down.
class Memo:
    def __init__(self,k):
        self.k = k
        self.Data = {}
        if self.k == 0:
            self.Data.update({'[][]':1})
            
        elif os.path.isfile('SGC/table{}.txt'.format(self.k)):
            with open("SGC/table{}.txt".format(self.k), 'r') as file:
                self.Data.update(eval(file.read()))
                
#         elif os.path.isfile('SGC/table{}.pkl'.format(self.k)):
#             with open("SGC/table{}.pkl".format(self.k), 'rb') as file:
#                 self.Data.update(pickle.load(file))

        else:
            if not os.path.exists('SGC'):
                os.makedirs('SGC')
            else:
                pass
            self.Data.update(CharacterTableCalculator(self.k).Dic)
            
            with open("SGC/table{}.txt".format(self.k), "w") as fp:
                fp.write(str(self.Data))
                
#             with open("SGC/table{}.pkl".format(self.k), "wb") as fp:   #Pickling
#                 pickle.dump(self.Data, fp)
            
#print(Memo(14).Data)
                
        
#print(CharacterTableOrganizer(3))
        
class SGCTOganizer:
    def __init__(self,k):
        self.k = k
        if not os.path.exists('SGC'):
            os.makedirs('SGC')
        else:
            pass
        for i in range(self.k):
            Memo(i)
        self.Dic = Memo(self.k).Data

#print(SGCTOganizer(8).Dic)

########## Schur Polynomial ##########

class SchurPolyGenerator:
    def __init__(self,k):
        self.k = k

        # Generating partitions of k in the non-increasing order.
        self.YoungDiagram = [p[::-1] for p in ordered_partitions(self.k)]
        # Making n into a symbol. 
        n= Symbol('n') 
        # Maling a list of reciprocals of Schur polynomials for all Young Diagrams.
        # [[permutation, Schur poly],[,],...]
        self.ReciprocalList =\
        { str(p): self.SchurPolyReciprocal(p,n)  for p in self.YoungDiagram}
    
    # Generating reciprocal of a Schur polynomial for a fixed Young Diagram... 
    # [permutation, Schur poly]
    def SchurPolyReciprocal(self,p,n):
        l = len(p)
        Pairs = [[x,y] for x in range(l) for y in range(l) if x <y]
        A = [ fractions.Fraction(pair[1]-pair[0] ,p[pair[0]] - p[pair[1]] + pair[1]-pair[0])
             for pair in Pairs]
        B = [ (l-m+k) / (n-m+k) for m in range(l)  for k in range(p[m]) ]
        SPR = reduce(lambda x, y: x*y, A+B)
        return SPR
    

#print(SchurPolyGenerator(3).ReciprocalList)
        
    
class SchurPolyOganizer:
    def __init__(self,k):
        self.k = k
        self.List = {}
        
        if os.path.isfile('SP/list{}.txt'.format(self.k)):
            with open("SP/list{}.txt".format(self.k), 'r') as file:
                n= Symbol('n')
                self.List.update(eval(file.read()))
                
#         if os.path.isfile('SP/list{}.pkl'.format(self.k)):
#             with open("SP/list{}.pkl".format(self.k), 'rb') as file:
#                 self.List.update(pickle.load(file))

        else:
            if not os.path.exists('SP'):
                os.makedirs('SP')
            else:
                pass
            self.List.update(SchurPolyGenerator(self.k).ReciprocalList)
            
            with open("SP/list{}.txt".format(self.k), "w") as fp:   #Pickling
                fp.write(str(self.List))
            
#             with open("SP/list{}.pkl".format(self.k), "wb") as fp:   #Pickling
#                 pickle.dump(self.List, fp)
        

########## Weingarten Functions ##########

class WeingartenFunctionGenerator:
    def __init__(self,k):
        
        self.k = k 
        # Generating all the partitions of k in the non-increasing order. 
        self.Partitions = [p[::-1] for p in ordered_partitions(self.k)]
        
        # reading or making lists of characters and Schur's.
        self.SGC = SGCTOganizer(self.k).Dic
        self.SP = SchurPolyOganizer(self.k).List
        
        # Making a list of Weingarten functions.
        # [[partition type, the function],[],...]
        self.List = [[p,self.Weingarten(p)] for p in self.Partitions]

        
        
    # Calculating the Weingarten function for a fixed permutation.
    # [partition type, the function]
    def Weingarten(self,p):
        
        Parts =\
        [[q, (self.SGC[str(q)+str([1]*self.k)])**2,\
           self.SGC[str(q)+str(p)],\
           self.SP[str(q)]] for q in self.Partitions]
        Summands = [reduce(lambda x, y: x*y, P[1:4]) for P in Parts]
        
        W = fractions.Fraction(1,(math.factorial(self.k))**2) * sum(Summands)
        W_c = copy.deepcopy(simplify(W))
        del Parts
        del Summands
        del W
        return W_c

        
def weigartenFunctionGenerator(k,display,record):
    WFs = WeingartenFunctionGenerator(k).List
    if display == 'yes':
        print(WFs)
    else:
        pass
    if record == 'yes':
        if not os.path.exists('Weingarten'):
            os.makedirs('Weingarten')
        else:
            pass
        
        with open("Weingarten/functions{}.txt".format(k), "w") as fp:
            fp.write(str(WFs))
        
#         with open("Weingarten/functions{}.pkl".format(k), "wb") as fp:   #Pickling
#             pickle.dump(WFs, fp)
            
    else:
        pass

# defining a class for IHU_source.
class WFs:
    def __init__(self,k):
        self.k = k
        self.wfs = WeingartenFunctionGenerator(self.k).List
        
        if not os.path.exists('Weingarten'):
            os.makedirs('Weingarten')
        else:
            pass
        
        with open("Weingarten/functions{}.txt".format(self.k), "w") as fp:
            fp.write(str(self.wfs))
        
#         with open("Weingarten/functions{}.pkl".format(self.k), "wb") as fp:   #Pickling
#             pickle.dump(self.wfs, fp)
            
    


def characterTableGenerator(k,display):
    if display == 'yes':
        print(SGCTOganizer(k).Dic)
    else:
        SGCTOganizer(k)

    


