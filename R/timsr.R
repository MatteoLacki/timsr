# *   TimsR: a fully open-source library for opening Bruker's TimsTOF data files.
# *   Copyright (C) 2020 Michał Startek and Mateusz Łącki
# *
# *   This program is free software: you can redistribute it and/or modify
# *   it under the terms of the GNU General Public License, version 3 only,
# *   as published by the Free Software Foundation.
# *
# *   This program is distributed in the hope that it will be useful,
# *   but WITHOUT ANY WARRANTY; without even the implied warranty of
# *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# *   GNU General Public License for more details.
# *
# *   You should have received a copy of the GNU General Public License
# *   along with this program.  If not, see <https://www.gnu.org/licenses/>.


#' Advanced TimsTOF data accessor.
#'
#' S4 class that facilitates data queries for TimsTOF data.
#'
#' @importFrom opentimsr OpenTIMS
#' @export
setClass("TimsR", contains="OpenTIMS")


all_columns = c('frame','scan','tof','intensity','mz','inv_ion_mobility','retention_time')


#' Get TimsR data accessor.
#' 
#' @param path.d Path to the TimsTOF '*.d' folder containing the data (requires the folder to contain only 'analysis.tdf' and 'analysis.tdf_bin').
#' @examples
#' \dontrun{
#' D = TimsR(path_to_.d_folder)
#' D[1] # First frame.
#' }
#' @importFrom opentimsr OpenTIMS
#' @importFrom methods new
#' @export
#' @return instance of TimsR class that represents raw data
TimsR = function(path.d){
    new("TimsR", OpenTIMS(path.d))
}

#' Get border values for measurements.
#'
#' Get the min-max values of the measured variables (except for TOFs, that would require iteration through data rather than parsing metadata).
#' 
#' @param timsr Instance of TimsR.
#' @return data.frame Limits of individual extracted quantities.
#' @export
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' min_max_measurements(D) # this gives a small data-frame with min and max values.
#' }
min_max_measurements = function(timsr) opentimsr::min_max_measurements(timsr)


#' Get some frames of data.
#'
#' @param x OpenTIMS data instance.
#' @param i An array of nonzero indices to extract.
#' @importFrom data.table setDT
#' @export
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(head(D[10]))
#' print(head(D[10:100]))
#' }
#' @return data.table
setMethod("[",
          signature(x = "TimsR", i = "ANY"),
          function(x, i){
            dt = callNextMethod(x, i)
            data.table::setDT(dt)
            dt
          })


#' Extract tables from sqlite database analysis.tdf.
#'
#' Export a table from sqlite.
#'
#' @param timsr Instance of TimsR
#' @param names Names to extract from the sqlite database.
#' @export
#' @importFrom opentimsr table2df
#' @importFrom data.table as.data.table 
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(head(table2dt(D, "Frames"))) # Extract table "Frames".
#' }
#' @return data.table
table2dt = function(timsr, names) data.table::as.data.table(opentimsr::table2df(timsr, names))


#' Extract tables from sqlite database analysis.tdf.
#'
#' @param timsr Instance of TimsR
#' @return character, names of tables.
#' @export
#' @importFrom opentimsr tables_names
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(tables_names(D)) 
#' }
tables_names = function(timsr) opentimsr::tables_names(timsr)


#' Explore the contentents of the sqlite .tdf database.
#'
#' @param timsr Instance of TimsR
#' @return List of data.tables filled with data from 'analysis.tdf'.
#' @export
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(tdf.tables(D)) 
#' }
tdf.tables = function(timsr){
    .table_names = tables_names(timsr) 
    res = lapply(.table_names, table2dt, timsr=timsr)
    names(res) = .table_names
    res
}



#' Get MS1 frame numbers.
#'
#' @param timsr Instance of TimsR
#' @return Numbers of frames corresponding to MS1, i.e. precursor ions.
#' @export
#' @importFrom opentimsr MS1
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(MS1(D)) 
#' }
MS1 = function(timsr) opentimsr::MS1(timsr)


#' Get the number of peaks per frame.
#'
#' @param timsr Instance of TimsR.
#' @return Number of peaks in each frame.
#' @export
#' @importFrom opentimsr peaks_per_frame_cnts
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(peaks_per_frame_cnts(D)) 
#' }
peaks_per_frame_cnts = function(timsr) opentimsr::peaks_per_frame_cnts(timsr)


#' Get the retention time for each frame.
#'
#' @param timsr Instance of TimsR.
#' @return Retention times corresponding to each frame.
#' @export
#' @importFrom opentimsr retention_times
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(retention_times(D)) 
#' }
retention_times = function(timsr) opentimsr::retention_times(timsr)


#' Query for raw data.
#'
#' Get the raw data from Bruker's 'tdf_bin' format.
#' Defaults to both raw data ('frame','scan','tof','intensity') and its tranformations into physical units ('mz','inv_ion_mobility','retention_time').
#'
#' @param timsr Instance of TimsR.
#' @param frames Vector of frame numbers to extract.
#' @param columns Vector of columns to extract. Defaults to all columns.
#' @return data.frame with selected columns.
#' @importFrom data.table setDT
#' @importFrom opentimsr query
#' @export
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(query(D, c(1,20, 53)) # extract all columns
#' print(query(D, c(1,20, 53), columns=c('scan','intensity')) # only 'scan' and 'intensity'
#' }
query = function(timsr,
                 frames,
                 columns=all_columns){
    dt = opentimsr::query(timsr, frames, columns)
    data.table::setDT(dt)
    dt
}


#' Get some frames of data.
#'
#' @param x OpenTIMS data instance.
#' @param i An array of nonzero frame numbers to extract.
#' @param j A vector of strings with column names to extract.
#' @importFrom data.table setDT
#' @importFrom methods callNextMethod
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' all_cols = c('frame','scan','tof','intensity',
#'              'mz','inv_ion_mobility','retention_time')
#' print(D[c(1,20, 53), all_cols]
#' # extracted all columns
#' 
#' print(D[c(1,20, 53), c('scan','intensity')]
#' # only 'scan' and 'intensity'
#' }
#' @return data.table
setMethod("[",
          signature(x = "TimsR", i = "ANY", j="character"),
          function(x, i, j) query(x, i, j)
          )


get_left_frame = function(x,y) ifelse(x > y[length(y)], NA, findInterval(x, y, left.open=T) + 1)

get_right_frame = function(x,y) ifelse(x < y[1], NA, findInterval(x, y, left.open=F))


#' Get the retention time for each frame.
#'
#' @param timsr Instance of TimsR
#' @param min_retention_time Lower boundry on retention time.
#' @param max_retention_time Upper boundry on retention time.
#' @param columns Vector of columns to extract. Defaults to all columns.
#' @return data.frame with selected columns.
#' @importFrom data.table setDT
#' @importFrom opentimsr retention_times
#' @export
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(query_slice(D, 10, 200, 4)) # extract every fourth frame between 10 and 200. 
#' print(query_slice(D, 10, 200, 4, columns=c('scan','intensity')) # only 'scan' and 'intensity'
#' }
rt_query = function(timsr,
                    min_retention_time,
                    max_retention_time,
                    columns=all_columns){

  RTS = opentimsr::retention_times(timsr)

  min_frame = get_left_frame(min_retention_time, RTS)
  max_frame = get_right_frame(max_retention_time, RTS)

  if(is.na(min_frame) | is.na(max_frame))
    stop("The [min_retention_time,max_retention_time] interval does not hold any data.")
  
  query(timsr, min_frame:max_frame, columns)
}



#' Clean memory.
#' 
#' Run garbage collection, by default - 10 times.
#'
#' Check <https://stackoverflow.com/questions/1467201/forcing-garbage-collection-to-run-in-r-with-the-gc-command> 
#' @export
#' @param times Number of times to run garbage collection.
#' @return No return value, called for side effects.
#' @examples
#' \dontrun{
#' cleanMem()
#' }
cleanMem = function(times=10) { for (i in 1:times) gc() }


#' Get Bruker's code needed for running proprietary time of flight to mass over charge and scan to drift time conversion. 
#'
#' By using this function you aggree to terms of license precised in "https://github.com/MatteoLacki/opentims_bruker_bridge".
#' The conversion, due to independent code-base restrictions, are possible only on Linux and Windows operating systems.
#' Works on full open-source solution are on the way. 
#'
#' @param target.folder Folder where to store the 'dll' or 'so' file.
#' @param net_url The url with location of all files.
#' @param mode Which mode to use when downloading a file?
#' @param ... Other parameters to 'download.file'.
#' @return character, path to the output 'timsdata.dll' on Windows and 'libtimsdata.so' on Linux.
#' @importFrom opentimsr download_bruker_proprietary_code
#' @export
#' @examples
#' \dontrun{
#' download_bruker_proprietary_code("your/prefered/destination/folder")
#' }
download_bruker_proprietary_code = function(
  target.folder, 
  net_url=paste0("https://github.com/MatteoLacki/opentims_bruker_bridge/",
                 "raw/main/opentims_bruker_bridge/"),
  mode="wb",
  ...) opentimsr::download_bruker_proprietary_code(
        target.folder,
        net_url,
        mode,
        ...)



#' Dynamically link Bruker's DLL to enable tof-mz and scan-inv_ion_mobility conversion.
#'
#' By using this function you aggree to terms of license precised in "https://github.com/MatteoLacki/opentims_bruker_bridge".
#' The conversion, due to independent code-base restrictions, are possible only on Linux and Windows operating systems.
#' Works on full open-source solution are on the way. 
#'
#' @param path Path to the 'libtimsdata.so' on Linux or 'timsdata.dll' on Windows, as produced by 'download_bruker_proprietary_code'.
#' @export
#' @importFrom opentimsr setup_bruker_so
#' @examples
#' \dontrun{
#' so_path = download_bruker_proprietary_code("your/prefered/destination/folder")
#' setup_bruker_so(so_path)
#' }
#' @return No return value, called for side effects.
setup_bruker_so = function(path) opentimsr::setup_bruker_so(path)


#' Get sum of intensity per each frame (retention time).
#' 
#' @param timsr Instance of TimsR
#' @param recalibrated Use Bruker recalibrated total intensities or calculate them from scratch with OpenTIMS?
#' @export
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' print(intensity_per_frame(D))
#' print(intensity_per_frame(D, recalibrated=FALSE)) 
#' }
#' @return integer vector: total intensity per each frame. 
intensity_per_frame = function(timsr, recalibrated=TRUE){
    if(recalibrated){
        frames = table2dt(timsr,'Frames')
        .intensity_per_frame = frames$Frames.SummedIntensities
    } else {
        .intensity_per_frame = sapply(
            timsr@min_frame:timsr@max_frame,
            function(fr) sum(timsr[fr, c('intensity')]$intensity))
    }
    return(.intensity_per_frame)
}


#' Plot intensity per retention time.
#'
#' Plot will split 'MS1' and 'MS2'.
#' 
#' @param timsr Instance of TimsR
#' @param recalibrated Use Bruker recalibrated total intensities or calculate them from scratch with OpenTIMS?
#' @export
#' @importFrom graphics legend lines plot
#' @examples
#' \dontrun{
#' D = TimsR('path/to/your/folder.d')
#' plot_TIC(D)
#' plot_TIC(D, recalibrated=FALSE)
#' }
#' @return No return value, called for side effects.
plot_TIC = function(timsr, recalibrated=TRUE){
    I = intensity_per_frame(timsr, recalibrated)
    RT = retention_times(timsr)
    frames = table2dt(timsr, "Frames")
    .ms1_mask = frames$Frames.MsMsType == 0   
    plot(RT[.ms1_mask],
         I[.ms1_mask], 
         type='l',
         col='red',
         xlab='Retention Time',
         ylab='Intensity')
    lines(RT[!.ms1_mask],
          I[!.ms1_mask],
          type='l',
          col='blue')
    legend("topright", 
           legend=c("MS1", "MS2"),
           col=c("red", "blue"),
           lty=c(1,1),
           cex=1.5)
}
