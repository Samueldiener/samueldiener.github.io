library(plotly)

packageVersion('plotly')
#(devtools::install_github("ropensci/plotly"))

Sys.setenv("plotly_username"="sdiener")
Sys.setenv("plotly_api_key"="L9C7mwFnERZoAO42jHEz")
#I added an "authorID" column to the corpusmaster_id doc

#LLcmAuNum <- read.csv("C:/Users/Dienerkins/Desktop/WWP paper/sortingbox/corpusmaster_id_withLL_AuNum.csv")
LLcmAuNum <- read.csv("C:/Users/Dienerkins/Desktop/WWP paper/sortingbox/corpusmergedbyauthor.csv")



## THESE ARE NAs???
LLcmAuNum[is.na(LLcmAuNum$authorID),]
# drop NAs
LLcmAuNum <- LLcmAuNum[!is.na(LLcmAuNum$authorID),]

LLcmAuNum <- group_by(LLcmAuNum, authorID)

# geo styling
g <- list(
	scope = 'world',
	projection = list(type = 'mercator'),
	showland = TRUE,
	landcolor = toRGB("gray95"),
	subunitcolor = toRGB("gray85"),
	countrycolor = toRGB("gray85"),
	countrywidth = 0.5,
	subunitwidth = 0.5
)
#, color = I("#1f77b4")
# main plot
p <- plot_geo(LLcmAuNum, 
              width = 1200,
              height =800, 
              x=.4,
              size = c(1,500)) %>%
	add_markers(
		y = ~latitude, x = ~longitude, name= ~author, size = ~count+50, visible = "legendonly", color= ~authorID, colorscale='Viridis',
		reversescale =T, showscale=F,
		text = ~paste(DisplayName, 
		              paste(author,", references: ", count, sep = ""), 
		              paste("References by text: ", textCount), 
		              sep = "<br />"),
		symbol = I("circle"), span = I(1), hoverinfo = "text")

p <- add_annotations(p, 
                     text = "Authors: click<br />to select/unselect",
                     xref = "paper",
                     yref = "paper",
                     x = 0.9, 
                     xanchor = "left",
                     y = .99,
                     yanchor = "top",
                     legendtitle = TRUE,
                     showarrow = FALSE)

# other info
p <- 
	layout(p,
		title = paste('Individual Authors: Hover for name and count'), geo = g, showlegend = TRUE
	) %>% hide_colorbar()
p

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = api_create(p, filename = "Interactive Flat Map with Sizepins 8")
chart_link
