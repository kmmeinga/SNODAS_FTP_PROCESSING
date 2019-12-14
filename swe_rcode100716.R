# SWE code for mac. 
require(maps)
library(rgdal)
library(shapefiles)
library(raster)

# Read in ontanogan shapefile
ont = shapefile('/volumes/TOSHIBA/test_swe_watershed/hydrologic_units_WBDHU8_mi131_2613223_01/hydrologic_unitswbdhu8_a_04020102.shp')
cmx = shapefile('/volumes/TOSHIBA/test_swe_watershed/reloadestmodelforcmx/CalumetDelineatedWatershed.shp')
st = shapefile('/volumes/TOSHIBA/test_swe_watershed/reloadestmodelforcmx/salmon_trout_watershe.shp')
sup = shapefile('/volumes/TOSHIBA/test_swe_watershed/reloadestmodelforcmx/superior.shp')

df = NULL
monthdata = NULL
yeardata = NULL
alldata = NULL
monthdatacmx = NULL
yeardatacmx = NULL
alldatacmx = NULL
monthdatast = NULL
yeardatast = NULL
alldatast = NULL
monthdatasup = NULL
yeardatasup = NULL
alldatasup = NULL

# I think the best way to do this is maybe to download using wget all the data. but don't unzip it. Maybe use r to do this.
getwd()
setwd('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked')
years = dir()
for (i in 1:length(years)) {
setwd(paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],sep = '/')) 

months = dir()
yeardata = NULL
yeardatacmx = NULL
yeardatast = NULL
yeardatasup = NULL
for (j in 1:length(months)) {
  setwd(paste('/volumes/TOSHIBA/SWE_data/sidads.colorado.edu/DATASETS/NOAA/G02158/masked',years[i],months[j],sep = '/'))

list = dir(pattern = 'tar')
monthdata = NULL
monthdatacmx = NULL
monthdatast = NULL
monthdatasup = NULL
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
monthdatast[k]=extract(rast,st,na.rm = T, mean)
monthdatasup[k]=extract(rast,sup,na.rm = T, mean)
names(monthdata[k])=rep(paste(years[i],months[j],k,sep = '_'),length(monthdata[k]))
names(monthdatacmx[k])=rep(paste(years[i],months[j],k,sep = '_'),length(monthdatacmx[k]))
names(monthdatast[k])=rep(paste(years[i],months[j],k,sep = '_'),length(monthdatast[k]))
names(monthdatasup[k])=rep(paste(years[i],months[j],k,sep = '_'),length(monthdatasup[k]))

}
}
yeardata = c(yeardata,monthdata)
yeardatacmx = c(yeardatacmx,monthdatacmx)
yeardatast = c(yeardatast,monthdatast)
yeardatasup = c(yeardatasup,monthdatasup)
}
alldata= append(alldata,list(yeardata))
alldatacmx= append(alldatacmx,list(yeardatacmx))
alldatast= append(alldatast,list(yeardatast))
alldatasup= append(alldatasup,list(yeardatasup))

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
dates12 <- seq(as.Date("01/01/2004", format = "%d/%m/"),
               by = "days", length = length(alldata[[13]]))
datesaxis <- seq(as.Date("01/01/2004", format = "%d/%m/",cex = 1.5),
             by = "weeks", length = length(alldata[[2]]))
tiff("/Volumes/TOSHIBA/SWE_data/SWE_CMXfig2.tiff", width = 720, height = 310 pointsize = 10)


plot(dates, alldatacmx[[2]]/1000, type = 'l', ylim = c(0,.350),ylab = "SWE (m)", xlab = "DOY",xaxt = "n", main = "Spring SWE Average for Calumet Creek Watershed from 2004 - 2014", cex.lab = 1.4,cex.axis = 1.5, cex.main = 2)
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1, cex.axis = 1.25)
lines(dates2,alldatacmx[[3]]/1000, col = "red")
lines(dates3,alldatacmx[[4]]/1000, col = "green")
lines(dates4,alldatacmx[[5]]/1000, col = "cyan")
lines(dates5,alldatacmx[[6]]/1000, col = "lightgrey")
lines(dates6,alldatacmx[[7]]/1000, col = "purple")
lines(dates7,alldatacmx[[8]]/1000, col = "goldenrod")
lines(dates8,alldatacmx[[9]]/1000, col = "deeppink")
lines(dates9,alldatacmx[[10]]/1000, col = "darkgreen")
lines(dates10,alldatacmx[[11]]/1000, col = "blue")
lines(dates11,alldatacmx[[12]]/1000, col = "darkorange")
lines(dates11,alldatacmx[[13]]/1000, col = "darkgrey")
legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015"),cex = 1.25, lty =1, col = c("black","red","green","cyan","lightgrey","purple","goldenrod","deeppink","darkgreen","blue","darkorange","darkgrey"))

dev.off()

tiff("/Volumes/TOSHIBA/SWE_data/SWE_ONTfig2.tiff", width = 720, height = 310 pointsize = 10)

plot(dates, alldata[[2]]/1000, type = 'l', ylim = c(0,.350), xlim = c(dates[20],dates[170]),ylab = "SWE (m)", xlab = "DOY",xaxt = "n", main = "Spring SWE Average for Ontonagon Watershed from 2004 - 2014", cex.lab = 1.4,cex.axis = 1.5, cex.main = 2)
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1,cex.axis = 1.25)
lines(dates2,alldata[[3]]/1000, col = "red")
lines(dates3,alldata[[4]]/1000, col = "green")
lines(dates4,alldata[[5]]/1000, col = "cyan")
lines(dates5,alldata[[6]]/1000, col = "lightgrey")
lines(dates6,alldata[[7]]/1000, col = "purple")
lines(dates7,alldata[[8]]/1000, col = "goldenrod")
lines(dates8,alldata[[9]]/1000, col = "deeppink")
lines(dates9,alldata[[10]]/1000, col = "darkgreen")
lines(dates10,alldata[[11]]/1000, col = "blue")
lines(dates11,alldata[[12]]/1000, col = "darkorange")
lines(dates12,alldata[[13]]/1000, col = "darkgrey")
legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015"),cex = 1.25, lty =1, col = c("black","red","green","cyan","lightgrey","purple","goldenrod","deeppink","darkgreen","blue","darkorange","darkgrey"))
dev.off()

tiff("/Volumes/TOSHIBA/SWE_data/SWE_ONTfig2.tiff", width = 720, height = 310 pointsize = 10)

plot(dates, alldatast[[2]]/1000, type = 'l', ylim = c(0,.350), xlim = c(dates[20],dates[170]),ylab = "SWE (m)", xlab = "DOY",xaxt = "n", main = "Spring SWE Average for Salmon-Trout Watershed from 2004 - 2014", cex.lab = 1.4,cex.axis = 1.5, cex.main = 2)
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1,cex.axis = 1.25)
lines(dates2,alldatast[[3]]/1000, col = "red")
lines(dates3,alldatast[[4]]/1000, col = "green")
lines(dates4,alldatast[[5]]/1000, col = "cyan")
lines(dates5,alldatast[[6]]/1000, col = "lightgrey")
lines(dates6,alldatast[[7]]/1000, col = "purple")
lines(dates7,alldatast[[8]]/1000, col = "goldenrod")
lines(dates8,alldatast[[9]]/1000, col = "deeppink")
lines(dates9,alldatast[[10]]/1000, col = "darkgreen")
lines(dates10,alldatast[[11]]/1000, col = "blue")
lines(dates11,alldatast[[12]]/1000, col = "darkorange")
lines(dates12,alldatast[[12]]/1000, col = "darkgrey")
legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015"),cex = 1.25, lty =1, col = c("black","red","green","cyan","lightgrey","purple","goldenrod","deeppink","darkgreen","blue","darkorange","darkgrey"))
dev.off()

plot(dates[2:length(dates)], diff(alldatacmx[[2]]/1000), type = 'l', ylim = c(-.060,.060), xlim = c(dates[20],dates[170]),ylab = "m/day", xlab = "DOY",xaxt = "n", main = "Spring SWE Daily Change for Calumet Watershed from 2004 - 2014", cex.lab = 1.5,cex.axis = 1.25, cex.main = 2)
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1)
lines(dates2[2:length(dates2)],diff(alldatacmx[[3]]/1000), col = "red")
lines(dates3[2:length(dates3)],diff(alldatacmx[[4]]/1000), col = "green")
lines(dates4[2:length(dates4)],diff(alldatacmx[[5]]/1000), col = "cyan")
lines(dates5[2:length(dates5)],diff(alldatacmx[[6]]/1000), col = "lightgrey")
lines(dates6[2:length(dates6)],diff(alldatacmx[[7]]/1000), col = "purple")
lines(dates7[2:length(dates7)],diff(alldatacmx[[8]]/1000), col = "goldenrod")
lines(dates8[2:length(dates8)],diff(alldatacmx[[9]]/1000), col = "darkpink")
lines(dates9[2:length(dates9)],diff(alldatacmx[[10]]/1000), col = "darkgreen")
lines(dates10[2:length(dates10)],diff(alldatacmx[[11]]/1000), col = "blue")
lines(dates11[2:length(dates11)],diff(alldatacmx[[12]]/1000), col = "darkorange")
lines(dates12[2:length(dates12)],diff(alldatacmx[[13]]/1000), col = "darkgrey")

legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015"),cex = 1.25, lty =1, col = c("black","red","green","cyan","lightgrey","purple","yellow","pink","darkgreen","blue","darkorange","darkgrey"))

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
lines(dates12[2:length(dates12)],diff(alldata[[13]]/1000), col = "darkgrey")

legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015"),cex = 1.25, lty =1, col = c("black","red","green","cyan","lightgrey","purple","yellow","pink","darkgreen","blue","darkorange"))


dev.off()


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
datez$d12 = dates12

swechars = NULL
swechars$year = c(2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015)
swechars$maxdate= c(dates[which.max(alldata[[2]]/1000)],dates2[which.max(alldata[[3]]/1000)],dates3[which.max(alldata[[4]]/1000)],dates4[which.max(alldata[[5]]/1000)],dates5[which.max(alldata[[6]]/1000)],dates6[which.max(alldata[[7]]/1000)],dates7[which.max(alldata[[8]]/1000)],dates8[which.max(alldata[[9]]/1000)],dates9[which.max(alldata[[10]]/1000)],dates10[which.max(alldata[[11]]/1000)],dates11[which.max(alldata[[12]]/1000)],dates12[which.max(alldata[[13]]/1000)])
swechars$max = c(max(alldata[[2]]/1000),max(alldata[[3]]/1000),max(alldata[[4]]/1000),max(alldata[[5]]/1000),max(alldata[[6]]/1000),max(alldata[[7]]/1000),max(alldata[[8]]/1000),max(alldata[[9]]/1000),max(alldata[[10]]/1000),max(alldata[[11]]/1000),max(alldata[[12]]/1000),max(alldata[[13]]/1000))
swechars$m50 = c(max(alldata[[2]]/1000/2),max(alldata[[3]]/1000/2),max(alldata[[4]]/1000/2),max(alldata[[5]]/1000/2),max(alldata[[6]]/1000/2),max(alldata[[7]]/1000/2),max(alldata[[8]]/1000/2),max(alldata[[9]]/1000/2),max(alldata[[10]]/1000/2),max(alldata[[11]]/1000/2),max(alldata[[12]]/1000/2),max(alldata[[13]]/1000/2))
swechars$m50date = dates[which.max(alldata[[2]]/1000)]
for (i in 1:12){swechars$m50date[i] = datez[[i]][which.max(alldata[[i+1]]/1000)+which.min(abs(alldata[[i+1]][which.max((alldata[[i+1]]/1000)):200]-max(alldata[[i+1]]/2)))]}
swechars$zerodate = c(dates[match(0,alldata[[2]])],dates2[match(0,alldata[[3]])],dates3[match(0,alldata[[4]])],dates4[match(0,alldata[[5]])],dates5[match(0,alldata[[6]])],dates6[match(0,alldata[[7]])],dates7[match(0,alldata[[8]])],dates8[match(0,alldata[[9]])],dates9[match(0,alldata[[10]])],dates10[match(0,alldata[[11]])],dates11[match(0,alldata[[12]])],dates12[match(0,alldata[[13]])])
cmxswechars = NULL
cmxswechars$year = c(2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015)
cmxswechars$maxdate= c(dates[which.max(alldatacmx[[2]]/1000)],dates2[which.max(alldatacmx[[3]]/1000)],dates3[which.max(alldatacmx[[4]]/1000)],dates4[which.max(alldatacmx[[5]]/1000)],dates5[which.max(alldatacmx[[6]]/1000)],dates6[which.max(alldatacmx[[7]]/1000)],dates7[which.max(alldatacmx[[8]]/1000)],dates8[which.max(alldatacmx[[9]]/1000)],dates9[which.max(alldatacmx[[10]]/1000)],dates10[which.max(alldatacmx[[11]]/1000)],dates11[which.max(alldatacmx[[12]]/1000)],dates12[which.max(alldatacmx[[13]]/1000)])
cmxswechars$max = c(max(alldatacmx[[2]]/1000),max(alldatacmx[[3]]/1000),max(alldatacmx[[4]]/1000),max(alldatacmx[[5]]/1000),max(alldatacmx[[6]]/1000),max(alldatacmx[[7]]/1000),max(alldatacmx[[8]]/1000),max(alldatacmx[[9]]/1000),max(alldatacmx[[10]]/1000),max(alldatacmx[[11]]/1000),max(alldatacmx[[12]]/1000),max(alldatacmx[[13]]/1000))
cmxswechars$m50 = c(max(alldatacmx[[2]]/1000/2),max(alldatacmx[[3]]/1000/2),max(alldatacmx[[4]]/1000/2),max(alldatacmx[[5]]/1000/2),max(alldatacmx[[6]]/1000/2),max(alldatacmx[[7]]/1000/2),max(alldatacmx[[8]]/1000/2),max(alldatacmx[[9]]/1000/2),max(alldatacmx[[10]]/1000/2),max(alldatacmx[[11]]/1000/2),max(alldatacmx[[12]]/1000/2),max(alldatacmx[[13]]/1000/2))
cmxswechars$m50date = dates[which.max(alldatacmx[[2]]/1000)]
for (i in 1:12){cmxswechars$m50date[i] = datez[[i]][which.max(alldatacmx[[i+1]]/1000)+which.min(abs(alldatacmx[[i+1]][which.max((alldatacmx[[i+1]]/1000)):200]-max(alldatacmx[[i+1]]/2)))]}
cmxswechars$zerodate = c(dates[match(0,alldatacmx[[2]])],dates2[match(0,alldatacmx[[3]])],dates3[match(0,alldatacmx[[4]])],dates4[match(0,alldatacmx[[5]])],dates5[match(0,alldatacmx[[6]])],dates6[match(0,alldatacmx[[7]])],dates7[match(0,alldatacmx[[8]])],dates8[match(0,alldatacmx[[9]])],dates9[match(0,alldatacmx[[10]])],dates10[match(0,alldatacmx[[11]])],dates11[match(0,alldatacmx[[12]])],dates12[match(0,alldatacmx[[13]])])
cmxswechars$zerodate = c(dates[which(0,alldatacmx[[2]])],dates2[match(0,alldatacmx[[3]])],dates3[match(0,alldatacmx[[4]])],dates4[match(0,alldatacmx[[5]])],dates5[match(0,alldatacmx[[6]])],dates6[match(0,alldatacmx[[7]])],dates7[match(0,alldatacmx[[8]])],dates8[match(0,alldatacmx[[9]])],dates9[match(0,alldatacmx[[10]])],dates10[match(0,alldatacmx[[11]])],dates11[match(0,alldatacmx[[12]])],dates12[match(0,alldatacmx[[13]])])

stswechars = NULL
stswechars$year = c(2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015)
stswechars$maxdate= c(dates[which.max(alldatast[[2]]/1000)],dates2[which.max(alldatast[[3]]/1000)],dates3[which.max(alldatast[[4]]/1000)],dates4[which.max(alldatast[[5]]/1000)],dates5[which.max(alldatast[[6]]/1000)],dates6[which.max(alldatast[[7]]/1000)],dates7[which.max(alldatast[[8]]/1000)],dates8[which.max(alldatast[[9]]/1000)],dates9[which.max(alldatast[[10]]/1000)],dates10[which.max(alldatast[[11]]/1000)],dates11[which.max(alldatast[[12]]/1000)],dates12[which.max(alldatast[[13]]/1000)])
stswechars$max = c(max(alldatast[[2]]/1000),max(alldatast[[3]]/1000),max(alldatast[[4]]/1000),max(alldatast[[5]]/1000),max(alldatast[[6]]/1000),max(alldatast[[7]]/1000),max(alldatast[[8]]/1000),max(alldatast[[9]]/1000),max(alldatast[[10]]/1000),max(alldatast[[11]]/1000),max(alldatast[[12]]/1000),max(alldatast[[13]]/1000))
stswechars$m50 = c(max(alldatast[[2]]/1000/2), max(alldatast[[3]]/1000/2),max(alldatast[[4]]/1000/2),max(alldatast[[5]]/1000/2),max(alldatast[[6]]/1000/2),max(alldatast[[7]]/1000/2),max(alldatast[[8]]/1000/2),max(alldatast[[9]]/1000/2),max(alldatast[[10]]/1000/2),max(alldatast[[11]]/1000/2),max(alldatast[[12]]/1000/2),max(alldatast[[13]]/1000/2))
stswechars$m50date = dates[which.max(alldata[[2]]/1000)]
for (i in 1:12){stswechars$m50date[i] = datez[[i]][which.max(alldatast[[i+1]]/1000)+which.min(abs(alldatast[[i+1]][which.max((alldatast[[i+1]]/1000)):200]-max(alldatast[[i+1]]/2)))]}
stswechars$zerodate = c(dates[match(0,alldatast[[2]])],dates2[match(0,alldatast[[3]])],dates3[match(0,alldatast[[4]])],dates4[match(0,alldatast[[5]])],dates5[match(0,alldatast[[6]])],dates6[match(0,alldatast[[7]])],dates7[match(0,alldatast[[8]])],dates8[match(0,alldatast[[9]])],dates9[match(0,alldatast[[10]])],dates10[match(0,alldatast[[11]])],dates11[match(0,alldatast[[12]])],dates12[match(0,alldatast[[13]])])

supswechars = NULL
supswechars$year = c(2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015)
supswechars$maxdate= c(dates[which.max(alldatasup[[2]]/1000)],dates2[which.max(alldatasup[[3]]/1000)],dates3[which.max(alldatasup[[4]]/1000)],dates4[which.max(alldatasup[[5]]/1000)],dates5[which.max(alldatasup[[6]]/1000)],dates6[which.max(alldatasup[[7]]/1000)],dates7[which.max(alldatasup[[8]]/1000)],dates8[which.max(alldatasup[[9]]/1000)],dates9[which.max(alldatasup[[10]]/1000)],dates10[which.max(alldatasup[[11]]/1000)],dates11[which.max(alldatasup[[12]]/1000)],dates12[which.max(alldatasup[[13]]/1000)])
supswechars$max = c(max(alldatasup[[2]]/1000),max(alldatasup[[3]]/1000),max(alldatasup[[4]]/1000),max(alldatasup[[5]]/1000),max(alldatasup[[6]]/1000),max(alldatasup[[7]]/1000),max(alldatasup[[8]]/1000),max(alldatasup[[9]]/1000),max(alldatasup[[10]]/1000),max(alldatasup[[11]]/1000),max(alldatasup[[12]]/1000),max(alldatasup[[13]]/1000))
supswechars$m50 = c(max(alldatasup[[2]]/1000/2), max(alldatasup[[3]]/1000/2),max(alldatasup[[4]]/1000/2),max(alldatasup[[5]]/1000/2),max(alldatasup[[6]]/1000/2),max(alldatasup[[7]]/1000/2),max(alldatasup[[8]]/1000/2),max(alldatasup[[9]]/1000/2),max(alldatasup[[10]]/1000/2),max(alldatasup[[11]]/1000/2),max(alldatasup[[12]]/1000/2),max(alldatasup[[13]]/1000/2))
supswechars$m50date = dates[which.max(alldata[[2]]/1000)]
for (i in 1:12){cmxswechars$m50date[i] = datez[[i]][which.max(alldatasup[[i+1]]/1000)+which.min(abs(alldatasup[[i+1]][which.max((alldatasup[[i+1]]/1000)):200]-max(alldatasup[[i+1]]/2)))]}
supswechars$zerodate = c(dates[match(0,alldatasup[[2]])],dates2[match(0,alldatasup[[3]])],dates3[match(0,alldatasup[[4]])],dates4[match(0,alldatasup[[5]])],dates5[match(0,alldatasup[[6]])],dates6[match(0,alldatasup[[7]])],dates7[match(0,alldatasup[[8]])],dates8[match(0,alldatasup[[9]])],dates9[match(0,alldatasup[[10]])],dates10[match(0,alldatasup[[11]])],dates11[match(0,alldatasup[[12]])],dates12[match(0,alldatasup[[13]])])

plot(dates[which.max(alldatacmx[[2]]/1000)], max(alldatacmx[[2]]/1000), xlim = c(dates[20],dates[170]),ylim = c(0,.35),ylab = "SWE (m)", pch = 16, xlab = "DOY",xaxt = "n", main = "SWE Maximum for Calumet Watershed from 2004 - 2014")
axis(1, labels = FALSE,xaxt = "n")
axis.Date(side = 1, at = datesaxis, format  = "%b %d", las = 1)
points(dates2[which.max(alldatacmx[[3]]/1000)], max(alldatacmx[[3]]/1000), col = "red", pch = 16)
points(dates3[which.max(alldatacmx[[4]]/1000)], max(alldatacmx[[4]]/1000), col = "green", pch = 16)
points(dates4[which.max(alldatacmx[[5]]/1000)], max(alldatacmx[[5]]/1000), col = "cyan", pch = 16)
points(dates5[which.max(alldatacmx[[6]]/1000)], max(alldatacmx[[6]]/1000), col = "lightgrey", pch = 16)
points(dates6[which.max(alldatacmx[[7]]/1000)], max(alldatacmx[[7]]/1000), col = "purple", pch = 16)
points(dates7[which.max(alldatacmx[[8]]/1000)], max(alldatacmx[[8]]/1000), col = "goldenrod", pch = 16)
points(dates8[which.max(alldatacmx[[9]]/1000)], max(alldatacmx[[9]]/1000), col = "pink", pch = 16)
points(dates9[which.max(alldatacmx[[10]]/1000)], max(alldatacmx[[10]]/1000), col = "darkgreen", pch = 16)
points(dates10[which.max(alldatacmx[[11]]/1000)], max(alldatacmx[[11]]/1000), col = "blue", pch = 16)
points(dates11[which.max(alldatacmx[[12]]/1000)], max(alldatacmx[[12]]/1000), col = "darkorange", pch = 16)

points(cmxswechars$m50date[[1]], max(alldatacmx[[2]]/1000), col = "black", pch = "-")
points(cmxswechars$m50date[[2]], max(alldatacmx[[3]]/1000), col = "red", pch = "-")
points(cmxswechars$m50date[[3]], max(alldatacmx[[4]]/1000), col = "green", pch = "-")
points(cmxswechars$m50date[[4]], max(alldatacmx[[5]]/1000), col = "cyan", pch = "-")
points(cmxswechars$m50date[[5]], max(alldatacmx[[6]]/1000), col = "lightgrey", pch = "-")
points(cmxswechars$m50date[[6]], max(alldatacmx[[7]]/1000), col = "purple", pch = "-")
points(cmxswechars$m50date[[7]], max(alldatacmx[[8]]/1000), col = "goldenrod", pch = "-")
points(cmxswechars$m50date[[8]], max(alldatacmx[[9]]/1000), col = "pink", pch = "-")
points(cmxswechars$m50date[[9]], max(alldatacmx[[10]]/1000), col = "darkgreen", pch = "-")
points(cmxswechars$m50date[[10]], max(alldatacmx[[11]]/1000), col = "blue", pch = "-")
points(cmxswechars$m50date[[11]], max(alldatacmx[[12]]/1000), col = "darkorange", pch = "-")

legend("topright",c("2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014"),cex = 1, lty =1, col = c("black","red","green","cyan","lightgrey","purple","goldenrod","pink","darkgreen","blue","darkorange"))
