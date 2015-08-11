# installs and attaches required packages
if(! require(rgeos))
{
  install.packages("rgeos")
  require(rgeos)
}
if(! require(sp))
{
  install.packages("sp")
  require(sp)
}
if(! require(rgdal))
{
  install.packages("rgdal")
  require(rgdal)
}
if(! require(ggplot2))
{
  install.packages("ggplot2")
  require(ggplot2)
}

# creates a dataframe which contains shape information for Italian regions. Source: http://www.diva-gis.org/datadown
itMap <- readOGR(dsn = "ITA_adm", layer = "ITA_adm1")

# this is a dataset I compiled which records the number of banks and population per region of Italy
bankdensity <- read.csv("bankdensity.txt", row.names=1, sep="")
# adds population-adjusted bank density per region to itMap
itMap@data$density <- bankdensity$num_banks/bankdensity$num_people

# converts OGR file into something ggplot can handle
itMap.f <- fortify(itMap, region="NAME_1")
# adds columns from itMap@data back into this dataframe
itMap.f <- merge(itMap.f, itMap@data, by.x = "id", by.y = "NAME_1")

# choropleth map
map1 <- ggplot() + 
  # this plots the region polygons of Italy colored according to density
  geom_polygon(data=itMap.f, aes(x=long, y=lat, group = group, fill=density), linetype=1, size=0) + 
  coord_map() + 
  theme(
    panel.background = element_rect(fill = "gray17",size = 0),
    line = element_line(linetype=0),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    title = element_text(size=20)) + 
  # this specifies the color gradient of the fill
  scale_fill_gradient(name = "Bank Density", guide = FALSE, low = "#F1F2F1", high = "cornflowerblue") + 
  labs(title = "Population-Adjusted Bank Density by Region - Italy")

# this is a dataset I compiled which records the number of bank branches in a variety of Italian cities and the lat and long of each city
bankcities <- read.csv("bankcities.txt", row.names=1, sep="")

# city dot map
map2 <- ggplot() + 
  # this plots the region polygons of Italy
  geom_polygon(data = itMap.f, aes(x = long, y = lat, group = group), fill = "#F1F2F1", linetype = 1, size = 0) + 
  # this plots a dot at each city sized according to log number of bank branches in the city
  geom_point(data=bankcities, aes(x = long, y = lat, fill = NULL, group = NULL), size = 4*log(bankcities$size), color = "cornflowerblue", alpha = .75) + 
  coord_map() + 
  theme(
    panel.background = element_rect(fill = "gray17", size = 0),
    line = element_line(linetype=0),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    title=element_text(size = 20)) + 
  labs(title = "Log Bank Density by City - Italy")

# displays maps
map1
map2
