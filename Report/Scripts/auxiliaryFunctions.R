summarizeData <- function(dataset){
  stats <- ddply(dataset, ~ Benchmark + VM,
                 summarise,
                 RuntimeFactor = geometric.mean(RuntimeRatio),
                 sd            = sd(Value),
                 median        = median(Value),
                 max           = max(Value),
                 min           = min(Value))
  stats
}

summarizeNotNormalizedData <- function(dataset){
  stats <- ddply(dataset, ~ Benchmark + VM + Suite,
                 summarise,
                 Time.mean                 = mean(Value),
                 Time.geomean              = geometric.mean(Value),
                 Time.stddev               = sd(Value),
                 Time.median               = median(Value),
                 max = max(Value),
                 min = min(Value))
  stats
}

summarizeOverall <- function(dataset, grouping){
  overall <- ddply(dataset, grouping, summarise,
                   Geomean         = tryCatch({
                     exp(CI(log(OF), ci=0.95))[2]
                   }, error = function(e) {
                     OF
                   }),  
                   Confidence      = tryCatch({
                     paste(
                       paste("<", round(exp(CI(log(OF), ci=0.95))[3], digits = 2), sep=""),
                       paste(round(exp(CI(log(OF), ci=0.95))[1], digits = 2), ">", sep=""),
                       sep=" - ")
                   }, error = function(e) {
                     "Too few values"
                   }),
                   Sd              = sd(OF),
                   Min             = min(OF),
                   Max             = max(OF),
                   Median          = median(OF))
  return(overall)
}

normalizeData <- function (dataset, grouping, baseline, keepBaseline) {
  # normalize for each benchmark separately to the baseline
  baseNormalization <<- baseline
  norm <- ddply(dataset, grouping, transform,
                  RuntimeRatio = Value / mean(Value[VM == baseNormalization]))
  if (!keepBaseline){
    norm <- droplevels(subset(norm, VM != baseNormalization))  
  }
  return (norm)
}

normalizePerIteration <- function (dataset, filterFunction, filterCriteria, baselineNames, keepBaseline) {
  # normalize for each benchmark separately to the baseline
  result <- data.frame(matrix(NA, nrow = 0, ncol = length(dataset[[1]])))
  colnames(result) <- colnames(dataset)
  for (i in 1:length(filterCriteria)) {
    base <<- baselineNames[i]
    filtered <- filterFunction(dataset, filterCriteria[i])
    norm <- ddply(filtered, ~ Benchmark, transform,
                  RuntimeRatio = Value / Value[VM == base & Iteration == Iteration])
    result <- rbind(result, norm)
    if (!keepBaseline){
      result <- subset(result, VM != base)
    } 
  }   
  return (result)
}

selectIterationsAndInlining <- function(data, filename, rowNames, numberOfIterations) {
  bench <- read.table(filename, sep="\t", header=FALSE, col.names=rowNames, fill=TRUE)
  resultSet <- data
  for (b in levels(data$Benchmark)) {
    row <- bench[bench$Benchmark == b,]
    if (is.null(row)) {
      resultSet <- droplevels(subset(resultSet, Benchmark != b))
    } else {
      resultSet <- droplevels(subset(resultSet,(
          (Benchmark != b) |
          (Benchmark == b & Iteration >= row$Iterations & Iteration < row$Iterations + numberOfIterations)  
        )
      ))
    }
  }
  resultSet
}

#Returns the first segment of at least size elements and which mean is not more than 
#thresholdRatio the minimun value of the dataset
segmentWithLengthAndMean <- function(ts, changepoints, size, iterations, thresholdRatio) {
  if (length(changepoints) == 0){
    #No changepoint
    return("No Warmup because there are no changepoints")
  }
  cps <- c(changepoints, iterations)
  segmentLengths <- diff(cps)
  segments <- which(segmentLengths > size)
  #only one changepoint > size?
  if (length(segments) == 0) {
      return("Warmup too late")
  } else {
    #Several changepoints > size
    threshold <- min(ts) * thresholdRatio
    for (i in 1:length(segments)){
      #Select the first which mean is related with the min of the timeseries
      bestFit <- c(1000000, 100000)
      startSegment <- cps[segments[i]]
      elements <- ts[(startSegment + 3):(startSegment + size - 2)]
      if (mean(elements) <= threshold & (startSegment + size - 2) <= iterations){
        return(startSegment)
      } else {
        if (threshold - mean(elements) < bestFit[1]){
          bestFit[1] <- threshold - mean(elements)
          bestFit[2] <- startSegment
        }
      }
    }
    return(paste(paste(paste("No Warmup: best fit with mean difference", bestFit[1]), "at iteration"), bestFit[2])) 
  }
}

warmupFilename <- function(vm) {
  return (paste(paste("changePoint-",vm, sep=""),".tsv", sep=""))
}

missingWarmupFilename <- function(vm) {
  return (paste(paste("missingChangePoint-",vm, sep=""),".tsv", sep=""))
}


overheadFactors <- function(data, baseline, iterations){
  data <- droplevels(subset(data, Iteration >= iterations[1] & Iteration <= iterations[2])) 
  baselineGlobal <<- droplevels(subset(baseline, Iteration >= iterations[1] & Iteration <= iterations[2]))
  return (ddply(data, ~ VM + Benchmark, summarise, 
                     RuntimeFactor = 
                       tryCatch({
                         t.test.ratio(Value, baselineGlobal[baselineGlobal$Benchmark == Benchmark,]$Value)$estimate[3]
                       }, error = function(e) {
                         mean(Value) / mean(baselineGlobal[baselineGlobal$Benchmark == Benchmark,]$Value)
                       }),
                     Confidence    = 
                       tryCatch({
                         paste(
                           paste("<", 
                                 round(t.test.ratio(Value, baselineGlobal[baselineGlobal$Benchmark == Benchmark,]$Value)$conf.int[1], digits = 2), sep=""),
                           paste(
                             round(t.test.ratio(Value, baselineGlobal[baselineGlobal$Benchmark == Benchmark,]$Value)$conf.int[2], digits = 2), ">", sep=""),
                           sep=" - ")
                       }, error = function(e) {
                         " - "
                       })))
  
}
summarizedPerBenchmark <- function(data, iterations, baseline, baselineName, normalized = FALSE) {
  data <- droplevels(subset(data, Iteration >= iterations[1] & Iteration <= iterations[2])) 
  if (!normalized){
    normalized <- normalizeData(data, ~ Benchmark, baselineName, FALSE)
  } else {
    normalized <- data
  }
  #make it global to use it in ddply
  baselineGlobal <<- droplevels(subset(baseline, Iteration >= iterations[1] & Iteration <= iterations[2] & Benchmark %in% levels(factor(normalized$Benchmark))))
  return (ddply(normalized, ~ VM + Benchmark, summarise, 
                     OF = 
                       tryCatch({
                         t.test.ratio(Value, baselineGlobal[baselineGlobal$Benchmark == Benchmark,]$Value)$estimate[3]
                       }, error = function(e) {
                         mean(Value) / mean(baselineGlobal[baselineGlobal$Benchmark == Benchmark,]$Value)
                       }),
                     Confidence    = 
                       tryCatch({
                          paste(
                          paste("<", 
                            round(t.test.ratio(Value, baselineGlobal[baselineGlobal$Benchmark == Benchmark,]$Value)$conf.int[1], digits = 2), sep=""),
                          paste(
                            round(t.test.ratio(Value, baselineGlobal[baselineGlobal$Benchmark == Benchmark,]$Value)$conf.int[2], digits = 2), ">", sep=""),
                          sep=" - ")
                       }, error = function(e) {
                          "Too few values"
                       }),
                     Sd            = sd(RuntimeRatio),
                     Median        = median(RuntimeRatio),
                     Min           = min(RuntimeRatio),
                     Max           = max(RuntimeRatio)))
}

summarizedTable <- function(data, columns) {  
  tableData <- data[,columns]
  return(
    kable(arrange(tableData, Benchmark), 
          booktabs = T,
          format = "latex",
          longtable = T,
          digits = 2)  %>%
      kable_styling(latex_options = c("repeat_header"), font_size = 7)  %>%
      collapse_rows(columns = 1:2))
}  

ciForVM <- function(data, bench, vms){
  lines <- list()
  i <- 1
  for (vm in vms){
    ci <- intervalToNumbers(summaries[summaries$Benchmark == bench & summaries$VM == vm,]$Confidence)
    lines[[i]] <- c(summaries[summaries$Benchmark == bench & summaries$VM == vm,]$OF,
                    ci[1],
                    ci[2])
    i <- i + 1
  }
  return (lines)
}

intervalToNumbers <- function(confidenceString){
  separatorPosition <- regexpr('-', confidenceString)
  low <- as.numeric(substring(confidenceString, 2, separatorPosition - 2))
  high <- as.numeric(substring(confidenceString, separatorPosition + 2, nchar(confidenceString) - 1))
  return (c(low, high))
}

filterVMs <- function(data, vms){
  return (subset(data, VM %in% vms[[1]]))
}