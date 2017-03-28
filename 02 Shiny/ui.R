#ui.R

require(shiny)
require(shinydashboard)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Hispanic or Latino in Population Income and Poverty Level vs. Median Income", tabName = "action", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "action",
              plotOutput("plot1",
              click = "plot_click",
              dblclick = "plot_dblclick",
              hover = "plot_hover",
              brush = "plot_brush"
      ),
      plotOutput("plot2")
      )
    )
  )
)

