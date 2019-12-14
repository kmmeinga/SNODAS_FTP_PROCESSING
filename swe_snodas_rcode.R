# SWE code for mac. #### Still having a hard time rbinding monthdata
require(raster)
require(maps)
library(rgdal)
library(shapefiles)

# Read in ontanogan shapefile
ont = shapefile('/volumes/TOSHIBA/test_swe_watershed/hydrologic_units_WBDHU8_mi131_2613223_01/hydrologic_unitswbdhu8_a_04020102.shp')
cmx = shapefile('/volumes/TOSHIBA/test_swe_watershed/reloadestmodelforcmx/CalumetDelineatedWatershed.shp')

df = NULL
monthdata = NULL
yeardata = NULL
alldata = NULL
monthdatacmx = NULL
yeardatacmx = NULL
alldatacmx = NULL
# I think the best way to do this is maybe to download using wget all the data. but don't unzip it. Maybe use r to do this.
getwd()
setwd('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked')
years = dir()
for (i in 1:length(years)) {
setwd(paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],sep = '/')) 

months = dir()
yeardata = NULL
yeardatacmx = NULL
for (j in 1:length(months)) {
  setwd(paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],months[j],sep = '/'))

list = dir(pattern = 'tar')
monthdata = NULL
monthdatacmx = NULL
# This will be the start of a big for loop!!!!!
for (k in 1:length(list)) {

name = unlist(strsplit(list[k],"\\."))[1]
dir.create(paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],months[j],name,sep = '/'))
untar(list[k],exdir = paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],months[j],name,sep = '/'))
setwd(paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],months[j],name,sep = '/'))
newlist = dir(pattern = 'gz')
matches <- unique (grep("v11034", newlist, value=TRUE))
swe_file = grep("dat",matches,value = TRUE)
namedat = unlist(strsplit(swe_file,"\\."))[1]
if (is.null(namedat)==TRUE) { print(paste('No SWE File', name))
setwd(paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],months[j],sep = '/'))
}
else {
to.read = gzfile(swe_file, "rb")
data <- readBin(to.read, integer(), n = 6935*3351, size = 2, endian = "big") 
setwd(paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],months[j],sep = '/'))
unlink(paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],months[j],name,sep = '/'),force = T,recursive = T)
d <- matrix(data, nrow = 3351, byrow = TRUE)
rast <- raster(d)
extent(rast) <- c(-124.7337,-66.9421,24.9504,52.8754)
projection(rast) <- CRS("+proj=longlat +datum=WGS84")
rast[rast == -9999] = NA
names(rast) = namedat
## IMPORTANT SECTION WHERE WE EXTRACT VALUES! and keep associated dates need to do some reading here
monthdata[k]=extract(rast,ont,na.rm = T, mean)
monthdatacmx[k]=extract(rast,cmx,na.rm = T, mean)
names(monthdata[k])=rep(paste(years[i],months[j],k,sep = '_'),length(monthdata[k]))
names(monthdatacmx[k])=rep(paste(years[i],months[j],k,sep = '_'),length(monthdatacmx[k]))

}
}
yeardata = c(yeardata,monthdata)
yeardatacmx = c(yeardatacmx,monthdatacmx)
}
alldata= append(alldata,list(yeardata))
alldatacmx= append(alldatacmx,list(yeardatacmx))
}


dates <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[2]]))
dates2 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[3]]))
dates3 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[4]]))
dates4 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[5]]))
dates5 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[6]]))
dates6 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[7]]))
dates7 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[8]]))
dates8 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[9]]))
dates9 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[10]]))
dates10 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[11]]))
dates11 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "days", length = length(alldata[[12]]))

datesaxis <- seq(as.Date("01/01/2004", format = "%d/%m/"),
             by = "weeks", length = length(alldata[[2]]))
tiff("/Volumes/TOSHIBA/SWE_data/SWE_Cmx_Ont_fig.tiff", width = 820, height = 620, pointsize = 10)

par(mfrow = c(2,2))

plot(dates, alldatacmx[[2]]/1000, type = 'l', ylim = c(0,.350), xlim = c(dates[20],dates[170]),ylab = "SWE (m)", xlab = "DOY",xaxt = "n", main = "Spring SWE Average for Calumet Creek Watershed from 2004 - 2014")
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1)
lines(dates2,alldatacmx[[3]]/1000, col = "red")
lines(dates3,alldatacmx[[4]]/1000, col = "green")
lines(dates4,alldatacmx[[5]]/1000, col = "cyan")
lines(dates5,alldatacmx[[6]]/1000, col = "lightgrey")
lines(dates6,alldatacmx[[7]]/1000, col = "purple")
lines(dates7,alldatacmx[[8]]/1000, col = "yellow")
lines(dates8,alldatacmx[[9]]/1000, col = "pink")
lines(dates9,alldatacmx[[10]]/1000, col = "darkgreen")
lines(dates10,alldatacmx[[11]]/1000, col = "blue")
lines(dates11,alldatacmx[[12]]/1000, col = "darkorange")
legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014"),cex = 1.25, lty =1, col = c("black","red","green","cyan","lightgrey","purple","yellow","pink","darkgreen","blue","darkorange"))

plot(dates, alldata[[2]]/1000, type = 'l', ylim = c(0,.350), xlim = c(dates[20],dates[170]),ylab = "SWE (m)", xlab = "DOY",xaxt = "n", main = "Spring SWE Average for Ontonagon Watershed from 2004 - 2014")
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1)
lines(dates2,alldata[[3]]/1000, col = "red")
lines(dates3,alldata[[4]]/1000, col = "green")
lines(dates4,alldata[[5]]/1000, col = "cyan")
lines(dates5,alldata[[6]]/1000, col = "lightgrey")
lines(dates6,alldata[[7]]/1000, col = "purple")
lines(dates7,alldata[[8]]/1000, col = "yellow")
lines(dates8,alldata[[9]]/1000, col = "pink")
lines(dates9,alldata[[10]]/1000, col = "darkgreen")
lines(dates10,alldata[[11]]/1000, col = "blue")
lines(dates11,alldata[[12]]/1000, col = "darkorange")
legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014"),cex = 1.25, lty =1, col = c("black","red","green","cyan","lightgrey","purple","yellow","pink","darkgreen","blue","darkorange"))

plot(dates[2:length(dates)], diff(alldatacmx[[2]]/1000), type = 'l', ylim = c(-.060,.060), xlim = c(dates[20],dates[170]),ylab = "m/day", xlab = "DOY",xaxt = "n", main = "Spring SWE Daily Change for Calumet Watershed from 2004 - 2014")
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1)
lines(dates2[2:length(dates2)],diff(alldatacmx[[3]]/1000), col = "red")
lines(dates3[2:length(dates3)],diff(alldatacmx[[4]]/1000), col = "green")
lines(dates4[2:length(dates4)],diff(alldatacmx[[5]]/1000), col = "cyan")
lines(dates5[2:length(dates5)],diff(alldatacmx[[6]]/1000), col = "lightgrey")
lines(dates6[2:length(dates6)],diff(alldatacmx[[7]]/1000), col = "purple")
lines(dates7[2:length(dates7)],diff(alldatacmx[[8]]/1000), col = "yellow")
lines(dates8[2:length(dates8)],diff(alldatacmx[[9]]/1000), col = "pink")
lines(dates9[2:length(dates9)],diff(alldatacmx[[10]]/1000), col = "darkgreen")
lines(dates10[2:length(dates10)],diff(alldatacmx[[11]]/1000), col = "blue")
lines(dates11[2:length(dates11)],diff(alldatacmx[[12]]/1000), col = "darkorange")
legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014"),cex = 1.25, lty =1, col = c("black","red","green","cyan","lightgrey","purple","yellow","pink","darkgreen","blue","darkorange"))

plot(dates[2:length(dates)], diff(alldata[[2]]/1000), type = 'l', ylim = c(-.060,.060), xlim = c(dates[20],dates[170]),ylab = "m/day", xlab = "DOY",xaxt = "n", main = "Spring SWE Daily Change for Ontonagon Watershed from 2004 - 2014")
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1)
lines(dates2[2:length(dates2)],diff(alldata[[3]]/1000), col = "red")
lines(dates3[2:length(dates3)],diff(alldata[[4]]/1000), col = "green")
lines(dates4[2:length(dates4)],diff(alldata[[5]]/1000), col = "cyan")
lines(dates5[2:length(dates5)],diff(alldata[[6]]/1000), col = "lightgrey")
lines(dates6[2:length(dates6)],diff(alldata[[7]]/1000), col = "purple")
lines(dates7[2:length(dates7)],diff(alldata[[8]]/1000), col = "yellow")
lines(dates8[2:length(dates8)],diff(alldata[[9]]/1000), col = "pink")
lines(dates9[2:length(dates9)],diff(alldata[[10]]/1000), col = "darkgreen")
lines(dates10[2:length(dates10)],diff(alldata[[11]]/1000), col = "blue")
lines(dates11[2:length(dates11)],diff(alldata[[12]]/1000), col = "darkorange")
legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014"),cex = 1.25, lty =1, col = c("black","red","green","cyan","lightgrey","purple","yellow","pink","darkgreen","blue","darkorange"))


dev.off()

plot(dates[which.max(alldata[[2]]/1000)], max(alldata[[2]]/1000), ylim = c(0,.35), xlim = c(dates[20],dates[170]),ylab = "m/day", pch = 16, xlab = "DOY",xaxt = "n", main = "SWE Maximum for Ontonagon Watershed from 2004 - 2014")
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1)
points(dates2[which.max(alldata[[3]]/1000)], max(alldata[[3]]/1000), col = "red", pch = 16)
points(dates3[which.max(alldata[[4]]/1000)], max(alldata[[4]]/1000), col = "green", pch = 16)
points(dates4[which.max(alldata[[5]]/1000)], max(alldata[[5]]/1000), col = "cyan", pch = 16)
points(dates5[which.max(alldata[[6]]/1000)], max(alldata[[6]]/1000), col = "lightgrey", pch = 16)
points(dates6[which.max(alldata[[7]]/1000)], max(alldata[[7]]/1000), col = "purple", pch = 16)
points(dates7[which.max(alldata[[8]]/1000)], max(alldata[[8]]/1000), col = "yellow", pch = 16)
points(dates8[which.max(alldata[[9]]/1000)], max(alldata[[9]]/1000), col = "pink", pch = 16)
points(dates9[which.max(alldata[[10]]/1000)], max(alldata[[10]]/1000), col = "darkgreen", pch = 16)
points(dates10[which.max(alldata[[11]]/1000)], max(alldata[[11]]/1000), col = "blue", pch = 16)
points(dates11[which.max(alldata[[12]]/1000)], max(alldata[[12]]/1000), col = "darkorange", pch = 16)

datez = NULL
datez$d1 = dates
datez$d2 = dates2
datez$d3 = dates3
datez$d4 = dates4
datez$d5 = dates5
datez$d6 = dates6
datez$d7 = dates7
datez$d8 = dates8
datez$d9 = dates9
datez$d10 = dates10
datez$d11 = dates11

swechars = NULL
swechars$year = c(2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014)
swechars$maxdate= c(dates[which.max(alldata[[2]]/1000)],dates2[which.max(alldata[[3]]/1000)],dates3[which.max(alldata[[4]]/1000)],dates4[which.max(alldata[[5]]/1000)],dates5[which.max(alldata[[6]]/1000)],dates6[which.max(alldata[[7]]/1000)],dates7[which.max(alldata[[8]]/1000)],dates8[which.max(alldata[[9]]/1000)],dates9[which.max(alldata[[10]]/1000)],dates10[which.max(alldata[[11]]/1000)],dates11[which.max(alldata[[12]]/1000)])
swechars$max = c(max(alldata[[2]]/1000),max(alldata[[3]]/1000),max(alldata[[4]]/1000),max(alldata[[5]]/1000),max(alldata[[6]]/1000),max(alldata[[7]]/1000),max(alldata[[8]]/1000),max(alldata[[9]]/1000),max(alldata[[10]]/1000),max(alldata[[11]]/1000),max(alldata[[12]]/1000))
swechars$m50 = c(max(alldata[[3]]/1000/2),max(alldata[[4]]/1000/2),max(alldata[[5]]/1000/2),max(alldata[[6]]/1000/2),max(alldata[[7]]/1000/2),max(alldata[[8]]/1000/2),max(alldata[[9]]/1000/2),max(alldata[[10]]/1000/2),max(alldata[[11]]/1000/2),max(alldata[[12]]/1000/2))

for (i in 1:11){swechars$m50date[i] = datez[[i]][which.max(alldata[[i+1]]/1000)+which.min(abs(alldata[[i+1]][which.max((alldata[[i+1]]/1000)):200]-max(alldata[[i+1]]/2)))]}


