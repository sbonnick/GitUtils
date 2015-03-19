# GitUtils
Misc. Git utilities to simplify working in Git targeting large projects spanning multiple repositories

## pull-all
This is a simple tool that will iterate over all the files in the current directory performing the following tasks:

1. detect if the sub directory is a Git project
  1. display the current (short form) Git status
  2.  execute a pull with pruning on the given local repository
  
This tool is ideal for larger projects that are spread across multiple Git repositories and cloned locally in the same "working" folder
