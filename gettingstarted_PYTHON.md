# RTNI - Setup instructions for PYTHON

## Dependencies

The PYTHON implementation of RTNI has been developed and tested using PYTHON version 3. For symbolic computation, the
* [sympy](https://www.sympy.org/en/index.html) package is used. 
The graph visualization routines additionally require the following python3 packages:
* [matplotlib](https://matplotlib.org/)
* [networkx](https://networkx.github.io/)
as well as the library python3-tk.



## Installation

The main routines of the RTNI package are contained in the file [IHU_source.py](PYTHON/IHU_source.py). Precomputed Weingarten functions are provided (respectively generated) in the subfolder [Weingarten](PYTHON/Weingarten).

* Place these files into the same directly.
* Load the RTNI package using the following command

```markdown
from IHU_source import *
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

* Look at the [list of files and example code for PYTHON](PYTHON/README.md`)

