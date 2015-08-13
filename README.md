# Mapping Italy
This repository contains R code which creates maps of Italy. Dependencies include rgeos, sp, rgdal, and ggplot2. 

# Examples
Here's a choropleth map created by `mapper.R`:

![Population-Adjusted Bank Density by Region - Italy](https://github.com/NoahZinsmeister/mapping_italy/blob/master/sample_map1.png)

Each region is shaded accorded to a bank density variable. Darker shades correspond to high bank density, and vice versa for lighter shades. Bank density is computed as:
```
density_i = totalnumberofbanks_i / population_i
```

Since `mapper.R` uses ggplot2, it is trivial to add additional layers to a map. For example, we could plot (unshaded) regions of Italy and overlay a dot map:

![Population-Adjusted Bank Density by Region - Italy](https://github.com/NoahZinsmeister/mapping_italy/blob/master/sample_map2.png)

Each dot is placed at the location of an Italian city, and the size of the dot corresponds to the log of a bank number variable. Larger dots indicate that a city has more bank branches.

# Usage
The script is relatively straightforward.

1. Clone this git repository.
2. If desired, replace `bankdensity.txt` and/or `bankcities.txt` with your own Italian statistical data.
3. Run `mapper.R` (I used RStudio for this).