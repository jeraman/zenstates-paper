

#############################
#############################
# Jeronimo Barbosa ##########
# August 14 2017 #############
#############################

# import json library
library(jsonlite)
library(plyr)

#setting the workspace
setwd("/Volumes/Warehouse/Work/Research/Theses/Jeronimo/CHI\ 2018/supplementary\ materials/data\ analysis")

#reading one json file
raw <-loading_one_user_file("./pilot/p-user1.json")
raw <-loading_one_user_file("./pilot/p-user2.json")
raw <-loading_one_user_file("./pilot/p-user3.json")
raw <-loading_one_user_file("./pilot/p-user4.json")
raw <-loading_one_user_file("./pilot/p-user5.json")
raw <-loading_one_user_file("./pilot/p-user6.json")

raw <-loading_one_user_file("./rawdata/user1.json")
raw <-loading_one_user_file("./rawdata/user2.json")
raw <-loading_one_user_file("./rawdata/user3.json")
raw <-loading_one_user_file("./rawdata/user4.json")
raw <-loading_one_user_file("./rawdata/user5.json")
raw <-loading_one_user_file("./rawdata/user6.json")
raw <-loading_one_user_file("./rawdata/user7.json")

#loading all file names
filenames <- list.files("./rawdata", pattern="*.json", full.names=TRUE)
filenames

#loading the first
raw = stream_in(file(filenames[1]))
#raw["decision_speed"] = raw$durationtime - raw$videotime
#raw["decision_accuracy"] = (raw$selectedanswer == raw$rightanswer)
#raw["normalized_decision_speed"] <- normalize(raw$decision_speed)


#computing size
size = length(filenames)
size
print("loading...")

#loading all files
for (i in 1:size) {
  print(i)
  print(filenames[i])
  temp <- stream_in(file(filenames[i]))
  #temp["decision_speed"] = temp$durationtime - temp$videotime
  #temp["decision_accuracy"] = (temp$selectedanswer == temp$rightanswer)
  #temp["normalized_decision_speed"] <- normalize(temp$decision_speed)
  
  Sys.sleep(1)
  if (i > 1) {
    raw = rbind(raw,temp)
  }
}

#formating data types
raw = configuring_data_types(raw)

#summarizing data
summary(raw)
View(raw)

#press space bar + enter on the line you want to execute
computing_decision_speed_right_answers_boxplot_per_tool() 
computing_decision_speed_all_answers_boxplot_per_tool()
computing_decision_errors_barplot_per_tool()
computing_average_completion_time()
detail_age()
detail_experience()
computing_decision_speed_barplot_with_sem_per_tool_all_answers()
detail_questionnaire()
decision_speed_anova_and_pairwise_tests()
decision_accuracy_anova_and_pairwise_tests()
bootstrap_and_estimation_plots()

## (one dimension data)
# plotting decision speed for everyone 
#boxplot(raw$decision_speed, col="blue")

# drawing a line over the graph
#abline(h=median(raw$decision_speed))

#ploting categorical data
#barplot(table(raw$decision_accuraccy), col="wheat", main = "Decision accuracy")

## two dimentional data
#simple plot
#boxplot(raw$decision_speed ~ raw$block, col="blue")
#fancy plot
#boxplot(raw$decision_speed ~ raw$block, col="blue", xlab = "Conceptual model", ylab= "Decision time (in seconds)", names=c("Dataflow", "Imperative", "ZenStates"))

# function that computes a boxplot over the different evaluated tools
computing_decision_speed_right_answers_boxplot_per_tool <- function () {
    # selecting a sebset of the original data (only the right ones)
    only_right_answers = subset(raw, decision_accuracy == TRUE)
    #ploting only the right ones
    boxplot(decision_speed ~ block, only_right_answers, col="blue", xlab = "Conceptual model", ylab= "Decision time (in seconds)", names=c("Dataflow", "Imperative", "ZenStates"))
    #drawing a line containing the average
    abline(h=median(only_right_answers$decision_speed))
}

computing_decision_speed_all_answers_boxplot_per_tool <- function () {
  # selecting a sebset of the original data (only the right ones)
  #only_right_answers = subset(raw, decision_accuraccy == TRUE)
  #ploting only the right ones
  boxplot(decision_speed ~ block, raw, col=c("#fff7bc", "#fec44f", "#d95f0e"), ylim=c(0,100), names=c("Dataflow", "Imperative", "ZenStates"), frame.plot=FALSE, boxwex=.4)
  title(xlab = expression(bold("Conceptual model")), ylab= expression(bold("Decision time (in seconds)")))
  abline(h=median(raw$decision_speed), lwd=1, lty=2)
}

# function that computes a decision speed barplot per tool with standard error of the mean
computing_decision_speed_barplot_with_sem_per_tool_all_answers <- function () {
  #getting raw data
  data.dist <- split(raw$decision_speed, raw$block)
  
  #renaming columns
  names(data.dist)[names(data.dist)=="pd"]  <- "Dataflow"
  names(data.dist)[names(data.dist)=="pde"] <- "Structured"
  names(data.dist)[names(data.dist)=="zen"] <- "ZenStates"
  
  #computing mean to order
  data.dist.mean <- sapply(data.dist, mean)
  #sorting main array
  data.dist=data.dist[order(data.dist.mean,decreasing=FALSE)]
  #computing mean again
  data.dist.mean <- sapply(data.dist, mean)
  #computing sd
  sd <- sapply(data.dist, sd)
  #computing length
  length <- sapply(data.dist, length)
  #computing sem
  data.dist.sem <- sd / sqrt(length)
  
  data.dist.sem
  
  #ploting the graph  
  g = barplot(data.dist.mean, col=c("#fff7bc", "#fec44f", "#d95f0e"), ylim=c(0,100), space=0.5)
  grid(nx=NA, ny=NULL, col = "black")
  #zero line
  abline(h=0, lwd=2, lty=1)
  #ploting the error
  arrows(x0=g, y0=data.dist.mean-data.dist.sem, x1=g, y1=data.dist.mean+data.dist.sem, lwd=.8, code=3, angle=90, length=0.15)
  title(xlab = expression(bold("Conceptual model")), ylab= expression(bold("Decision time (in seconds)")))
  #formating digits 
  value=round(data.dist.mean, digits=2)
  #printing actual values
  text(g, 3, paste("n = ", value), cex=0.7)
  #abline(h=mean(data.dist$pd), lwd=1, lty=2)
  #abline(h=mean(data.dist$pde), lwd=1, lty=2)
  #abline(h=mean(data.dist$zen), lwd=1, lty=2)
}



# function that computes a boxplot over the different evaluated tools
computing_decision_errors_barplot_per_tool <- function () {
    # selecting a sebset of the original data (only the wrong ones)
    only_wrong_answers = subset(raw, decision_accuracy == FALSE)
    
    length(raw$decision_accuracy)/3
    
    print("counting errors")
    print(table(only_wrong_answers$block))
    print("accuracy rate")
    n=length(raw$decision_accuracy)/3
    100-((table(only_wrong_answers$block)/n)*100)
    
    #counting errors
    #barplot(table(only_wrong_answers$block), col="wheat", main = "Decision errors", xlab = "Conceptual model", ylab= "Number of errors", names=c("Dataflow", "Imperative", "ZenStates"))
}

#computes average completion time
computing_average_completion_time <- function() {
  return(median(raw$endTimestamp - raw$beginTimestamp))
}

#function that computes average age and standard deviation
detail_age <- function() {
  print('AGE')
  print(paste("mean", mean(raw$age)))
  print(paste("median", median(raw$age)))
  print(paste("sd", sd(raw$age)))
  print(paste("min:", min(raw$age)))
  print(paste("max age:", max(raw$age)))
}

#function that computes average experience and standard deviation
detail_experience <- function() {
  print('EXPERIENCE')
  print(paste("mean", mean(raw$experience)))
  print(paste("median", median(raw$experience)))
  print(paste("sd", sd(raw$experience)))
  print(paste("min:", min(raw$experience)))
  print(paste("max age:", max(raw$experience)))
  #filtering one entry per id
  sub = raw[match(unique(raw$id),raw$id),]
  #counting
  print("language frequency")
  print(table(sub$language))
}

#details the answer of the questionnaire
detail_questionnaire <- function() {
  #filtering one entry per id
  sub = raw[match(unique(raw$id),raw$id),]
  #counting
  print("easier to understand")
  print(table(sub$easier))
  print("harder to understand")
  print(table(sub$harder))
}

decision_speed_anova_and_pairwise_tests <- function () {
  #ABOUT DIFFERENT TYPES OF ANOVA
  #https://www.researchgate.net/post/What_is_the_difference_between_1way_ANOVA_and_2way_ANOVA_and_MANOVA_How_would_I_know_where_to_apply_which_one
  
  #HOW TO REPORT THE ANOVA
  #http://www.yorku.ca/mack/RN-HowToReportAnFStatistic.html
  
  #OMNIBUS ONE WAY ANOVA ON DECISION SPEED
  #http://rtutorialseries.blogspot.ca/2011/01/r-tutorial-series-one-way-anova-with.html
  print(anova(lm(decision_speed ~ block, data=raw)))
  
  ##################
  #different type of pairwise comparison
  #https://www.r-bloggers.com/r-tutorial-series-anova-pairwise-comparison-methods/
  
  ##none
  print(pairwise.t.test(raw$decision_speed, raw$block, p.adj="none"))
  ##bonferroni (used in proton)
  print(pairwise.t.test(raw$decision_speed, raw$block, p.adj="bonferroni"))
  ##bonferroni (used in holm)
  print(pairwise.t.test(raw$decision_speed, raw$block, p.adj="holm"))
  ##tukey pairwaise comparison
  TukeyHSD(aov(decision_speed ~ block, data=raw))
}

decision_accuracy_anova_and_pairwise_tests <- function () {
  #ABOUT DIFFERENT TYPES OF ANOVA
  #https://www.researchgate.net/post/What_is_the_difference_between_1way_ANOVA_and_2way_ANOVA_and_MANOVA_How_would_I_know_where_to_apply_which_one
  
  #OMNIBUS ONE WAY ANOVA ON DECISION SPEED
  #http://rtutorialseries.blogspot.ca/2011/01/r-tutorial-series-one-way-anova-with.html
  print(anova(lm(decision_accuracy ~ block, data=raw)))
  
  ##################
  #different type of pairwise comparison
  #https://www.r-bloggers.com/r-tutorial-series-anova-pairwise-comparison-methods/
  
  ##none
  print(pairwise.t.test(raw$decision_accuracy, raw$block, p.adj="none"))
  ##bonferroni (used in proton)
  print(pairwise.t.test(raw$decision_accuracy, raw$block, p.adj="bonferroni"))
  ##bonferroni (used in holm)
  print(pairwise.t.test(raw$decision_accuracy, raw$block, p.adj="holm"))
  ##tukey pairwaise comparison
  TukeyHSD(aov(decision_accuracy ~ block, data=raw))
}


subarray_of_logins_and_anwers <- function () {
    #select unique values in subarray 7:16
    subarray <- unique(raw[, 7:16])
    #return result
    return(subarray)
}

loading_one_user_file <- function(filename) {
  #loading all file names
  raw <- stream_in(file(filename))
  
  #fp <- file.path("", filename)
  #result <- fromJSON(file = fp)
  raw = configuring_data_types(raw)
  
  return(raw)
}

loading_all_user_filesA <- function() {
  #loading all file names
  filenames <- list.files("./rawdata", pattern="*.json", full.names=TRUE)
  
  rm (raw)
  rm(temp)
  i = 0
  raw = stream_in(file(filenames[1]))

  
  #loading all files
  for (i in 1:size) {
    print(i)
    temp <- stream_in(file(filenames[i]))
    Sys.sleep(1)
    if (i > 1) {
      raw = rbind(raw,temp)
    }
  }
  
  Summary(result)
  raw = configuring_data_types(raw)
}

#example of combining two different files into one
loading_all_user_filesB <- function() {
  rm(a)
  rm(b)
  rm(c)
  rm(raw)
  a <-loading_one_user_file("./rawdata/user1.json")
  b <-loading_one_user_file("./rawdata/user2.json")
  c <-loading_one_user_file("./rawdata/user3.json")
  #View(a)
  #View(b)
  result = rbind(a,b,c)
  result = configuring_data_types(result)
  View(result)
}

configuring_data_types <-function(data) {
  #converting to the right datatype
  # answers
  data$selectedanswer = as.character(data$selectedanswer);
  data$rightanswer = as.character(data$rightanswer);
  data$block = as.factor(data$block);
  data$durationtime = as.numeric(data$durationtime);
  data$videotime = as.numeric(data$videotime);
  
  # login
  data$id = as.character(data$id);
  data$beginTimestamp = as.POSIXlt(data$beginTimestamp)
  data$endTimestamp = as.POSIXlt(data$endTimestamp)
  
  #profiling
  data$age = as.numeric(data$age);
  data$gender = as.factor(data$gender);
  data$experience = as.numeric(data$experience);
  data$experience = as.numeric(data$experience);
  data$language = as.factor(data$language);
  
  #final questionnaire
  data$easier = as.factor(data$easier);
  data$harder = as.factor(data$harder);
  
  data = computing_decision_speed_and_accuracy(data)
  
  return(data)
}

computing_decision_speed_and_accuracy <- function(data) {
  #computing the decision time
  data["decision_speed"] = data$durationtime - data$videotime
  
  #computing if the answers were right
  data["decision_accuracy"] = (data$selectedanswer == data$rightanswer)
  
  return (data)
}

#from: http://vitalflux.com/data-science-scale-normalize-numeric-data-using-r/
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}



### ADDED BY SH...

## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
sh.summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                         conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     median = median   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  # Add a column with 4 digits rounded measure for graphs
  new_col <- paste0(measurevar,"_rnd")
  datac[,new_col] <- signif(datac[,measurevar], digits=4)
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

sh.boot <- function(data=NULL, measure, fun, iter) {
  library(boot)
  
  result = boot(data[[measure]], fun, iter)
  
  return <- result
}

sh.histoboot <- function(data=NULL, measure, boot_results, title, bwidth = 0.5) {
  library(plyr)
  library(ggplot2)
  #print(boot_results)
  d1 = data.frame(Measure = data[[measure]])
  d2 = data.frame(Measure = boot_results$t[, 1])
  d1$Source = "orig"
  d2$Source = "boot"
  both = rbind(d1, d2)
  
  bothmeans <- ddply(both, c("Source"), summarise, mmean = mean(Measure))
  
  ci = boot.ci(boot_results)
  
  histo_boot <- ggplot(both, aes(Measure, fill = Source, colour = Source)) +
    geom_histogram(aes(y = ..density..), binwidth = bwidth,
                   alpha = 0.6, position = "identity", lwd = 0.2) +
    # geom_density(color='blue', alpha=.3) +
    # geom_vline(aes(xintercept = mean(Time), colour = Source),
    # linetype = 'dashed', size = 0.5) +
    geom_vline(data = bothmeans, aes(xintercept = mmean,
                                     colour = Source), linetype = "dashed", size = 0.5) +
    geom_vline(aes(xintercept = ci$bca[, c(4)], colour = "CI")) + 
    geom_vline(aes(xintercept = ci$bca[, c(5)], colour = "CI")) + 
    ggtitle(title) +
    labs(x=measure)
  print(histo_boot)
  
  rm(d1)
  rm(d2)
  rm(both)
}

sh.violin <- function(data=NULL, data_sse, measure, facet=NULL, bwidth = 2.5, ylabel=NULL, gtitle="") {
  library(scales)
  
  violin <- ggplot(data = data, aes_q(x = as.name(measure))) + 
    #geom_violin(data= data, aes(x=Task, y=completion.time), trim=FALSE) +
    geom_histogram(aes_string(y=paste("..density..*",bwidth,sep=""), fill="..density.."), 
                   col="white", binwidth = bwidth,
                   alpha = .8, position = "identity", lwd = 0.2) +
    scale_x_log10()
  
  if (!is.null(facet))
    violin <- violin + facet_grid(facet)
  violin_b <- ggplot_build(violin)
  
  ylab <- measure
  if (!is.null(ylabel))
    ylab <- ylabel
  
  maxd <- max(violin_b$data[[1]]$density)*bwidth
  
  violin <- violin +
    geom_rect(data = data_sse, aes(xmin=CIl,ymin=0,xmax=CIh,ymax = maxd), linetype = "blank", alpha = 0.3) +
    geom_segment(data = data_sse, aes_q(x=as.name(measure),y=0,xend=as.name(measure),yend = maxd), linetype = "solid", size = 0.2) + 
    geom_text(data=data_sse, aes(x=data_sse[[measure]],y=2*maxd/3,label = signif(data_sse[[measure]], digits=4), vjust = "left"),size=2.5,col="black") +
    geom_segment(data = data_sse, aes(x=0,y=maxd,xend=+Inf,yend = maxd), linetype = "dashed", size = 0.2) +
    # geom_vline(data = data_sse, aes(xintercept = CIl, colour = "CI")) + 
    # geom_vline(data = data_sse, aes(xintercept = CIh, colour = "CI")) +
    geom_errorbarh(data = data_sse, aes_q(x = as.name(measure), y = maxd, xmin=as.name("CIl"),xmax=as.name("CIh"),height=0.005)) +
    coord_flip() + 
    scale_color_brewer(palette="Accent") +
    scale_y_continuous(labels = percent_format()) +
    labs(title = gtitle, x = ylab, y = "density", fill = "density")
  
  return(violin)
}

raw.fn_mean = function(x, indices) {
  return(mean(x[indices]))
}

raw.fn_median = function(x, indices) {
  return(median(x[indices]))
}

# Effect size
# Percent difference beetwen 2 measures m1,m2 are computed using
# p = 100 * (m2 - m1) / (.5 * (m1 + m2))
sh.effect_size <- function(m1,m2) 
{
  return(100 * (m2 - m1) / (.5 * (m1 + m2)))
}


bootstrap_and_estimation_plots <- function() {
  
  boot_results.r <- 2000
  
  #Bootsraping distributions for decision_speed
  #All conditions
  boot_results.time.all = sh.boot(raw, "decision_speed", raw.fn_mean, boot_results.r)
  print(boot_results.time.all)
  #sh.histoboot(raw, "decision_speed", boot_results.time.all, "All data")
  
  #By block (i.e. technique)
  boot_results.time.by_block <- list()
  for (block in levels(raw$block)) {
    raw.filter <- raw[raw$block == block, ]
    rest <- sh.boot(raw.filter, "decision_speed", raw.fn_mean, boot_results.r)
    #sh.histoboot(raw.filter, "decision_speed", rest, block)
    boot_results.time.by_block[[block]] <- rest
    print(rest)
  }
  
  #Bootsraping distributions for decision_accuracy
  #All conditions
  boot_results.acc.all = sh.boot(raw, "decision_accuracy", raw.fn_mean, boot_results.r)
  print(boot_results.acc.all)
  #sh.histoboot(raw, "decision_accuracy", boot_results.acc.all, "All data")
  summary(raw$decision_accuracy)
  summary(raw[raw$block == 'zen', ]$decision_accuracy)
  summary(raw[raw$block == 'pd', ]$decision_accuracy)
  summary(raw[raw$block == 'pde', ]$decision_accuracy)
  
  #By block (i.e. technique)
  boot_results.acc.by_block <- list()
  for (block in levels(raw$block)) {
    raw.filter <- raw[raw$block == block, ]
    rest <- sh.boot(raw.filter, "decision_accuracy", raw.fn_mean, boot_results.r)
    #sh.histoboot(raw.filter, "decision_accuracy", rest, block)
    boot_results.acc.by_block[[block]] <- rest
    print(rest)
  }
  
  #Computing 95% CIs for decision_speed
  #All conditions
  raw.sse.time.all <- sh.summarySE(raw, measurevar = "decision_speed")
  cis = boot.ci(boot_results.time.all)
  raw.sse.time.all$CIl <- cis$bca[, c(4)]
  raw.sse.time.all$CIh <- cis$bca[, c(5)]
  print(raw.sse.time.all)

  #By block (i.e. technique)  
  raw.sse.time.block <- sh.summarySE(raw, measurevar = "decision_speed",
                                      groupvars = c("block"))
  raw.sse.time.block$CIl=raw.sse.time.block$ci
  raw.sse.time.block$CIh=raw.sse.time.block$ci
  
  #compute confidence intervals for each conditions in the summary using bootstrap results
  for (block in levels(raw.sse.time.block$block)) {
    pouet <- boot_results.time.by_block[[block]]
    cis = boot.ci(pouet)
    raw.sse.time.block[raw.sse.time.block$block == block, ]$CIl <- cis$bca[, c(4)]
    raw.sse.time.block[raw.sse.time.block$block == block, ]$CIh <- cis$bca[, c(5)]
    #print(raw.sse.time.block[raw.sse.time.block$block == block, ])
    #print(cis)
  }
  print(raw.sse.time.block)
  
  #Computing 95% CIs for decision_accuracy
  #All conditions
  raw.sse.acc.all <- sh.summarySE(raw, measurevar = "decision_accuracy")
  cis = boot.ci(boot_results.acc.all)
  raw.sse.acc.all$CIl <- cis$bca[, c(4)]
  raw.sse.acc.all$CIh <- cis$bca[, c(5)]
  print(raw.sse.acc.all)
  
  #By block (i.e. technique)  
  raw.sse.acc.block <- sh.summarySE(raw, measurevar = "decision_accuracy",
                                     groupvars = c("block"))
  raw.sse.acc.block$CIl=raw.sse.acc.block$ci
  raw.sse.acc.block$CIh=raw.sse.acc.block$ci
  
  #compute confidence intervals for each conditions in the summary using bootstrap results
  for (block in levels(raw.sse.acc.block$block)) {
    pouet <- boot_results.acc.by_block[[block]]
    cis = boot.ci(pouet)
    raw.sse.acc.block[raw.sse.acc.block$block == block, ]$CIl <- cis$bca[, c(4)]
    raw.sse.acc.block[raw.sse.acc.block$block == block, ]$CIh <- cis$bca[, c(5)]
    #print(raw.sse.acc.block[raw.sse.acc.block$block == block, ])
    #print(cis)
  }
  print(raw.sse.acc.block)
  
  # Simple bargraphs with 95%CIs as error bars
  dodge <- position_dodge(width = 0.9)
  
  #Decision speed
  bars.time.block <- ggplot(raw.sse.time.block, aes(x = reorder(block, decision_speed), y = decision_speed, fill = block)) + 
    geom_bar(stat = "identity", position = dodge) + 
    geom_errorbar(aes(ymin=CIl, ymax=CIh), width=.2, position=position_dodge(.9)) +
    labs(x = expression(bold("Conceptual model")), y = expression(bold("Decision time (in seconds)")))
  print(bars.time.block)
  
  #Decision accuracy
  bars.acc.block <- ggplot(raw.sse.acc.block, aes(x = reorder(block, decision_accuracy), y = decision_accuracy, fill = block)) + 
    geom_bar(stat = "identity", position = dodge) + 
    geom_errorbar(aes(ymin=CIl, ymax=CIh), width=.2, position=position_dodge(.9)) +
    labs(x = expression(bold("Conceptual model")), y = expression(bold("Decision accuracy")))
  print(bars.acc.block)
  
  #Print distribution graphs with CIs
  #All conditions  
  violin.time.all <- sh.violin(raw, raw.sse.time.all, measure="decision_speed", bwidth=0.15, ylabel="Completion Time (s)", gtitle="Completion Time")#bwidth=4
  print(violin.time.all)
  #By block (i.e. technique)  
  violin.time.block <- sh.violin(raw, raw.sse.time.block, measure="decision_speed", ". ~ block", bwidth=0.15, ylabel="Completion Time (s)", gtitle="Completion Time by Technique")
  print(violin.time.block)
  
  #Effect size
  print("pd vs pde decision_speed effect size")
  print(sh.effect_size(raw.sse.time.block[raw.sse.time.block$block == "pd", ]$decision_speed,
                       raw.sse.time.block[raw.sse.time.block$block == "pde", ]$decision_speed))
  
  print("zen vs pd decision_speed effect size")
  print(sh.effect_size(raw.sse.time.block[raw.sse.time.block$block == "zen", ]$decision_speed,
                       raw.sse.time.block[raw.sse.time.block$block == "pd", ]$decision_speed))
  
  print("zen vs pde decision_speed effect size")
  print(sh.effect_size(raw.sse.time.block[raw.sse.time.block$block == "zen", ]$decision_speed,
                       raw.sse.time.block[raw.sse.time.block$block == "pde", ]$decision_speed))
}


# this still have problems...
#analyzing_languages_per_id <-function () {
    #getting the subarray
#    subarray = subarray_of_logins_and_anwers()
    # loading the languages as a separate table
#    table_lang_id = subarray$languages
    #getting unique ids
#    ids = unique(subarray$id)
    # associating the ids to the languages
#    names(table_lang_id) <- subarray$id
    # return results
 #   return(table_lang_id)
#}

#example of how to deal with dates in r
example_on_how_to_deal_with_dates_in_r <- function () {
    # converting to the proper format
    dates = as.POSIXlt(raw$beginTimestamp)
    # checking the array
    dates
    #ordering accord day and time
    dates=dates[order(dates)]
    # checking the ordered array
    View(dates)
}

#example of how to deal with lists in R. this will be used to compute frequency in the languages
example_on_how_to_deal_with_lists_in_r_ <- function() {
  # loading the profiles
  raw <- stream_in(file("./profiling/user1-profiling.json"))
  # loading the languages as a separate table
  test = raw$languages
  # associating the ids to the languages
  names(test) <- raw$id
  # seting the languages as factors
  test=as.factor(test$id)
  #showing a summary of the data
  View(test)
}

#example of combining two different files into one
example_combining_different_files <- function() {
  a <-loading_one_user_file("./rawdata/user1.json")
  b <-loading_one_user_file("./rawdata/user3.json")
  c <-loading_one_user_file("./rawdata/user4.json")
  #View(a)
  #View(b)
  raw = rbind(a,b,c)
  raw = rbind(b,c)
  View(c)
}

#scatterplot
#with(only_right_answers, plot(decision_speed, block))
# hist(raw$decision_speed, col="green")
# rug(raw$decision_speed)
# plot(raw$durationtime)