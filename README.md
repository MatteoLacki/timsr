# TimsR

A data science friendly data access to timsTOF Pro mass spectrometry data from R.

### Requirements

TimsPy should work on Linux, Windows (sadly), and macOS.
TimsPy is open-source, but as it uses OpenTIMS under the hood, it comes with similar restrictions concerning the time of flight to mass to charge and scan number to inverse ion mobility conversions [(check out for details here)](https://github.com/michalsta/opentims).


### What can you expect?

Simple way to get data out of results collected with your Bruker timsTOF Pro from R.
This definitely ain't no rocket science, but is pretty useful!
The data is reported in stored in `data.table` objects, that are the only thing `R` has to actually work meaningfully with big data sets.
Before using `TimsR`, it makes a lot of sense to [study this package](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html).
A helpful cheatsheet is available [here](https://raw.githubusercontent.com/rstudio/cheatsheets/master/datatable.pdf).

With that out of the way, it's all as easy as shown below:

```R
library(timsr)

path = 'path/to/your/data.d'

# Do you want to have access only to 'frame', 'scan', 'time of flight', and 'intensity'?
accept_Bruker_EULA_and_on_Windows_or_Linux = TRUE

if(accept_Bruker_EULA_and_on_Windows_or_Linux){
    folder_to_stode_priopriatary_code = "/home/matteo"
    path_to_bruker_dll = download_bruker_proprietary_code(folder_to_stode_priopriatary_code)
    setup_bruker_so(path_to_bruker_dll)
    all_columns = c('frame','scan','tof','intensity','mz','inv_ion_mobility','retention_time')
} else {
    all_columns = c('frame','scan','tof','intensity','retention_time')
}
# NOTE: if you already did download the 'so' or 'dll', simply use
# setup_bruker_so(path_to_bruker_dll) 
# directly with the proper path to it.

D = TimsR(path) # get data handle

print(D) 
print(length(D)) # The number of peaks.
# 404183877


# Get a data,frame with data from frames 1, 5, and 67.
X = D[c(1,5,67), all_columns]
print(X)
#         frame scan    tof intensity        mz inv_ion_mobility retention_time
#      1:     1   33 312260         9 1174.6558        1.6011418      0.3264921
#      2:     1   34 220720         9  733.4809        1.6000000      0.3264921
#      3:     1   34 261438         9  916.9524        1.6000000      0.3264921
#      4:     1   36  33072         9  152.3557        1.5977164      0.3264921
#      5:     1   36 242110         9  827.3114        1.5977164      0.3264921
#     ---                                                                      
# 224733:    67  917 192745        51  619.2850        0.6007742      7.4056544
# 224734:    67  917 201838        54  655.3439        0.6007742      7.4056544
# 224735:    67  917 205954        19  672.0017        0.6007742      7.4056544
# 224736:    67  917 236501        57  802.1606        0.6007742      7.4056544
# 224737:    67  917 289480        95 1055.2037        0.6007742      7.4056544


# Get a dict with each 10th frame, starting from frame 2, finishing on frame 1000.   
X = D[seq(2,1000,10), all_columns]
#         frame scan    tof intensity        mz inv_ion_mobility retention_time
#      1:     2   33  97298         9  302.3477        1.6011418      0.4347063
#      2:     2   33 310524         9 1165.3273        1.6011418      0.4347063
#      3:     2   34 127985         9  391.9841        1.6000000      0.4347063
#      4:     2   35 280460         9 1009.6751        1.5988582      0.4347063
#      5:     2   37 329377        72 1268.6262        1.5965746      0.4347063
#     ---                                                                      
# 669553:   992  909 198994         9  643.9562        0.6097471    106.7102786
# 669554:   992  909 282616         9 1020.4663        0.6097471    106.7102786
# 669555:   992  912 143270         9  440.9670        0.6063821    106.7102786
# 669556:   992  915 309328         9 1158.9221        0.6030173    106.7102786
# 669557:   992  916 224410         9  749.2647        0.6018958    106.7102786



# Get all MS1 frames 
# print(query(D, frames=MS1(D)))
# ATTENTION: that's quite a lot of data!!! And R will first make a stupid copy, because it's bad. You might exceed your RAM.

# Getting subset of columns: simply specify 'columns':
D[c(1,5,67), c('scan','intensity')]
#         scan intensity
#      1:   33         9
#      2:   34         9
#      3:   34         9
#      4:   36         9
#      5:   36         9
#     ---               
# 224733:  917        51
# 224734:  917        54
# 224735:  917        19
# 224736:  917        57
# 224737:  917        95
# 
# this is also the only way to get data without accepting Bruker terms of service and on MacOS (for time being).
# In that case, you can choose among columns:
# c('frame','scan','tof','intensity','rt')

# Not specifying columns defaults to extracting only the actaully stored raw data in t'analysis.tdf_raw' without their transformations:
D[100]
#       frame scan    tof intensity
#    1:   100   35 389679         9
#    2:   100   35 394578         9
#    3:   100   37  78036         9
#    4:   100   37 210934         9
#    5:   100   37 211498         9
#   ---                            
# 7281:   100  910 156846         9
# 7282:   100  910 355234         9
# 7283:   100  911 294204         9
# 7284:   100  913 248788         9
# 7285:   100  915 100120       120


D[1:100]
#          frame scan    tof intensity
#       1:     1   33 312260         9
#       2:     1   34 220720         9
#       3:     1   34 261438         9
#       4:     1   36  33072         9
#       5:     1   36 242110         9
#      ---                            
# 1633354:   100  910 156846         9
# 1633355:   100  910 355234         9
# 1633356:   100  911 294204         9
# 1633357:   100  913 248788         9
# 1633358:   100  915 100120       120


# All MS1 frames, but one at a time:
for(fr in MS1(D)) print(D[fr, all_columns])
# Of course, it's better to use lapply or mclapply to speed up things.
```

### Basic plotting
You can plot the overview of your experiment.
Continuing on the previous example:

```R
D.plot_TIC()
```
![](https://github.com/MatteoLacki/timsr/blob/main/ms1_ms2_intensities.png "TIC per frame")
<!-- 
```R
D.plot_peak_counts()
```
![](https://github.com/MatteoLacki/timspy/blob/master/ms1ms2peak_counts.png "TIC per frame")

```R
D.plot_intensity_given_mz_inv_ion_mobility()
```
![](https://github.com/MatteoLacki/timspy/blob/master/ms1_heatmap.png "TIC per frame")
 -->
### Vaex support?

Unfortunately, there is yet no equivalent of vaex on R.
But we are monitoring the developments of somewhat similar `dtplyr::lazy_dt` and will possibly encourage its usage once it is tested.  


### Plans
* specialized methods for DDA experiments
* going fully open-source with scan2inv_ion_mobility and tof2mz


### Installation

```R
install.packages('TimsR')
```
or 
```R
library(devtools)

install_github("MatteoLacki/timsr")
```
or with git:
```{bash}
git clone https://github.com/MatteoLacki/timsr

R CMD build timsr_*.tar.gz
R CMD INSTALL timsr_*.tar.gz
```

### Too bloat?

We have a simpler module too.
Check out our [opentimsr package](https://github.com/michalsta/opentims).

Best wishes,

Matteo Lacki & Michal (Startrek) Startek