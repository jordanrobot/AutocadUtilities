Text Override
===
v.2.8.4
by: Matthew D. Jordan

### About

A simple interface to modify a dimension's text override value directly.  It even features shortcuts for frequently used overrides.  Clear a text override by entering an empty string at the command line. If you want to use a chuck of text that includes space characters, use the Literal option.

### Use:

Start Text Override by entering:

```command: textoverride```

```Select dimension(s):``` it will only select dimensions, so feel free to select regular objects, they will not be affected.  You can also select your dimensions before you start the command.

```Enter Override Text:```  Guess what happens here?  You can also enter shortcuts (upper or lower-case) for commonly used dimension notes. These are listed below and at the prompt.  Also, you can clear a text override by entering nothing at the text prompt.

### Built-In Shortcuts:

|Shortcut...|Means...|
|:--:|--|
|t|5'-0" TYP|
|c|5'-0" OC|
|ct|5'-0" OC TYP|
|cc|5'-0" CTC|
|cct|5'-0" CTC TYP|
|nct|5'-0" <newline> OC TYP|
|th|5'-0" THRU|
|s|5'-0" (Skin)|
|p|(5'-0")|
|<none>|reset text override|

### GUI Helpers

The file ```textOverride-GUI-helpers.lsp``` adds specific autocad command functions to allow gui elements (toolbar buttons, menu items, and ribbon controls) to access textOverride shortcuts directly.