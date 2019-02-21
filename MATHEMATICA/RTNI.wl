(* ::Package:: *)

BeginPackage["RTNI`"];
Unprotect@@Names["RTNI`*"]
Clear@@Names["RTNI`*"]

(*Variable[text_?StringQ]:= "\!\(\*StyleBox[\""<>text<>"\", \"TI\"]\)"
Variable[a_,b__]:=Variable[a]<>","<>Variable[b]
 
Func[text_?StringQ]:= "\!\(\*StyleBox[\""<>text<>"\", \"Input\"]\)"
Func[a_,b__]:=Func[a]<>","<>Func[b]
*)



RTNIDOIToString[text_,doi_]:="\!\(\*ButtonBox[StyleBox[\""<>text<>"\", \"SR\"],Active->True,BaseStyle->\"Link\",ButtonData->\"http://dx.doi.org/"<>doi<>"\"]\)";
RTNIciteCollins06 = RTNIDOIToString["[Collins&\:015aniady 2006]","10.1007/s00220-006-1554-3"];
RTNIciteBernstein04 = RTNIDOIToString["[Bernstein 2004]","10.1016/j.jsc.2003.11.001"];
RTNIDocumentationReplacements = {"<v>" -> "\!\(\*StyleBox[\"" , "</v>" -> "\", \"TI\"]\)", "<f>"->"\!\(\*StyleBox[\"", "</f>" -> "\", \"Input\"]\)"};



(* ::Section:: *)
(*Help messages*)


integrateHaarUnitary::usage = StringReplace[
"<f>integrateHaarUnitary</f>[<v>g</v>,<v>symbU</v>,<v>dimsI</v>,<v>dimsO</v>,<v>totalDim</v>,{<v>debug:False</v>}] \
computes the Haar average of a graph. Accepts the following arguments: 
-<v>g</v> - a graph. This is a list of edges. An edge is an unordered pair of 2 labels. A label has the following elements\[IndentingNewLine]1- a string, corresponding to a box symbol\[IndentingNewLine]2- an ID, identifying which box with the given symbol the label is attached to\[IndentingNewLine]3- an integer, sepcifying whether the label is an input (0) or an output (1)\[IndentingNewLine]4- an integer, specifying an ID for the label, as an input/output
-<v>symbU</v> the symbol of variable for integration,   
-<v>dimsI</v> input dimensions,
-<v>dimsO</v> outut dimensions,
-<v>totalDim</v> the total dimensions (of the unitary).",RTNIDocumentationReplacements]

visualizeTN::usage = StringReplace[
"<f>visualizeTN</f>[<v>g</v>] 
Visualizes the tensor network/superposition of tensor networks g",RTNIDocumentationReplacements]

cloneGraph::usage = StringReplace[
"<f>cloneGraph</f>[<v>g</v>,<v>k</v>] 
Creates k copies of the graph g",RTNIDocumentationReplacements]

Wg::usage = StringReplace[
"<f>Wg</f>[<v>d</v>,<v>p</v>] 
Computes the Weingarten function for dimension d and partition p",RTNIDocumentationReplacements]

isomorphicGraphs::usage = StringReplace[
"<f>Wg</f>[<v>d</v>,<v>p</v>] 
Computes the Weingarten function for dimension d and partition p",RTNIDocumentationReplacements]


producemonomialgraph::usage = StringReplace[
"<f>producemonomialgraph</f>[<v>eps</v>] 
Outputs a graph representing a monomial",RTNIDocumentationReplacements]

Producemultinomialexpression::usage = StringReplace[
"<f>Producemultinomialexpression</f>[<v>eps</v>] 
Outputs a bitstring representing the expression specified by the tuple eps",RTNIDocumentationReplacements]

converttomonomial::usage = StringReplace[
"<f>converttomonomial</f>[<v>g</v>,<v>TakeTrace</v>]
Converts a graph into a readable expression. Takes as arguments
-<v>g</v> - a graph
-<v>TakeTrace</v> - a Boolean value, indicating whether the trace should be taken.
Assumes the graph consists of a linegraph with \!\(\*SubscriptBox[\(X\), \(1\)]\) on the left and a collection of cycles",RTNIDocumentationReplacements]


MultinomialexpectationvalueHaar::usage = StringReplace[
"<f>MultinomialexpectationvalueHaar</f>[<v>d</v>,<v>eps</v>,<v>Xvars</v>{<v>usetrace:False</v>}] \
computes the Haar average of a multinomial of the form \!\(\*SubscriptBox[\(X\), \(1\)]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"U\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"^\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"{\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[SubscriptBox[\"eps\", \"1\"],\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"}\",\nFontColor->GrayLevel[0]]\)\!\(\*SubscriptBox[\(X\), \(2\)]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"U\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"^\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"{\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[SubscriptBox[\"eps\", \"2\"],\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"}\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"\\\\\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"cdots\",\nFontColor->GrayLevel[0]]\) \!\(\*SubscriptBox[\(X\), \(2  q\)]\)\!\(\*
StyleBox[\"U\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"^\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"{\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[SubscriptBox[\"eps\", 
RowBox[{\"2\", \"q\"}]],\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"}\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\".\",\nFontColor->GrayLevel[0]]\)
Accepts the following arguments: 
-<v>d</v> the dimension of the unitary group (can be a symbolic expression).
-<v>eps</v> an array eps=(\!\(\*SubscriptBox[\(eps\), \(1\)]\),...,\!\(\*SubscriptBox[\(eps\), \(2  q\)]\))\n \{1,2,3,4\}^{2q}.
Here 
 \!\(\*
StyleBox[SubscriptBox[\"eps\", \"j\"],\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"=\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"1\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"corresponds\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"to\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"the\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"unitary\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"U\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\",\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"\[IndentingNewLine]\",\nFontColor->RGBColor[1, 0, 0]]\)\!\(\*
StyleBox[\" \",\nFontColor->RGBColor[1, 0, 0]]\)e\!\(\*SubscriptBox[
StyleBox[\"ps\",\nFontColor->GrayLevel[0]], \(j\)]\)\!\(\*
StyleBox[\"=\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"2\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"corresponds\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"to\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"the\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"adjoint\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"unitary\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"U\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"^\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"*\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"\[IndentingNewLine]\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[SubscriptBox[\"eps\", \"j\"],\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"=\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"3\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"corresponds\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"to\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"the\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"transpose\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"unitary\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"U\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"^\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"T\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"\[IndentingNewLine]\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[SubscriptBox[\"eps\", \"j\"],\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"=\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"4\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"corresponds\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"to\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"the\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"complex\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"conjugate\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"unitary\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\" \",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"\\\\\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"bar\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"{\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"U\",\nFontColor->GrayLevel[0]]\)\!\(\*
StyleBox[\"}\",\nFontColor->GrayLevel[0]]\)
-<v>Xvar</v> an array of variables
-<v>usetrace</v> a boolean value indicating whether the trace should be taken
",RTNIDocumentationReplacements]





(* ::Section:: *)
(*Private definitions*)


Begin["`Private`"];
WeingartenList={}; (* package loads a list of precomputed Weingarten functions into this variable *)
DEBUG = False;
OPT = True;




RTNIAuthors = "Motohisa Fukuda <motohisa|dot|fukuda[at]gmail[dot]com>, Robert Koenig <robert|dot|koenig[at]tum[dot]de>, Ion Nechita <ion|dot|nechita[at]gmail[dot]com>";
RTNILicense = "GPLv3 <http://www.gnu.org/licenses/gpl.html>";
RTNIHistory = {
	{"1.0.0", "10/06/2018", "Koenig", "First Version"},
	{"1.0.1", "25/12/2018", "Nechita", ""},
	{"1.0.2", "29/12/2018", "Nechita", "added cloneGraph function"},
	{"1.0.3", "10/01/2019", "Koenig", "0/1 -> in/out"},
	{"1.0.4", "23/01/2019", "Nechita", "Wg public, input for Wg = partition (instead of permutation)"},
	{"1.0.5", "26/01/2019", "Nechita", "isomoprhicGraphs does not discard the IDs anymore. The output of the main integration function might report the same graph several times"}
	
};
RTNIVersion = Last[RTNIHistory][[1]];
RTNILastModification = Last[RTNIHistory][[2]];
RTNIAbout = " ... ";



readWeingartenfcts[m_]:=Module[{filename="",s="",convertedexpr,k},
(* reads all weingarten function up to size m, these are added to the private variable WeingartenList *)
For[k=1,k<=m,k++,
filename=FileNameJoin[{NotebookDirectory[],"precomputedWG","functions"<>ToString[k]<>".txt"}];
If[FileExistsQ[filename],
Print["Loading precomputed Weingarten Functions from ","/precomputedWG/functions"<>ToString[k]<>".txt"];
s=ReadString[filename];
convertedexpr=ToExpression["Weing="<>StringReplace[s,{"**"->"^","]"->"}","["->"{"}]];
RTNI`Private`WeingartenList=AppendTo[RTNI`Private`WeingartenList,convertedexpr]
];
If[!FileExistsQ[filename],RTNI`Private`WeingartenList=AppendTo[RTNI`Private`WeingartenList,{}]];
 ];];




(* ::Subsection:: *)
(*Weingarten function*)


Wg[d_,sigma_]:=Module[{r=Total[sigma], wgsublist,returnvalue=0,idx},wgsublist=RTNI`Private`WeingartenList[[r]];
idx=Position[wgsublist[[All, 1]],Reverse[Sort[sigma]]];
If[idx=={},Print["Weingarten function called with ",d," and ", sigma, " Either ill-defined, or not precomputed yet."], returnvalue=wgsublist[[idx[[1,1]]]][[2]]/.{RTNI`Private`n->d};];
returnvalue
];



(* ::Subsection:: *)
(*Main integration routines*)


integrateHaarUnitary[g_,symbU_,dimsI_,dimsO_,totalDim_,debug_:False]:=Module[{gList,idxG,wi,gi,newG,listIDU,listIDUStar,i,e,vSymb,v,vID,p,perms,i\[Alpha],i\[Beta],\[Alpha],\[Beta],g\[Alpha]\[Beta],w\[Alpha]\[Beta],stop,posU,vU,vUStar,vOtherU,idxU,listVOtherUStar,posUStar,found,danglingList,j,x,y},
(* check if the input parameter g is just a graph; if YES, then make it a list of graphs, with weight 1 *)
If[Length[Dimensions[g]]==3,gList={{g,1}},gList=g];
If[debug,Print["STARTING with gList=",gList]];

newG={};(* the list of graphs obtained after integrating out U*)

For[idxG=1,idxG<=Dimensions[gList][[1]],idxG++,
(* gi is the current graph we're processing, with weight wi *)
gi=gList[[idxG,1]];
wi=gList[[idxG,2]];

listIDU={};
listIDUStar={};
If[debug,Print["gi=",gi]];
For[i=1,i<=Dimensions[gi][[1]],i++,
e=gi[[i]];
v=e[[1]];
vSymb=v[[1]];
vID=v[[2]];
If[vSymb==symbU,If[Position[listIDU,vID]=={},AppendTo[listIDU,vID]]];
If[vSymb==(symbU<>"*"),If[Position[listIDUStar,vID]=={},AppendTo[listIDUStar,vID]]];
v=e[[2]];
vSymb=v[[1]];
vID=v[[2]];
If[vSymb==symbU,If[Position[listIDU,vID]=={},AppendTo[listIDU,vID]]];
If[vSymb==(symbU<>"*"),If[Position[listIDUStar,vID]=={},AppendTo[listIDUStar,vID]]];
];
If[debug,Print["listIDU=",listIDU,"  listIDUStar=",listIDUStar]];
If[Length[listIDU]!=Length[listIDUStar],
If[debug,Print["Not the same number of "<>symbU<>" and "<>symbU<>"*, so the expectation vlaue is null."]];
Return[{}];
];

(* compue number of symbols U/U* *)
p=Length[listIDU];

(* add dummy vertices to the dangling edges of the unitary boxes *)
For[i=1,i<=p,i++,
(* check if the inputs of U boxes have dangling edges *)
danglingList=ConstantArray[True,{p,Length[dimsI]}];
For[j=1,j<=Dimensions[gi][[1]],j++,
For[v=1,v<=2,v++,
If[gi[[j,v,1]]==symbU&&gi[[j,v,3]]=="in",danglingList[[Position[listIDU,gi[[j,v,2]]][[1,1]],gi[[j,v,4]]]]=False];
];
];
If[debug,Print["U-IN danglingList=",danglingList//MatrixForm]];
(* add the dummy vertices *)
For[x=1,x<=p,x++,
For[y=1,y<=Length[dimsI],y++,
If[danglingList[[x,y]],
AppendTo[gi,{{"dummy-"<>symbU<>"-IN-"<>ToString[listIDU[[x]]]<>"-"<>ToString[y],1,"out",1},{symbU,listIDU[[x]],"in",y}}];
];
];
];

(* check if the outputs of U boxes have dangling edges *)
danglingList=ConstantArray[True,{p,Length[dimsO]}];
For[j=1,j<=Dimensions[gi][[1]],j++,
For[v=1,v<=2,v++,
If[gi[[j,v,1]]==symbU&&gi[[j,v,3]]=="out",danglingList[[Position[listIDU,gi[[j,v,2]]][[1,1]],gi[[j,v,4]]]]=False];
];
];
If[debug,Print["U-OUT danglingList=",danglingList//MatrixForm]];
(* add the dummy vertices *)
For[x=1,x<=p,x++,
For[y=1,y<=Length[dimsO],y++,
If[danglingList[[x,y]],
AppendTo[gi,{{symbU,listIDU[[x]],"out",y},{"dummy-"<>symbU<>"-OUT-"<>ToString[listIDU[[x]]]<>"-"<>ToString[y],1,"in",1}}];
];
];
];

(* check if the inputs of U* boxes have dangling edges *)
(* careful here: the inputs of U* correspond to the outputs of U, so the dimensions list has to be chosen appropriately *)
danglingList=ConstantArray[True,{p,Length[dimsO]}];
For[j=1,j<=Dimensions[gi][[1]],j++,
For[v=1,v<=2,v++,
If[gi[[j,v,1]]==symbU<>"*"&&gi[[j,v,3]]=="in",danglingList[[Position[listIDUStar,gi[[j,v,2]]][[1,1]],gi[[j,v,4]]]]=False];
];
];
If[debug,Print["U*-IN danglingList=",danglingList//MatrixForm]];
(* add the dummy vertices *)
For[x=1,x<=p,x++,
For[y=1,y<=Length[dimsO],y++,
If[danglingList[[x,y]],
AppendTo[gi,{{"dummy-"<>symbU<>"*-IN-"<>ToString[listIDUStar[[x]]]<>"-"<>ToString[y],1,"out",1},{symbU<>"*",listIDUStar[[x]],"in",y}}];
];
];
];

(* check if the outputs of U* boxes have dangling edges *)
(* careful here: the inputs of U* correspond to the outputs of U, so the dimensions list has to be chosen appropriately *)
danglingList=ConstantArray[True,{p,Length[dimsI]}];
For[j=1,j<=Dimensions[gi][[1]],j++,
For[v=1,v<=2,v++,
If[gi[[j,v,1]]==symbU<>"*"&&gi[[j,v,3]]=="out",danglingList[[Position[listIDUStar,gi[[j,v,2]]][[1,1]],gi[[j,v,4]]]]=False];
];
];
If[debug,Print["U*-OUT danglingList=",danglingList//MatrixForm]];
(* add the dummy vertices *)
For[x=1,x<=p,x++,
For[y=1,y<=Length[dimsI],y++,
If[danglingList[[x,y]],
AppendTo[gi,{{symbU<>"*",listIDUStar[[x]],"out",y},{"dummy-"<>symbU<>"*-OUT-"<>ToString[listIDUStar[[x]]]<>"-"<>ToString[y],1,"in",1}}];
];
];
];
];
If[debug,Print["AFTER ADDING DUMMY VERTICES gi=",gi]];

(* run a loop over all pairs of permutations to perform the Weingarten integration *)
perms=Permutations[Range[p]];
For[i\[Alpha]=1,i\[Alpha]<=Factorial[p],i\[Alpha]++,
For[i\[Beta]=1,i\[Beta]<=Factorial[p],i\[Beta]++,
(* the permutation \[Alpha] is responsible for connecting the inputs of the Us with the outputs of U*s *) 
\[Alpha]=perms[[i\[Alpha]]];
(* the permutation \[Beta] is responsible for connecting the outputs of the Us with the inputs of U*s *) 
\[Beta]=perms[[i\[Beta]]];
(* the new graph and its Wg weight; do not forget that we need to take into account the initial weight wi of the graph gi *)
g\[Alpha]\[Beta]=gi;
w\[Alpha]\[Beta]=wi*Wg[totalDim,Map[Length,PermutationCycles[PermutationProduct[\[Alpha],InversePermutation[\[Beta]]],Identity]]]//Simplify;
(* first, remove all edges connecting to inputs of U boxes, using \[Alpha] to connect *)
stop=False;
While[!stop,
stop=True;
posU={0,0};
(* looking for inputs of U boxes *)
For[i=1,i<=Length[g\[Alpha]\[Beta]]&&posU=={0,0},i++,
If[g\[Alpha]\[Beta][[i,1,1]]==symbU&&g\[Alpha]\[Beta][[i,1,3]]=="in",posU={i,1},
If[g\[Alpha]\[Beta][[i,2,1]]==symbU&&g\[Alpha]\[Beta][[i,2,3]]=="in",posU={i,2}]];
];
If[debug,Print["posU=",posU]];
If[posU!={0,0},
stop=False;
vU=g\[Alpha]\[Beta][[posU[[1]],posU[[2]]]];
vOtherU=g\[Alpha]\[Beta][[posU[[1]],3-posU[[2]]]];
If[debug,Print["vOtherU=",vOtherU]];
vUStar=vU;
vUStar[[1]]=symbU<>"*";
idxU=Position[listIDU,vU[[2]]][[1,1]];
vUStar[[2]]=listIDUStar[[\[Alpha][[idxU]]]];
vUStar[[3]]="out";
listVOtherUStar={};
posUStar={};
For[i=1,i<=Length[g\[Alpha]\[Beta]],i++,
If[g\[Alpha]\[Beta][[i,1]]==vUStar,AppendTo[listVOtherUStar,g\[Alpha]\[Beta][[i,2]]];AppendTo[posUStar,{i}]];
If[g\[Alpha]\[Beta][[i,2]]==vUStar,AppendTo[listVOtherUStar,g\[Alpha]\[Beta][[i,1]]];AppendTo[posUStar,{i}]];
];
If[debug,Print["listVOtherUStar=",listVOtherUStar]];
If[debug,Print["BEFORE DELETING g\[Alpha]\[Beta]=",g\[Alpha]\[Beta]]];
g\[Alpha]\[Beta]=Delete[g\[Alpha]\[Beta],AppendTo[posUStar,{posU[[1]]}]];
If[debug,Print["AFTER DELETING g\[Alpha]\[Beta]=",g\[Alpha]\[Beta]]];
For[i=1,i<=Dimensions[listVOtherUStar][[1]],i++,
If[vU!=listVOtherUStar[[i]],AppendTo[g\[Alpha]\[Beta],{vOtherU,listVOtherUStar[[i]]}],w\[Alpha]\[Beta]=w\[Alpha]\[Beta]*dimsI[[vU[[4]]]]];
];
If[debug,Print["AFTER ADDING g\[Alpha]\[Beta]=",g\[Alpha]\[Beta]]];
];
];
(* then, remove all edges connecting to outputs of U boxes, same code as before, use \[Beta] *)
stop=False;
While[!stop,
stop=True;
posU={0,0};
(* looking for outputs of U boxes *)
For[i=1,i<=Length[g\[Alpha]\[Beta]]&&posU=={0,0},i++,
If[g\[Alpha]\[Beta][[i,1,1]]==symbU&&g\[Alpha]\[Beta][[i,1,3]]=="out",posU={i,1},
If[g\[Alpha]\[Beta][[i,2,1]]==symbU&&g\[Alpha]\[Beta][[i,2,3]]=="out",posU={i,2}]];
];
If[debug,Print["posU=",posU]];
If[posU!={0,0},
stop=False;
vU=g\[Alpha]\[Beta][[posU[[1]],posU[[2]]]];
vOtherU=g\[Alpha]\[Beta][[posU[[1]],3-posU[[2]]]];
If[debug,Print["vOtherU=",vOtherU]];
vUStar=vU;
vUStar[[1]]=symbU<>"*";
idxU=Position[listIDU,vU[[2]]][[1,1]];
vUStar[[2]]=listIDUStar[[\[Beta][[idxU]]]];
vUStar[[3]]="in";
listVOtherUStar={};
posUStar={};
For[i=1,i<=Length[g\[Alpha]\[Beta]],i++,
If[g\[Alpha]\[Beta][[i,1]]==vUStar,AppendTo[listVOtherUStar,g\[Alpha]\[Beta][[i,2]]];AppendTo[posUStar,{i}]];
If[g\[Alpha]\[Beta][[i,2]]==vUStar,AppendTo[listVOtherUStar,g\[Alpha]\[Beta][[i,1]]];AppendTo[posUStar,{i}]];
];
If[debug,Print["listVOtherUStar=",listVOtherUStar]];
If[debug,Print["BEFORE DELETING g\[Alpha]\[Beta]=",g\[Alpha]\[Beta]]];
g\[Alpha]\[Beta]=Delete[g\[Alpha]\[Beta],AppendTo[posUStar,{posU[[1]]}]];
If[debug,Print["AFTER DELETING g\[Alpha]\[Beta]=",g\[Alpha]\[Beta]]];
For[i=1,i<=Dimensions[listVOtherUStar][[1]],i++,
If[vU!=listVOtherUStar[[i]],AppendTo[g\[Alpha]\[Beta],{vOtherU,listVOtherUStar[[i]]}],w\[Alpha]\[Beta]=w\[Alpha]\[Beta]*dimsO[[vU[[4]]]]];
];
If[debug,Print["AFTER ADDING g\[Alpha]\[Beta]=",g\[Alpha]\[Beta]]];
];
];
(* check if we already encountered this graph
if YES, then update its weight
if NO, then add the new graph to the expansion, with the Wg weight coefficient *)
If[debug,Print[visualizeTN[g\[Alpha]\[Beta]]]];
found=0;
For[i=1,i<=Dimensions[newG][[1]]&&found==0,i++,If[isomorphicGraphs[g\[Alpha]\[Beta],newG[[i,1]],debug],found=i]];
If[found==0,
AppendTo[newG,{g\[Alpha]\[Beta],w\[Alpha]\[Beta]}];
If[debug,Print["Graph added"]];
,
newG[[found,2]]=newG[[found,2]]+w\[Alpha]\[Beta];
If[debug,Print["Weight updated: ",newG[[found,2]]]];
];
If[debug,Print["Dimensions[newG] = ",Dimensions[newG]]];
]]];
newG
];
deleteIDFromGraph[g_]:=Module[{h,i},
(* set all the IDs of vertices in g to -1 *)
h=g;
For[i=1,i<=Dimensions[g][[1]],i++,
h[[i,1,2]]=-1;
h[[i,2,2]]=-1;
];
h
];
orderlessSameQ[a_List,b_List]:=(Length@a==Length@b)&&(Sort@Tally@a===Sort@Tally@b);
isomorphicGraphs[g1_,g2_,debug_:False]:=Module[{result,noIDg1,noIDg2},
If[debug,Print["ISO graphs called with ",visualizeTN[g1],visualizeTN[g2]]];
If[debug,Print[g1]];
If[debug,Print[g2]];
(*noIDg1=deleteIDFromGraph[g1];
noIDg2=deleteIDFromGraph[g2];
If[debug,Print[noIDg1]];
If[debug,Print[noIDg2]];
result=orderlessSameQ[noIDg1,noIDg2];*)
result=orderlessSameQ[g1,g2];
If[debug,Print[result]];
result
];
raiseStar[s_]:=Module[{n},
n=StringLength[s];
If[StringTake[s,-1]=="*",Superscript[StringTake[s,{1,n-1}],"*"],s]
];
cloneGraph[g_,k_,debug_:False]:=Module[{h,i,j,newg,maxID,LR,r},
maxID={};
For[i=1,i<=Dimensions[g][[1]],i++,
For[LR=1,LR<=2,LR++,
j=Position[maxID[[;;,1]],g[[i,LR,1]]];
If[Length[j]==0,
AppendTo[maxID,{g[[i,LR,1]],g[[i,LR,2]]}];
,
j=j[[1,1]];
maxID[[j,2]]=Max[maxID[[j,2]],g[[i,LR,2]]];
];
If[debug,Print[maxID]];
]];
h=g;
For[r=1,r<=k-1,r++,
newg=g;
For[i=1,i<=Dimensions[g][[1]],i++,
For[LR=1,LR<=2,LR++,
j=Position[maxID[[;;,1]],newg[[i,LR,1]]];
j=j[[1,1]];
newg[[i,LR,2]]+=r*maxID[[j,2]];
]];
h=Join[h,newg];
];
h
];


(* ::Subsection:: *)
(*Graph visualization routines*)


IsDummyVertex[vertexname_]:=StringContainsQ[ToString[vertexname],"dummy"~~__~~""];


visualizeGraph[g_,plotarguments_:{EdgeLabeling->False}]:=Module[{v,e,edges,i,vSymb,vID,vName,p1,p2,vertLabels,edgeLabels},
vertLabels={};
edges={};
edgeLabels={};
For[i=1,i<=Length[g],i++,
e=g[[i]];
v=e[[1]];
vSymb=v[[1]];
vID=v[[2]];
vName=Subscript[raiseStar[vSymb],ToString[vID]];
If[Position[vertLabels,vName]=={},AppendTo[vertLabels,vName]];
p1=Position[vertLabels,vName][[1,1]];
v=e[[2]];
vSymb=v[[1]];
vID=v[[2]];
vName=Subscript[raiseStar[vSymb],ToString[vID]];
If[Position[vertLabels,vName]=={},AppendTo[vertLabels,vName]];
p2=Position[vertLabels,vName][[1,1]];
AppendTo[edges,{p1,p2}];
strlabela="\!\(\*SubscriptBox[\("<>If[e[[1,3]]=="in","i","o"]<>"\), \("<>ToString[e[[1,4]]]<>"\)]\)";
strlabelb="\!\(\*SubscriptBox[\("<>If[e[[2,3]]=="in","i","o"]<>"\), \("<>ToString[e[[2,4]]]<>"\)]\)";
AppendTo[edgeLabels,strlabela<>"\[RightArrow]"<>strlabelb];
];
myg=Table[{vertLabels[[edges[[i,1]]]]->vertLabels[[edges[[i,2]]]],edgeLabels[[i]]},{i,1,Length[edgeLabels]}];
GraphPlot[myg,Append[{plotarguments},DirectedEdges->EdgeLabeling/.plotarguments]]/.Tooltip[Point[n_Integer],label_]:>{Black,AbsoluteThickness[2],Circle[n,0.06],If[IsDummyVertex[label],{LightGray,Disk[n,0.06]},{Yellow,Disk[n,0.06]}],
If[!IsDummyVertex[label],Text[label,n],{}]
}
];


visualizeGraphExpansion[g_,plotarguments_:{EdgeLabeling->False}]:=Module[{list,i},
list={};
For[i=1,i<=Dimensions[g][[1]],i++,
AppendTo[list,{visualizeGraph[g[[i,1]],plotarguments],g[[i,2]]}];
];
list
];


(* check if we are dealing with a single tensor network *)
isGraph[g_]:=Module[{result=True,j},
For[j=1,j<=Length[g],j++,If[Length[g[[j]]]!=2,result=False]]; (* check that each entry is an edge *)
If[result,For[j=1,j<=Length[g],j++,If[Length[g[[j]][[1]]]!=4,result=False]];]; (* check that each entry of an edge is a vertex *)
If[result,For[j=1,j<=Length[g],j++,If[Length[g[[j]][[2]]]!=4,result=False]];];
result
];



(* main routine for visualization: visualizes both individual tensor networks as well as linear combinations *)
visualizeTN[g_,plotarguments_:{EdgeLabeling->False}]:=Module[{result=0},
If[isGraph[g],result=visualizeGraph[g,plotarguments],result=visualizeGraphExpansion[g,plotarguments]];
result
];









(* ::Subsection:: *)
(*Functions for integration of monomials*)


producemonomialgraph[eps_]:=Module[{q,retvalue},
q=Length[eps];
retvalue={};
If[Mod[q,2]==1,Return[0]]; (* gives zero for odd number of unitaries. perhaps this is not necessary: the rest of the code takes care of this. *)
For[j=1, j <=q, j++, 
(*vname=ToString[Subscript["X",ToString[j]],StandardForm];  connect input of Subscript[X, j] to output of U^{\eps_j} *)
vname=ToString[j];
vnode=1;
vattachment="in"; (* input of node Subscript[X, j] *)
wname="U";
wnode=j; (* jth operator U *)
If[MemberQ[{2,4},eps[[j]]],wname="U*"]; (* for U^* and \bar{U} need to use U^*)
wattachment="out"; (*output of node Subscript[U, j] *)
If[MemberQ[{3,4},eps[[j]]],wattachment="in"]; (* for U^T and \bar{U}, need to switch output and input *)
retvalue=Append[retvalue,{{vname,vnode,vattachment,1},{wname,wnode,wattachment,1}}];
]; 
For[j=1, j <=q, j++, (* for now, go up to q instead of q-1: creates dummy, avoids dangling edge *)
wattachment="out";(* connect input of U^{\eps_j} to output of Subscript[X, j+1] *)
wname="U";
wnode=j; (* jth operator U *)
wattachment="in"; (* input *)
If[MemberQ[{2,4},eps[[j]]],wname="U*"]; (* for U^* and \bar{U} need to use U^*)
If[MemberQ[{3,4},eps[[j]]],wattachment="out"]; (* for U^T and \bar{U}, need to switch output and input *)
(*vname=ToString[Subscript["X",ToString[j+1]],StandardForm];*)
vname=ToString[j+1];
If[j==q,vname="Z"];
vnode=1;
vattachment="out"; (* output of node Subscript[X, j+1] *)
retvalue=Append[retvalue,{{wname,wnode,wattachment,1},{vname,vnode,vattachment,1}}];
]; 
Return[retvalue];
];
(* makes two vertices comparable *)
converttocompare[v_]:={ToString[v[[1]]],v[[2]],v[[3]],v[[4]]};

(* makes two edges comparable *)
converttocompareedge[edge_]:={converttocompare[edge[[1]]],converttocompare[edge[[2]]]};



(* finds the neighbor w of vertex v in the graph g. Here w is assumed to be unique *)
(* returns 0 if no neighbor is found *)
findneighbor[g_,v_]:=Module[{q,vs},
q=Length[g];
vs=converttocompare[v];
For[j=1,j<=q,j++,
If [converttocompare[g[[j]][[1]]]==vs,Return[g[[j]][[2]]]];
If [converttocompare[g[[j]][[2]]]==vs,Return[g[[j]][[1]]]]
];
Return[0];
];

(* CONVERTS a graph into a readable expression. Assumes the graph consists of a linegraph with Subscript[X, 1] on the left and a collection of cycles *)
converttomonomial[g_,Xvars_,TakeTrace_]:=Module[{w,v,gnew=g,retvalue=Xvars[[1]],initialvertex,initialvertexinput,initialvertexoutput,cycleprod},
v={"1",1,"in",1}; (* start with the input to vertex 1 and traverse graph *)
w=findneighbor[g,v];
While[Length[w]>0, (* we have found a neighbor *)
If[w[[1]]!="Z",If[w[[3]]=="out",retvalue=retvalue.Xvars[[ToExpression[w[[1]]]]],retvalue=retvalue.Transpose[Xvars[[ToExpression[w[[1]]]]]]]]; (* transpose if input is attached to input *)
gnew=Select[gnew,converttocompareedge[#]!=converttocompareedge[{v,w}] &];
gnew=Select[gnew,converttocompareedge[#]!=converttocompareedge[{w,v}] &];
(*v={w[[1]],w[[2]],1-w[[3]],w[[4]]}; *)
v=If[w[[3]]=="out",{w[[1]],w[[2]],"in",w[[4]]},{w[[1]],w[[2]],"out",w[[4]]}];
(* go to output respectively input  and look for next neighbor *)
w=findneighbor[gnew,v];
];
(* at this point, we have taken care of the line graph contained in g *)
(*Print["Line graph contribution is "];
Print[retvalue]; 
Print["current graph "];
Print[gnew];*)
If[TakeTrace,retvalue=Tr[retvalue]];
(* NOW GO THROUGH ALL CYCLES *)
While[Length[gnew]>0,
 initialvertex=gnew[[1]][[1]];(* start the vertex on the first edge*)
initialvertexoutput={initialvertex[[1]],initialvertex[[2]],"out",initialvertex[[4]]};
initialvertexinput={initialvertex[[1]],initialvertex[[2]],"in",initialvertex[[4]]};
cycleprod=1;
If[initialvertexoutput[[1]]!="Z",cycleprod=Xvars[[ToExpression[initialvertexoutput[[1]]]]]];
v=initialvertexoutput; (* start at the output of the initial vertex *)
w=findneighbor[gnew,v]; (* now traverse the cycle *)
While[converttocompare[w]!=converttocompare[initialvertexinput], (* we have found a neighbor and haven't come back to the start of the cycle*)
If[w[[1]]!="Z",If[w[[3]]=="in",cycleprod=Xvars[[ToExpression[w[[1]]]]].cycleprod,cycleprod=Transpose[Xvars[[ToExpression[w[[1]]]]]].cycleprod]]; (* transpose if input is attached to input *)
gnew=Select[gnew,converttocompareedge[#]!=converttocompareedge[{v,w}] &];
gnew=Select[gnew,converttocompareedge[#]!=converttocompareedge[{w,v}] &];
(*v={w[[1]],w[[2]],1-w[[3]],w[[4]]}; *)
v=If[w[[3]]=="out",{w[[1]],w[[2]],"in",w[[4]]},{w[[1]],w[[2]],"out",w[[4]]}];
(* go to output respectively input  and look for next neighbor *)
w=findneighbor[gnew,v];
];
retvalue=Tr[cycleprod]*retvalue;
gnew=Select[gnew,converttocompareedge[#]!=converttocompareedge[{v,w}] &];
gnew=Select[gnew,converttocompareedge[#]!=converttocompareedge[{w,v}] &];
];
Return[retvalue];
];


MultinomialexpectationvalueHaar[d_,eps_,Xvars_,usetrace_]:=Module[{retvalue=0,g,m},
g=producemonomialgraph[eps];
m=integrateHaarUnitary[g,"U",{d},{d},d,False];
retvalue=Sum[m[[jidx]][[2]]*converttomonomial[m[[jidx]][[1]],Xvars,usetrace],{jidx,1,Length[m]}];
Return[retvalue];
];


(* produces human readable expression for {eps1,\ldots,eps_{2q} as above*)
Ueps[eps_]:=Which[eps==1,"U",eps==2,"\!\(\*SuperscriptBox[\(U\), \(*\)]\)",eps==3,"\!\(\*SuperscriptBox[\(U\), \(T\)]\)",eps==4,"\!\(\*OverscriptBox[\(U\), \(_\)]\)"];

Producemultinomialexpression[eps_]:=Module[{q},
q=Length[eps];
If[Mod[q,2]==1,Return[0]];
retvalue=Subscript["X", 1].Ueps[eps[[1]]];
For[j=2, j <=q, j++, retvalue=retvalue.Subscript["X", j].Ueps[eps[[j]]]; ];
Return[retvalue];
];



(* ::Section:: *)
(*Package footer*)


Print["Package RTNI (Random Tensor Network Integrator) version ", RTNI`Private`RTNIVersion, " (last modification: ", RTNI`Private`RTNILastModification, ")."];
readWeingartenfcts[30]; (* read weingarten functions; attempt to read up to n=30*)
End[]; (* private *)
Protect@@Names["RTNI`*"]
EndPackage[];














(* ::InheritFromParent:: *)
(*{"cloneGraph","converttomonomial","doi","RTNIciteBernstein04","RTNIciteCollins06","RTNIDocumentationReplacements","RTNIDOIToString","integrateHaarUnitary","MultinomialexpectationvalueHaar","producemonomialgraph","Producemultinomialexpression","text","visualizeGraph","visualizeGraphExpansion"}*)
