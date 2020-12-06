# TimsR

A data science friendly data access to timsTOF Pro mass spectrometry data from R.

### Requirements

TimsPy should work on Linux, Windows (sadly), and macOS.
TimsPy is open-source, but as it uses OpenTIMS under the hood, it comes with similar restrictions concerning the time of flight to mass to charge and scan number to inverse ion mobility conversions [(check out for details here)](https://github.com/michalsta/opentims).


### What can you expect?

Simple way to get data out of results collected with your Bruker timsTOF Pro from R.
This definitely ain't no rocket science, but is pretty useful!

For example:

```R
```

### Basic plotting
You can plot the overview of your experiment.
Continuing on the previous example:

```R
D.plot_TIC()
```
![](https://github.com/MatteoLacki/timspy/blob/master/ms1ms2intensity.png "TIC per frame")

```R
D.plot_peak_counts()
```
![](https://github.com/MatteoLacki/timspy/blob/master/ms1ms2peak_counts.png "TIC per frame")

```R
D.plot_intensity_given_mz_inv_ion_mobility()
```
![](https://github.com/MatteoLacki/timspy/blob/master/ms1_heatmap.png "TIC per frame")

### Vaex support?

Unfortunately, there is yet no equivalent of vaex on R.
But we are monitoring the developments of somewhat similar `dtplyr::lazy_dt` and will possibly encourage its usage once it is tested.  


### Plans
* specialized methods for DDA experiments
* going fully open-source with scan2inv_ion_mobility and tof2mz


### Installation

```{bash}
pip install timspy
```
or for devel version:
```{bash}
pip install -e git+https://github.com/MatteoLacki/timspy/tree/devel
```
or with git:
```{bash}
git clone https://github.com/MatteoLacki/timspy
cd timspy
pip install -e .
```

To install vaex support, use
```{bash}
pip install timspy[vaex]
```
or install add in additional modules
```{bash}
pip install vaex-core vaex-hdf5
```
which seems much less of a hastle than figuring out how pypi internals work.

### API documentation

Please [visit our documentation page](https://matteolacki.github.io/timspy/index.html).

### Too bloat?

We have a simpler module too.
Check out our [opentimsr package](https://github.com/michalsta/opentims).

Best wishes,

Matteo Lacki & Michal (Startrek) Startek