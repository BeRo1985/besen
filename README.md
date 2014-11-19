
BESEN is an acronym for "**B** ero's **E** cma **S** cript **E** ngine", and it is a complete ECMAScript Fifth Edition Implemention in Object Pascal, which is compilable with Delphi >=7 and Free Pascal >= 2.5.1 (maybe also 2.4.1).

BESEN is licensed under the LGPL v2.1 with static-linking-exception.

# Features

* Complete implementation of the ECMAScript Fifth Edition standard
* Own bytecode-based ECMA262-complaint Regular Expression Engine
* Incremental praise/exact mark-and-sweep garbage collector
* Unicode UTF8/UCS2/UTF16/UCS4/UTF32 support (on ECMAScript level, UCS2/UTF16)
* Compatibility modes, for example also a facile Javascript compatibility mode
* Bytecode compiler
* Call-Subroutine-Threaded Register-based virtual machine
* Context-Threaded 32-bit x86 and 64-bit x64/AMD64 Just-in-Time Compiler (a ARMv7 EABI JIT for ARM CPUs with VFPv3 instruction set is planned)
* Constant folding
* Dead code elimination
* Abstract-Syntax-Tree based optimizations
* Type inference (both exact and speculative)
* Polymorphic Inline Cache based on object structure and property key IDs
* Perfomance optimized hash maps
* Self balanced trees (for example to sort on-the-fly linked list items of hash maps for very fast enumeration of array objects)
* Easy native Object Pascal class integration (properties per RTTI and published methods per by-hand-parsing of the native virtual method table)

# Hint

* Function code runs faster than global non-function code, because function-local variable accesses will be always identifier index lookups instead of identifier string lookups.
* Strict code runs faster than non-strict code, for that reason please use preferably "use strict" where is it possible, because at strict code is the arguments object creation cheaper at funtion calls, for example no setter/getter creation for each function argument in the arguments object.
* Scoping and some other things between ECMAScript 3rd Edition and ECMAScript 5th Edition are a bit different, so the execution perfomance of ES3 code in a ES5-complaint engine can be strong faster or even strong slower, depends on the individual situation/code.
* No all old ES3 code must be runnable in a ES5-complaint engine, but the most old ES3 code should be runnable, I think.<img src="http://rootserver.rosseaux.net/piwik/piwik.php?idsite=10&rec=1&dummy=besen.png">

# Flattr

[Flattr](http://flattr.com/thing/74902/BESEN-ECMAScript-5th-Edition-Engine Flattr)
 
# Donate

Go to my [donate page](http://vserver.rosseaux.net/donate/)

# IRC channel

IRC channel #besen on Freenode

# Contact

Drop me a mail at benjamin **at** rosseaux **dot** com for bug reports, questions, feature suggestions or whatever. :-)

