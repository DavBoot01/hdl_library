HDL Library
===============================================================================

<br/>

Description
-------------------------------------------------------------------------------
This is a collection of IPs written in HDL. Each IP is managed independently with own testbanch and simulation file. <br/>
This wants to be library ables also to make easy to simulate the code. For this purpose, the GHDL tool is use. <br/>
<br/>
For each references about GHDL see at tail of this document.

<br/>

Content
-------------------------------------------------------------------------------
- ``Readme.md``: This guide.
-  ``Makefile``: Main Makefile, used to perform all operations on one specific project.
- ``lib.mk``: Makefile used by each project. It contains all command to analyze, run and show one or more simulations.
- ``<project folder>``: each project is stored in its own folder. The name of this folder is the name of the project used to refer to it.


<br/>

Commands
-------------------------------------------------------------------------------

### Global clean
```
make cleanall
```

### Project list
```
make list_prj
```

### Compile
```
make project=<project name> compile 
```

### List
```
make project=<project name> list 
```

### Run
```
make project=<project name> simulation=<simulation name> run
```

### View
```
make project=<project name> simulation=<simulation name> view
```

### Clean
```
make project=<project name> clean
```

<br/>

Project Structure
-------------------------------------------------------------------------------
>``TODO``

<br/>

Project List
-------------------------------------------------------------------------------
<br/>

|                                               IP | Description                                     |
| -----------------------------------------------: | :---------------------------------------------- |
| [**parallel2serial**](parallel2serial/README.md) | Synchronous/Asynchronous data serializer.       |
| [**serial2parallel**](serial2parallel/README.md) | Parallelization of a single stream line of bit. |


<br/>

Authors
-------------------------------------------------------------------------------
- [Davide Cardillo](https://github.com/DavBoot01)
