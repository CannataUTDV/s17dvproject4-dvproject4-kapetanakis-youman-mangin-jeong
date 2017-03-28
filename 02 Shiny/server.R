require(dplyr)
require(ggplot2)
require("jsonlite")
require("RCurl")

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ",'oraclerest.cs.utexas.edu:5000/rest/native/?query="select Austin_Housing_Data.`Population.below.poverty.level`, Austin_Housing_Data.`Median.household.income`, Austin_Housing_Data.`Hispanic.or.Latino..of.any.race` from Austin_Housing_Data"')),httpheader=c(DB='jdbc:data:world:sql:stefkaps:s-17-edv-project-4', USER='jeongseongwoo', PASS='eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwcm9kLXVzZXItY2xpZW50Omplb25nc2Vvbmd3b28iLCJpc3MiOiJhZ2VudDpqZW9uZ3Nlb25nd29vOjo2MjE5NDYwNS0yNmQzLTQwZGQtODVlMy1mNDQ1MmIyYmJiZDciLCJpYXQiOjE0ODQ4NjgxNDUsInJvbGUiOlsidXNlcl9hcGlfd3JpdGUiLCJ1c2VyX2FwaV9yZWFkIl0sImdlbmVyYWwtcHVycG9zZSI6dHJ1ZX0.8UM3OeonNE9v-9r58lVu7K8lfrTfAXRqO7aUHPLPZAvMtOGD2KUUGa2CsPbtoHel-XL2veBk896xPK2Awi5L4g', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

colnames(df) <- c("Col1","Col2","Col3")


server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(df) + geom_point(aes(x=Col1, y=Col2, color = Col3, size = 1)) + scale_colour_gradient(high = "red", low = "yellow") + labs(title = "Hispanic or Latino in Population Income and Poverty Level", x = "Population Below Poverty Level", y = "Median Household Income", color = "Hispanic or Latino") + guides(size=FALSE)
  })

  
output$plot2 <- renderPlot({
  brush = brushOpts(id="plot_brush", delayType = "throttle", delay = 30)
  bdf=brushedPoints(df, input$plot_brush)
  if( !is.null(input$plot_brush) ) {
    df %>% dplyr::filter(Col1 %in% bdf[, "Col1"]) %>% ggplot() + geom_point(aes(x = Col1, y = Col2, colour=Col3, size=1)) + scale_colour_gradient(high = "red", low = "yellow") + labs(title = "Hispanic or Latino in Population Income and Poverty Level", x = "Population Below Poverty Level", y = "Median Household Income", color = "Hispanic or Latino") + guides(size=FALSE)
  } 
})
}