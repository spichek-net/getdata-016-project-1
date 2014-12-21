# Getting and Cleaning Data
## Project 1

  The script in this repo can be used to clean-up data gathered in **Human Activity Recognition Using Smartphones Data Set**

  The R script in this reo can be invoked from command line using `R -f run_analysis.R`


  Alternatively it can be sourced into R-studio or command line R interpreter via `source("run_analysis.R")`.

  After script completion environment will contain two tidy data sets named `all` and `averages`.
  You'll also get `averages.txt` file with the `averages` data set.

### Data set `all`

  It is is a union of two data subsets, `test` and `training`

  Each of the subsets was produced by application of `readPart` function which did following:
1. Read activity labels from corresponding source file into 
2. Read measurements' names from corresponding source file
3. Beautify measurements' names by application of several regular expression substitution
4. Read all measurements providing column names prepared in the previous step
5. Read subject IDs from corresponding source file
5. Read activity IDs from corresponding source file
6. Prepare combined data set where each set of mesurements has corresponding subject ID and Activity ID
7. Join combined data set with activity labels' data, and select only needed columns in nice order
8. This tidy data subset

  Union of `test` and `*training` data subsets provides `all` tidy data set

### Data set `averages`

  To produce the data set `summarize` and `group_by` functions are used as follows `summarize(group_by(all,Subject,Activity),Mean_of-measure1=mean(measure1),..)`
  Since there are many measures and computing all of them explicitly would require a lot of typing, be error prone, difficult to alter, and unreadable. The string containing complete statement is generated programmatically, and then evaluated by using `eval(parse(...))`

  The data set is then written to **averages.txt** file using **write.table()** function
