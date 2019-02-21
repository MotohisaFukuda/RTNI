# RTNI - Setup instructions for MATHEMATICA

## Dependencies

The PYTHON implementation of RTNI has been developed and tested using PYTHON version 3. For symbolic computation, the
* [sympy](https://www.sympy.org/en/index.html) package is used.



## Installation

The package is contained in the Wolfram Language Package file RTNI.wl. Precomputed Weingarten functions are provided in the subfolder precomputedWG. Proceed as follows:

* Place RTNI.wl in a directory.
* Place the subfolder precomputedWG in the same directory.
* Open/Create a new mathematica-file in the directory.
* Load the RTNI package using the following commands

```markdown
SetDirectory[NotebookDirectory[]];
<< RTNI`
```

If the corresponding out is of the form
```
Package RTNI (Random Tensor Network Integrator) version 1.0.5 (last modification: 26/01/2019).

Loading precomputed Weingarten Functions from /precomputedWG/functions1.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions2.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions3.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions4.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions5.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions6.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions7.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions8.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions9.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions10.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions11.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions12.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions13.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions14.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions15.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions16.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions17.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions18.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions19.txt
Loading precomputed Weingarten Functions from /precomputedWG/functions20.txt
```

then the package and the precomputed functions have been correctly loaded.

## Further steps

* Look at the [Sample code for MATHEMATICA]  `sample-code/<client-language>/README.md` (e.g.: `sample-code/java/README.md`)

