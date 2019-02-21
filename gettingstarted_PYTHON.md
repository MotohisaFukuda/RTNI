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

## Further steps

* Look at the [list of files and example code for PYTHON](PYTHON/README.md)

