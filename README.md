# SDrawNPS

A version of [SDraw](https://github.com/tmcd82070/SDraw) developed for the National Park Service. The GUI interface for this version uses the `RGtk2` package for its windowing abilities.

Description: This package provides windows and dialog boxes to make drawing samples easier.

License: GNU General Public License

# Installation

There are multiple ways to install. One is from source, the other is from the binary build. The authors have found it best to install dependencies first, then the package.

## Dependencies

Installing the `SDrawNPS` package \emph{should} install dependencies. But, the authors have found dependency installation does not always happen. Consequently, it is best to make sure all dependencies are installed first. In particular, `RGtk2` requires a runtime file (.dll) and this can be difficult to install and have R see it.

To install dependencies, execute the following:

* `install.packages( c("RGtk2", "spsurvey", "rgdal", "rgeos", "sp"), repos="http://cran.r-project.org")`

After installation, issue `library(RGtk2)` at the command prompt. The first time you do this, R should ask whether you want to install the GTK+ runtime library. Say "yes." At the end of this, R may give you an error. Ignore it. Restart R. Issue `library(RGtk2)` again. If nothing happens, you are good. Proceed to install `SDrawNPS`.

If `library(RGtk2)` produces an error after installation of the GTK+ runtime, you can attempt a manual install by downloading the .dll file from the GTK website and copying to the correct directory in your R installation. The authors have found most of the time it works to un-install `RGtk2` and try again (i.e., remove.packages("RGtk2"); install.packages("RGtk2"); library(RGtk2)).

Finally, in rare instances on Windows machines, R may have a trouble finding the location of your GTK+ installation following your copying it to the correct directory in your R installation.  To help it out, assign the location of the GTK+ installation to the Path environment variable.  Specifically, go into "System Properties" from the Control Panel and select "Environment Variables."  Then, in the "System variables" list, select "Path."  In the resulting pop-up, copy and paste the location of the `bin` folder in the `gtk+-bundle` folder as a "New" variable.  Finally, use the "Move Up" button to ensure the new entry results at the top of the list.

## Install `SDrawNPS` from source 

* Download the source tarball (the `tar.gz`) from the [current release](https://github.com/tmcd82070/SDrawNPS/releases)
* In R, execute the following: `install.packages( pkgs=file.choose(), type="source"" )`
* A choose-file dialog will appear.  Navigate to the `tar.gz` file and click "Open"

## Install `SDrawNPS` from binary build

* Download the binary build zip file from the [current release](https://github.com/tmcd82070/SDrawNPS/releases) 
* In the default R interface, select "Install from local zip file..." from the "Packages" menu. Or, in RStudio, click the "Packages" tab, then "Install," then "Browse."
* Navigate to the binary build zip and click "Open"

## Dependencies

The above methods should install all dependencies. If not, execute the following: 

* `install.packages( c("RGtk2", "spsurvey", "rgdal", "rgeos", "sp"), repos="http://cran.r-project.org")`

# After installation
To load the package, issue `library(SDrawNPS)`. An "SDrawNPS" menu item will appear in your R GUI if you are using Windows and the default R console, i.e., not RStudio. From the "SDrawNPS" menu, choose the appropriate action. The dialog boxes that pop up should be self explanatory. See `help(package="SDrawNPS")` for a list of functions.

The functions that open dialog boxes include

* `equi.GUI()` for Equi-probable samples;
* `stratified.GUI()` for Stratified samples;
* `unequal.GUI()` for Unequal probability samples; and
* `analysis.GUI()` for Analysis of continuous or categorical variables.  

# Bugs

https://github.com/tmcd82070/SDrawNPS/issues
