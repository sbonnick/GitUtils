# GitUtils
Misc. Git utilities to simplify working in Git targeting large projects spanning multiple repositories

## pull-all

```
Usage: pull-all [-i]
-i : include listing ignored files of a project
```

This is a simple tool that will iterate over all the files in the current directory performing the following tasks:

1. detect if the sub directory is a Git project
  1. display the current (short form) Git status
  2. optionally show ignored files (short form). the "-i" needs to be specified
  3. execute a pull with pruning on the given Git project
  
This tool is ideal for larger projects that are spread across multiple Git repositories and cloned locally in the same "working" folder

## pull

```
Usage: pull [i]
-i : include listing ignored files of a project
```

This is a simple tool that will perform a pull on the local repository while also displaying some other helpful information.