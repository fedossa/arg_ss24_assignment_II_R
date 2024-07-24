# Accounting Reading Group - Assignment II

## P/B Ratios And Future Residual Income

This repository contains the code and data for the second assignment of the Accounting Reading Group. It is implemented in [R](https://www.r-project.org/) and [quarto](https://quarto.org/).


### How Do I create the output?

Assuming that you have R, [Rtools](https://cran.r-project.org/bin/windows/Rtools/rtools40.html) (if on windows) and quarto installed, you need to: 

1. Install the required packages. You can run the following code in R to install the required packages:

```R
# Code to install packages to your system
install_package_if_missing <- function(pkg) {
  if (! pkg %in% installed.packages()[, "Package"]) install.packages(pkg)
}
install_package_if_missing("dplyr")
install_package_if_missing("readr")
install_package_if_missing("readxl")
install_package_if_missing("tidyr")
install_package_if_missing("forcats")
install_package_if_missing("kableExtra")
```

2. Download the `wscp_static.txt` and `wscp_panel.xlsx` files provided on moodle and place them in the `data/external/` directory (create the `external` directory if it does not exist). We do not provide these files in the repository because they are proprietary data and this repository is intended to be public.

3. Run `make all` either via the console or by identifying the 'Build All' button in the 'Build' tab (normally in the upper right quadrant of the RStudio screen). This will create both the paper and the presentation pdfs in the `output` directory.

```
This repository was built based on the ['treat' template for reproducible research](https://github.com/trr266/treat).
```