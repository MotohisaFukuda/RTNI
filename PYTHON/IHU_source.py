# -*- coding: utf-8 -*-
"""
a copy of "average_graph_tensor12" with a corection in Calc.Reconnection.

@author: M
"""
import os.path
from sympy import symbols, simplify
from sympy.combinatorics import Permutation
from itertools import groupby
import copy
import networkx as nx
import itertools
import matplotlib.pyplot as plt
import pickle
import math


from WFG_source import *


# preparing several things for later use.
class Prep:
    def __init__(self,Edges,Weight,RM_List):
        self.Edges = Edges
        self.Weight = Weight
        self.RM_List = RM_List

        self.RM_Number = len(RM_List) #!!!

        
        # extracting lims of matrices.
        M_Lims = [ x[y] for x in Edges for y in [0,1]]
        # selecting lims of random matrices.
        RM_Lims = [x for x in M_Lims for rm in RM_List  if x[0] == rm[0] or x[0] == rm[0]+'*'] 
        
        # identifying matrices from the above list of lims.
        Matrices = [x[0:2] for x in M_Lims]
        
        
        # for each random matrix set explicitly, we collect and sort random matrices identified from the lims.
        RM1 = [sorted([x for x in Matrices if x[0] == rm[0]],key = lambda t: t[1]) 
               for rm in RM_List]
        RM2 = [sorted([x for x in Matrices if x[0] == rm[0] +'*'],key = lambda t: t[1])
               for rm in RM_List]
        
        # putting the same matrices together.
        self.RM1_grouped = [[x for x,y in groupby(rm1)] for rm1 in RM1] #!!!(?)
        RM2_grouped = sorted([[x for x,y in groupby(rm2)] for rm2 in RM2])
        
        # listing random matrices in the calculus. 
        self.RMs = [y[0] for x in self.RM1_grouped for y in x]+[y[0] for x in RM2_grouped for y in x] #!!!
        
        # relabeling the random matrices for the sake of Weingarten calculus.
        RM1_Labels = [[ [rm1g[i][0:2] ,[rm1g[i][0],i]]
                        for i in range(len(rm1g))] for rm1g in self.RM1_grouped]
        RM2_Labels = [[ [rm2g[i][0:2] ,[rm2g[i][0],i]]
                        for i in range(len(rm2g))] for rm2g in RM2_grouped]
        
        # making a dictionary for relabeling.
        Translation = [ [x[0][0]+str(x[0][1]) ,x[1][0:2]]  for i in range(self.RM_Number) for x in RM1_Labels[i] ]+\
        [ [x[0][0]+str(x[0][1]) ,x[1][0:2]]  for i in range(self.RM_Number) for x in RM2_Labels[i] ]
        Translation_inv = [ [x[1][0]+str(x[1][1]) ,x[0][0]+str(x[0][1])]  for i in range(self.RM_Number) for x in RM1_Labels[i] ]+\
        [ [x[1][0]+str(x[1][1]) ,x[0][0]+str(x[0][1])]  for i in range(self.RM_Number) for x in RM2_Labels[i] ]
        self.Label_Dic = dict(Translation) #!!!
        self.Label_Dic_inv = dict(Translation_inv) #!!!

        # listing all possible limes; 
        # for each random matrix set explicitly, 
        # generating all the lims of random matrices in the calculus.
        RM_Lims_generated1 =\
        [[x+['L',y]  for x in self.RM1_grouped[i] for y in range(len(RM_List[i][1]))]\
        +[x+['R',y]  for x in self.RM1_grouped[i] for y in range(len(RM_List[i][2]))]  for i in range(self.RM_Number)]
        RM_Lims_generated2 =\
        [[x+['L',y] for x in RM2_grouped[i] for y in range(len(RM_List[i][2]))]\
        +[x+['R',y] for x in RM2_grouped[i] for y in range(len(RM_List[i][1]))]  for i in range(self.RM_Number)]
        RM_Lims_generated = [[x   for x in RM_Lims_generated1[i] ] +\
        [x  for x in RM_Lims_generated2[i] ] for i in range(self.RM_Number)]
        RM_Lims_generated_flat = [x for i in range(self.RM_Number) for x in RM_Lims_generated[i]]
        
        self.RMLg_String = [ [x[0]+str(x[1])+x[2]+str(x[3]) for x in RM_Lims_generated[i]] for i in range(self.RM_Number)] #!!!
        
        # listing lims of random matrices without *.
        self.RMLg1_relabeled = [[self.Label_Dic[x[0]+str(x[1])] +x[2:4] for x in RM_Lims_generated1[i]] for i in range(self.RM_Number)] #!!!
        
        # finding empty lims.
        RM_Lims_empty = [x for x in RM_Lims_generated_flat if x not in RM_Lims]
        
        # adding extra edges for each empty lim.
        Edges_extra = [[x,['@'+x[0]] + x[1:4]] for x in RM_Lims_empty] 
        
        # preparing edges for Weingarten calculus.
        Edges_Graph = Edges + Edges_extra
        
        # treating cases which gives 0.
        for i in range(self.RM_Number):
            if [ len(x) for x in self.RM1_grouped[i]] != [ len(x) for x in RM2_grouped[i]]:
                Edges_Graph.clear()
                Weight = 0
            else:
                pass
        
        # preparing a graph for Weingarten calculus; 
        self.G = nx.MultiGraph()
        for x in Edges_Graph:
            a = x[0][0]+str(x[0][1])+x[0][2]+str(x[0][3])
            b = x[1][0]+str(x[1][1])+x[1][2]+str(x[1][3])
            self.G.add_edge(a,b,info = [a,b])
            
            # storing the original lists, aftet changing them into strings.
            self.G.nodes[a]['original'] = x[0]
            self.G.nodes[b]['original'] = x[1]
            



# loading Weingarten functions to be used; n is the default symbolic variable for the dimension.
class WGF:
    def __init__(self,SDs):
        self.SDs = SDs
        Sizes = [x[0] for x in self.SDs]
        Dims = [x[1] for x in self.SDs]
        n = symbols('n')
        self.Dic ={}
        self.Addressbook ={}
        for i in range(len(SDs)):
            if not os.path.isfile('Weingarten/functions{}.pkl'.format(Sizes[i])):
                Photocopy = WFs(Sizes[i]).wfs
            else:
                with open('Weingarten/functions{}.pkl'.format(Sizes[i]), 'rb') as file:
                    Photocopy = pickle.load(file)# Unpickling
            self.Dic['wg{}'.format(Sizes[i])] = [[p[0],p[1].subs(n,Dims[i])] for p in Photocopy] 
            # Here, substituting n by t the actual size of matrix.
            self.Addressbook['wg{}'.format(Sizes[i])] = [p[0] for p in Photocopy]


    
        
# averaging each diagram. 
#Calc.output = [[G,W],...]
class Calc:
    def __init__(self,Edges,Weight,RM_List):
        self.Edges = Edges
        self.Weight = Weight
        self.RM_List = RM_List
        self.PRE = Prep(Edges,Weight,RM_List)
        SDs = [[len(self.PRE.RM1_grouped[i]),self.RM_List[i][3]] for i in range(self.PRE.RM_Number)]
        self.WGF_all = WGF(SDs)
        self.Output = self.Calculator()

    # graphical calculus for one RM.
    def Reconnection(self,Graph,a,b,RM_ID):
        w = 1
        G = copy.deepcopy(Graph)
        
        Average_Connections =\
            [ [x, [x[0]+'*',Permutation(a)(x[1]),'R',x[3]]]\
            for x in self.PRE.RMLg1_relabeled[RM_ID] if x[2] == 'L'] +\
            [ [x, [x[0]+'*',Permutation(b)(x[1]),'L',x[3]]]\
            for x in self.PRE.RMLg1_relabeled[RM_ID] if  x[2] == 'R']
            
        # making node names in strings and adding new edes to the graph.
        Average_Connections_List =\
        [[self.PRE.Label_Dic_inv[x[0][0]+str(x[0][1])]+x[0][2]+str(x[0][3]),\
         self.PRE.Label_Dic_inv[x[1][0]+str(x[1][1])]+x[1][2]+str(x[1][3])] for x in Average_Connections]
        G.add_edges_from(Average_Connections_List)
        
        # tidying up:
        for y in self.PRE.RMLg_String[RM_ID]: # for each RM lim
            neighbour = list(G.neighbors(y))
            if len(neighbour) == 2: #case where the lim is connected to two nodes.
                G.remove_node(y) 
                G.add_edge(neighbour[0],neighbour[1], info = neighbour) 
            
            elif G.degree(y) == 2:
                G.remove_node(y)
    
            else: # case the node is a pendant.
                if G.node[y]['original'][0][-1] != '*' and G.node[y]['original'][2] == 'L' :
                    side = 1
                elif G.node[y]['original'][0][-1] == '*' and G.node[y]['original'][2] == 'R':
                    side = 1
                else:
                    side = 2
                w *= self.RM_List[RM_ID][side][G.nodes[y]['original'][3]]
                G.remove_node(y)
    
    
        #Multiplying Weingarten function.
        t = len(self.PRE.RM1_grouped[RM_ID])
        b_inv = [b.index(i) for i in range(t)]
        c = (Permutation(a) * Permutation(b_inv)).full_cyclic_form
        Cycle = sorted([ len(cycle) for cycle in c],reverse=True)
        Address = self.WGF_all.Addressbook['wg{}'.format(t)].index(Cycle)
        w *= self.WGF_all.Dic['wg{}'.format(t)][Address][1]
        
        return G, simplify(w)


    # calculating the average of a diagram over a RM.
    def Average(self,Graph,Weight,RM_ID):
        Average = []
        Perms = list(itertools.permutations(range(len(self.PRE.RM1_grouped[RM_ID]))))
        for pair in itertools.product(Perms,Perms):
            Ave_each = self.Reconnection(Graph,pair[0],pair[1],RM_ID)
            Weight_out = simplify(Weight * Ave_each[1])
            Average.append([Ave_each[0],Weight_out])  
        return Average
    
    
    # calculating the average over RMs selected.
    def Calculator(self):
        if self.PRE.RM_Number == 0: # case where no average calculation is made.
            return [[self.PRE.G, self.PRE.Weight]]
        else:
            pass
        G = copy.deepcopy(self.PRE.G)
        W = copy.deepcopy(self.PRE.Weight)
        GW_List = copy.deepcopy([[G,W]]) # the initial list.
        # averaging a list of graphs over each RM one by one.
        for num in range(self.PRE.RM_Number): 
            l = len(GW_List) # after first RM, the list may be longer than one.
            for i in range(l):
                GW_List += self.Average(GW_List[i][0],GW_List[i][1],num)
            del GW_List[:l]
        
        return GW_List
    
    
    
# drawing edges. 
def visualizeGraphList0(EW):
    Edges = EW[0]
    Weight = EW[1]
    # sorting edges first within each edge and then according to the first element.
    Edges_sorted = sorted([ sorted(x, key = lambda s: s[0]) for x in Edges],\
                           key = lambda t: t[0])
    #print(Edges_sorted)
    # making a list of new edges with nodes being matrices;
    #[new edge, label, concatinated nodes of new edge, original edge]; 
    Edges_labeled = [[[x[0][0]+str(x[0][1]), x[1][0]+str(x[1][1])] ,\
                      '[' + x[0][2]+str(x[0][3])+':'+ x[1][2]+str(x[1][3])+']' ,\
           x[0][0]+str(x[0][1]) +x[1][0]+str(x[1][1]) , x] for x in Edges_sorted]
    #print(Edges_labeled)
    
    
    
    # sorting wrt concatinated nodes of new edges.
    ### not sure if we really need this because it may not change anything.
    Edges_new = sorted(Edges_labeled, key = lambda t: t[2])
    #print(Edges_new)
    # if a node has @, we get the original name back, 
    #because we do not put @s' together... Endpoints are separated. 
    for x in Edges_new:
        for i in [0,1]: 
            if x[0][i][0] == '@': 
                x[0][i] += x[3][i][2] + str(x[3][i][3])
            else:
                pass
    #print(Edges_new)
    # adding technical nodes for drawing in case of self loops.     
    for x in Edges_new: 
        if x[0][0] == x[0][1]:
            x[0][0] += ' Loop'
        else:
            pass
    
    # putting double edges together by grouping only w.r.t. new edges of string-format.
    # [[new edge, [[connection],[connection],,,]...],]
    Compressed = [ [key, [a[1] for a in group]] for key, group in groupby(Edges_new, lambda x: x[0])]
    # making a new list of information for each edge because double-edges were compressed.
    # [[new edge, '[connection][connection]...'],]
    Compressed2 = []
    for x in Compressed:
        y = ''
        # finding out all connections between the same two matrices.
        for z in x[1]: 
            y += z
        Compressed2.append([x[0],y])
    
    # generating a directed graph from the above new edges and setting the color to be red.
    H = nx.DiGraph()
    for x in Compressed2:
        H.add_edge(x[0][0],x[0][1],name = x[1],color='r')
    # putting that color information into the list.
    Colors_Edges = [H[u][v]['color'] for u,v in H.edges()]
    
    # defining colors of nodes.
    Color_nodes = []
    for g in H:
        if g[-4:] == 'Loop': 
            Color_nodes.append('orange')
        else:
            Color_nodes.append('yellow')
    
    # drawing.
    pos = nx.circular_layout(H)
    nx.draw(H, pos,  with_labels = True, node_color = Color_nodes, edge_color=Colors_Edges)
    nx.draw_networkx_labels(H, pos)
    edge_labels = nx.get_edge_attributes(H,'name')
    nx.draw_networkx_edge_labels(H, pos, edge_labels)
    plt.show()
    print(Weight)

# making the drawing function polymorphic: accepting list of diagrams automatically.
def visualizeTN(EW):
    if isinstance(EW[-1], list):
        for ew in EW:
           visualizeGraphList0(ew)
    else:
        visualizeGraphList0(EW)
    
    
    
def integrateHaarUnitary(EWs, RM_List):
    


    # first, making this function polymorphic.
    if not isinstance(EWs[-1], list):
        EWs = [EWs]
    else:
        pass
    if RM_List == []:
        pass
    elif not isinstance(RM_List[-1], list):
        RM_List = [RM_List]
    else:
        pass

    ##### mathematica to python #####
    
    # making a dictionary for translations between Python and Mathematica codes.
    Dic_PyMa = {}
    Dic_PyMa["L"] = "out"
    Dic_PyMa["R"] = "in"
    Dic_PyMa["in"] = "R"
    Dic_PyMa["out"] = "L"
    
    # changing out-in format to L-R format, and changing numbering system to mathematica to python
    for x in EWs:
        for y in x[0]:
            for z in y:
                z[2] = Dic_PyMa[z[2]]
                z[3] -= 1
                
    # switching the order of L and R, in order to work like Mathematica package.
    RM_List = [[rm[0],rm[2],rm[1],rm[3]] for rm in RM_List]
    
    ##### up to here #####
    
    # making a collection of graphs and weights.
    Collections = []
    for x in EWs:
        Collections += Calc(x[0],x[1],RM_List).Output
    Collections_List = [ [list(c[0].edges()), c[1]] for c in Collections]
    #print(Collections_List)
    
    # making a dictionary to get the original form of input diagrams;
    # only for matrices left after the average, considering all graphs in Collections
    Node_Dic = {y: x[0].node[y]['original'] for x in Collections for y in list(x[0])}
    # finding which matrices are left after the average.
    Matrices = [x for x,y in groupby(sorted([Node_Dic[x][0:2] for x in Node_Dic]))]
    #print(Matrices)
    # checking what IDs each matrix has: [[Matrix,[ID1,ID2,...]],...]
    Matrices_IDs = [ [a,[ m[1] for m in Matrices if m[0] == a], len(list(b))] for a,b in groupby([x[0] for x in Matrices])]
    #print(Matrices_IDs)
    NofM = len(Matrices_IDs)
    Matrices_shuffled = [ [x[0], list(itertools.permutations(x[1])),x[2]] for x in Matrices_IDs]
    #print(Matrices_shuffled)
    

    
    # making the list of possible permutations, indexed.
    Possi = [math.factorial(x[2]) for x in Matrices_IDs]
    # making the lisf of combination of possible permutations, which was indexed.
    # [(permutation for the first, for the second,...),...]
    Combi = list(itertools.product(*[list(range(s)) for s in Possi]))
    #print(Combi)
    
    # making the dictionary {'c in Combi'+Matrix+'oldID':Matrix+'oldID'}
    Dic_full=\
    {str(c)+Matrices_shuffled[i][0]+str(Matrices_shuffled[i][1][0][j]):\
     Matrices_shuffled[i][0] + str(Matrices_shuffled[i][1][c[i]][j])\
     for c in Combi for i in range(NofM) for j in range(Matrices_shuffled[i][2])}
    #print(Dic_full)

    
    Ave0 = [[sorted([ sorted(e) for e in Collections_List[0][0]], key = lambda t: t[0] ),\
            Collections_List[0][1]]]
    LC = len(Collections_List)
    if LC == 1:
        Ave = Ave0
    else:
        Ave = Ave0
        #print(Ave)
        for gw in Collections_List[1:]:
            #print('gw',gw)
            Count1 = 0
            Candi = [[ [Dic_full[str(c)+e[0][0]+str(e[0][1])] + e[0][2:4],\
                    Dic_full[str(c)+e[1][0]+str(e[1][1])] + e[1][2:4]]\
                    for e in gw[0]] for c in Combi]
            #print(Candi)
            for c in Candi:
                Count2 = 0
                for a in Ave:
                    if a[0] == sorted([sorted(d) for d in c], key = lambda t: t[0] ):
                        a[1] += gw[1]
                        Count2 +=1
                        break
                    else:
                        pass
                if Count2 == 1:
                    Count1 +=1
                    break
                else:
                    pass
            if Count1 == 0:
                g_sorted = sorted([sorted(e) for e in gw[0]],key = lambda t: t[0]) 
                Ave.append([g_sorted,gw[1]])
            else:
                pass
    
    #print('a',Ave)
    Ave_tidy = [[x[0],simplify(x[1])] for x in Ave]
    
    
    # making the graph data into list data. (EW = Edges and weight)
    Ave_List = [[[ [Node_Dic[x[0]],Node_Dic[x[1]]] for x in X[0] ] ,X[1]]  for X in Ave_tidy]
    
    ##### python to mathematica #####
    
    # changing L-R format to out-in format, and changing numbering system from python to mathematica
    for x in Ave_List:
        for y in x[0]:
            for z in y:
                z[2] = Dic_PyMa[z[2]]
                z[3] += 1
                
    ##### up to here #####
    
    return Ave_List   


























"""

"""