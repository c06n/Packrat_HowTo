**Table of Contents**

* [If you are in a hurry](#hurry)  
* [A note on terminology](#terminology)  
* [Reproducible Research in R](#reproducibility)  
  * [The Approach](#reproducibility_approach)  
  * [Problems and Solutions](#reproducibility_problems)  
  * [Summary](#reproducibility_summary)
* [Package management](#package_management)
  * [System Libraries](#system_libraries)
  * [User Libraries](#user_libraries)
* [Using Packrat](#using_packrat)
  * [The basics](#packrat_basics)
  * [Best Practice](#best_practice)
* [My Setup](#my_system_setup)
  
# If you are in a hurry<a name="hurry"></a>

[Official site](http://rstudio.github.io/packrat/)  
[Most common commands](http://rstudio.github.io/packrat/commands.html)  
[Example source file](Packrat_HowTo.R)

1. Install Packrat: ```install.packages("packrat")```
1. If you are on Windows, make sure to have separate paths for [```System Libraries```](#system_libraries) and [```User Libraries```](#user_libraries) ([How To](https://stackoverflow.com/questions/15170399/changing-r-default-library-path-using-libpaths-in-rprofile-site-fails-to-work)).
1. Create a ```New Project``` or a ```New Library```.
1. Check ```Use Packrat```. Recommended but not strictly necessary: ```Use Git Version Control```.
1. Re-install the ```User Libraries``` as needed.
1. For longtime archiving purposes, I recommend compressing the project in a [Tarball](https://en.wikipedia.org/wiki/Tar_(computing)).

# A note on terminology<a name="terminology"></a>

Throughout this text, I will refer to the "normal" R as ```R Core```. "Normal" means the engine, the thing that calculates ```1 + 1```, provides the primitives, the language, etc. However, when people speak of R, they usually mean the entire eco system: [CRAN](https://cran.r-project.org/), the standard set of libraries, widely used libraries like ```ggplot2``` or ```data.table```, or even IDEs like RStudio. For reproducible research this is an important distinction.

# Reproducible Research in R<a name="reproducibility"></a>

For every scientific discipline, *reproducibility* is key to understand causal relationships in the world, and deliver solutions to problems in the applied domains. We understand *reproducibility* like this: **The possibility for any interested party to replicate a given effect or confirm an observation** [\[1\]](http://science.sciencemag.org/content/349/6251/aac4716)[\[2\]](https://en.wikipedia.org/wiki/Replication_crisis). This includes the many steps required in data processing and statistical analysis. However, it is a difficult problem exactly how to document the steps of processing and analysis in a way that e.g. 10 years later they can be replicated.

## Approach<a name="reproducibility_approach"></a>

One way to do this comprises the following steps:

1. Fingerprinting a set of the raw data as the exact starting point for the analysis, e.g. via an [MD5 hash](http://ieeexplore.ieee.org/document/4812157/).
1. Documenting the steps of the pre-processing in a script, usually in R, Python or Matlab.
1. Documenting the code for the analysis together with the results, such as in [R Notebooks](http://rmarkdown.rstudio.com/r_notebooks.html) or [Jupyter](http://jupyter.org/). This is also known as [Literate Programming](https://en.wikipedia.org/wiki/Literate_programming).

One drawback of using programming languages such as R and Python is that for any data processing, a number of packages (in other languages *libraries, modules, toolboxes*) will be used. This is partially due to the fact that scripting in R, Python (with Pandas), Matlab or Julia are rather different from *traditional software development*. As a matter of fact, many users of statistical software [do not see themselves as software developers](http://www.huber.embl.de/dsc/slides/Packrat-DSC2014.pdf). Rather, these languages rather act as environments in which certain statistical or data manipulation techniques are implemented. The [R project says](https://www.r-project.org/about.html):

> Many users think of R as a statistics system. We prefer to think of it of an environment within which statistical techniques are implemented. R can be extended (easily) via packages. There are about eight packages supplied with the R distribution and many more are available through the CRAN family of Internet sites covering a very wide range of modern statistics.

Especially in R, packages are updated frequently. This is partially due to R Core being updated frequently. An update (such as from 3.3.2 to 3.3.3) is published [every 1-6 months](https://cran.r-project.org/bin/windows/base/old/). Bug fixes and feature additions in packages are, of course, added for the new R Core versions. So not updating R Core would mean not being able to update packages, which would mean missing out on bug fixes and new features. Of course it would also mean not receiving the R Core bug fixes and feature additions. Further, not updating R Core may mean to not being able to install new packages. It can easily happen that there are no versions of the new package for the R Core version in use, e.g. when the new package is newer than the R Core version being used. 

## Problems and Solutions<a name="reproducibility_problems"></a>

Coming back to *reproducible analyses*, problems can arise. While it cannot be recommended enough to keep R Core updated, this means that all packages will have to be updated as well. Which in turn means that after some time, old scripts may not work anymore. Of course the general idea of the pre-processing and analysis will still be clear from the script source code, but we cannot be certain anymore that the given input (the raw data) actually still produce the output on which the scientific conclusions are based. It should be noted though that this still would be a much more desirable state than simply having no documented script at all, which usually is the case when relying on SPSS, and always is the case when employing EXCEL.

So what do? One obvious solution would be to use version control, especially Git. The problem is that R Core and the necessary libraries are outside of the working tree. You could either use [```git --work-tree=/ add /home/some/directory``` or ```git config --global core.worktree /```](https://stackoverflow.com/questions/2383754/git-how-do-you-add-an-external-directory-to-the-repository), or commit 3 repositories (working tree, R Core, User Libraries). But this is a hacky way, error prone, and adds an overhead of work that guarantees no one will use this approach.

For R, there is another solution available: [**Packrat**](https://rstudio.github.io/packrat/). One of its major advantages is a tight integration with [R Studio](https://www.rstudio.com/), the by far most popular R IDE. Note: For Python, the problem is less severe, since Python Core is much less frequently updated. Nevertheless it exists, and a well known solution approach is [(Ana)conda](https://en.wikipedia.org/wiki/Conda_(package_manager)), a language agnostic package manager which even could be used with R. An even more general approach would be a virtualization tool such as [Docker](https://en.wikipedia.org/wiki/Docker_(software)). It should be noted though that all of these approaches cannot guarantee that a script will still be executable in 10 years, simply for possible changes in the Operating System or other required resources that may not be available 10 years from now.

## Summary<a name="reproducibility_summary"></a>

1. There is a way to do reproducible research.
1. This way relies on software.
1. Software must be kept up to date.
1. This may inhibit running old scripts, thus preventing reproducing old results.
1. The solution: **Package Management**

# Package management<a name="package_management"></a>

What's the core of our problem? **We need a something with all the package versions we have used for our data processing and analysis, and the R Core version.** 

A package is essentially a collection of functions which somebody has written at some point, with some very nice add-ons. There is a very, very [offical documentation](https://cran.r-project.org/doc/manuals/R-exts.html) of what all these terms mean. When you start R and want to load a package, R needs to know where to look for it. This is called a ```search path```. It really is a normal path to a dedicated directory on the computer, in which the packages are stored. This directory itself is called ```library```. Sorry for the confusion, because in other programming languages *libraries* are what in R is a *package*. 

*Hint: In RStudio, you can see the directory for any package by hovering with the mouse over the version numer. There is also a clear distinction between the ```User Library``` and the ```System Library``` in the ```Packages``` panel.*

## System Libraries<a name="system_libraries"></a>

Normally you will find at least one directory (```library```) with packages. It comes shipped with the ```R``` installation, and is located in the folder with the R core program. So if you update to a new R version, you do not have to manually re-download these packages. In RStudio, they show up in the *Packages Panel* under ```System Libraries```. You can find their exact location [like this](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html): ```.Library```. Usually you will get a path  like ```"C:/PROGRA~1/R/R-34~1.1/library"```.

The offical R manual [states](https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Managing-libraries):

> R comes with a single library, ```R_HOME/library``` which is the value of the R object ```.Library``` containing the standard and recommended packages. Both sites and users can create others and make use of them (or not) in an R session. At the lowest level ```.libPaths()``` can be used to add paths to the collection of libraries or to report the current collection. 

You can get the value of ```R_HOME``` from within R [like this](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Rhome.html): ```R.home(component = "home")```

*Note*: ```R_HOME``` is not the same as the ```HOME``` environment variable on Windows. You can get all these values [like this](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Sys.getenv.html): ```Sys.getenv(c("R_HOME", "HOME"))```. This could give you e.g. 

    > Sys.getenv(c("R_HOME", "HOME"))
                      R_HOME          HOME
    "C:/PROGRA~1/R/R-34~1.1"    "D:\\Home" 

This also means that this library **does not have to be managed**: They already are. Down to the first publicly available R version (1.0.0), you can get all versions (and the system libraries) [here](https://cran.r-project.org/bin/windows/base/old/). Of course it is always possible that in 10 years some version may not be available anymore. Given how wildly R is used, that seems implausible. There is also a large number of CRAN-mirrors. If this is a huge issue of concern, I would recommend to build a self hosted CRAN-mirror.

## User Libraries<a name="user_libraries"></a>

You can install packages anywhere. On Windows, if you don't do anything, two things are possible (as in "this will depend on your very specific system setup"):

* They will be installed in ```C:\Users\<your_user_name>\Documents\R\R-<version_number>\library```.
* They will be installed in ```R_HOME/library```.  

Both are not so good ideas:

* [Admin-rights may be necessary to install new packages](https://cran.r-project.org/bin/windows/base/rw-FAQ.html#I-don_0027t-have-permission-to-write-to-the-R_002d3_002e4_002e1_005clibrary-directory), since they will be written in a possibly protected directory.
* When installing a new R version, *User packages* are not transferred to the new R Core installation.
* Difficult to see which packages are necessary for a script to run.
* Unclear which packages have to be managed by the user and which do not.
* Packages may be installed for all users, which can be problematic on multi-user systems.

There are several ways how to setting up a dedicated user library. For Windows, I recommend settting a ```user specific environment variable``` called ```R_LIBS_USER```. Setting this works best via GUI. The value of this variable must be the path to the directory where the user specific libraries will be written. Apparently [that can even be done](https://superuser.com/questions/25037/change-environment-variables-as-standard-user) without an Admin account. You may have to log out from your account for this variable to take effect. You can check if this has worked like this:

In R:

    > Sys.getenv("R_LIBS_USER")  
    [1] "D:\\Home\\R\\Rpackages"  

Or in the ```cmd.exe```, type ```set R_LIBS_USER```. The output must be your desired path.

# Using Packrat<a name="using_packrat"></a>

## The basics<a name="packrat_basics"></a>

So what does Packrat do now? Adding a *Project Specific* library to your project (or package). This means it will not use your usual *User Library*, but build its own based on the packages you use in your project. The *System Library* will still be used, so no change there. In RStudio, when you use Packrat with a project, instead of *User Library* you will now see *Packrat Library*. In the Packrat Documentation, this is sometimes also called a *Private Library*.

You activate this either when setting up the project ("Use packrat with this project"), or later on in the *Project Options*. When you already have a project, Packrat will install all these packages in the *Private Library* in your project (in ```<project>/packrat/scr/```). If you keep working on your project and decide to add another library, you need to install it, regardless whether or not you already have it in your *User Library*. You could also switch Packrat off, include the library, and switch it on again.

Now, the compiled package and the source should be included in your project so you can a) work with it and b) restore these packages later on. ```packrat::snapshot()``` writes all the necessary information regarding the packages in a file ```packrat.lock```. There is an *automatic* option, so this should be working without much intervention. The idea behind this snapshot is that you may install packages in the *Private Library* that have a different version than what was present when doing the last snapshot. It may be that the new version does not work as intended. In that case, you would use ```packrat::restore()``` to recreate the state the project was in at the time of the snapshot. Together with *Git*, you actually can restore any desired state of the packages at any time.

If you are done with your project and want to archive it (or share it), you can use the ```packrat::bundle()``` function. This produces a Tarball, essentially a single file with all the files in your project. ```tar``` is contained on every Unix/Linux/MacOS X system, so it will be easy to restore the project. Of course you can also use the ```packrat::unbundle()``` function.

## Best Practice<a name="best_practice"></a>

For the goal of *reproducible science*, to me it seems best to do the following:

1. Work on your project like usually.
1. When you're done and want to archive a version, activate Packrat via ```packrat::init()``` or the GUI.
1. (Include an R Core installer in the project.)
1. Export the project via ```packrat::bundle()```. 

# My System Setup<a name="my_system_setup"></a>

RStudio Version 1.0.153

    > R.Version()
    $platform
    [1] "x86_64-w64-mingw32"
    
    $version.string
    [1] "R version 3.4.1 (2017-06-30)"
