# RTNI - Setup instructions for MATHEMATICA

## Dependencies

The MATHEMATICA implementation of RTNI has been developed and tested using Wolfram Mathematica version 11.

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
**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```



## Further steps

* Look at the [Sample code for MATHEMATICA]  `sample-code/<client-language>/README.md` (e.g.: `sample-code/java/README.md`)

