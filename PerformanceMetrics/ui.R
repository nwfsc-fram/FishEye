.libPaths(c("/usr/lib64/R/shiny_library", .libPaths()))

library(appFrame)
library(shinyjs)

# custom css functions
# calls .css selector for well-sub
wellPanelSub <- function(...){div(class = "well-sub", ...)}
# calls .css selector for radioButton header
wellPanelHeading <- function(...){div(class = "well-radioHeading", ...)} 

  
function(request) {
fluidPage(title = "FISHEyE",
          useShinyjs(),
          # create a CSS to modify style of validation test error (for Variability analysis)
          tags$head(tags$body(includeHTML("google-analytics.noaa.js"))),
          tags$head(
           tags$style(HTML(".shiny-output-error-validation {color: red;font-size: 120%;}")),
             tags$style(HTML(".select {margin-top:-20px}"),tags$textarea(id="message", rows=3, cols=40, "Default value")),
          #  tags$style(HTML(".navbar .nav > li { position:relative; z-index: 10000;}")),
            tags$style(HTML(".navbar {position:static}")),
            tags$style(HTML(".ckbox {margin-top: 0px; margin-bottom: -15px}")),
            tags$style(HTML(".statbox {margin-top: -30px; margin-bottom: -15px}")),
          
          tags$style(HTML(".ckboxCV .checkbox:nth-child(2) label{color:grey;} .checkbox.input:nth-child(2),
                           .ckboxCV .checkbox:nth-child(6) label{color:grey;} .checkbox.input:nth-child(6),
                           .ckboxCV .checkbox:nth-child(3) label{color:grey;} .checkbox.input:nth-child(3),
                           .ckboxCV2 .checkbox:nth-child(1) label{color:grey;} .checkbox.input:nth-child(1),
                           .ckboxCV2 .checkbox:nth-child(7) label{color:grey;} .checkbox.input:nth-child(7),
                           .ckboxCPFR .checkbox:nth-child(1) label{color:grey;} .checkbox.input:nth-child(1),
                           .ckboxCPFR .checkbox:nth-child(5) label{color:grey;} .checkbox.input:nth-child(5),
                           .ckboxCP .checkbox:nth-child(2) label{color:grey;} .checkbox.input:nth-child(2),
                           .ckboxFR .checkbox:nth-child(4) label{color:grey;} .checkbox.input:nth-child(4),
                           .ckboxSOC .checkbox:nth-child(2) label{color:grey;} .checkbox.input:nth-child(2),
                           .StatGrey .radio:nth-child(-n+2) label{color:grey;} .radio.input:nth-child(-n+2) {border: 0px; width: 0%; height:0em;}#"
                          )),
       
           tags$style(HTML(".StatGrey  .radio:first-child  input[type=radio],
                                            .StatGrey  .radio:nth-child(2) input[type=radio],
                                            .StatGrey2  .radio:nth-child(3) input[type=radio],
                                            .StatGrey3  .checkbox:nth-child(n+3) input[type=checkbox],
                                            .StatGrey4  .radio:nth-child(n+4) input[type=radio],
                                            .ckboxCV  .checkbox:nth-child(3)  input[type=checkbox],
                                            .ckboxCV  .checkbox:nth-child(2)  input[type=checkbox],
                                            .ckboxCV  .checkbox:nth-child(6)  input[type=checkbox],
                                            .ckboxCV2  .checkbox:nth-child(1)  input[type=checkbox],
                                            .ckboxCV2  .checkbox:nth-child(7)  input[type=checkbox],
                                            .ckboxCPFR  .checkbox:nth-child(1)  input[type=checkbox],
                                            .ckboxCPFR  .checkbox:nth-child(5)  input[type=checkbox],
                                            .ckboxCP  .checkbox:nth-child(2)  input[type=checkbox],
                                            .ckboxFR  .checkbox:nth-child(4)  input[type=checkbox],
                                            .ckboxSOC  .checkbox:nth-child(2)  input[type=checkbox] {border: 0px;    width: 0%;    height:0em;}#")),
             #Make checkbox and radio buttons bold    
            tags$style(HTML(".ckbox2 .checkbox:first-child label,
                                      .ckbox2 .checkbox:nth-child(2) label, 
                                      .ckbox2 .checkbox:nth-child(11) label,
                                      .ckbox3 .radio:nth-child(2) label,
                                      .ckbox3 .radio:nth-child(3) label,
                                      .ckbox3 .radio:nth-child(12) label,
                                      .rbutton .radio:nth-child(2) label,
                                      .rbutton .radio:nth-child(3) label, 
                                      .rbutton .radio:nth-child(10) label{font-weight:bold;}")),

            tags$style(HTML(".ckbox2 .checkbox:nth-child(-n+14) label,
                                      .ckbox3 .radio:nth-child(-n+15) label,
                                      .FRprod .checkbox:nth-child(4) label,
                                      .FRprod .checkbox:nth-child(3) label,
                                      .rbutton .radio:nth-child(-n+14) label,
                                      .rbutton2 .radio:nth-child(4) label,
                                      .rbutton2 .radio:nth-child(5) label{margin-left:17px;}
                             .ckbox2 .checkbox:nth-child(4) label,
                                     .ckbox2 .checkbox:nth-child(7) label,
                                     .ckbox2 .checkbox:nth-child(8) label,
                                     .ckbox2 .checkbox:nth-child(9) label,
                                     .ckbox2 .checkbox:nth-child(5) label,
                                     .ckbox3 .radio:nth-child(5) label,
                                     .ckbox3 .radio:nth-child(6) label,
                                     .ckbox3 .radio:nth-child(8) label,
                                     .ckbox3 .radio:nth-child(9) label,
                                     .ckbox3 .radio:nth-child(10) label{margin-left:34px;}
                            .ckbox2 .checkbox:nth-child(-n +2) label,
                                     .ckbox2 .checkbox:nth-child(11) label,
                                     .ckbox3 .radio:nth-child(-n+3) label,
                                     .ckbox3 .radio:nth-child(12) label,
                                     .rbutton .radio:nth-child(-n+3) label,
                                     .rbutton .radio:nth-child(10) label{margin-left:0px;}")),
 
          tags$style(HTML(".ckbox3 .radio:first-child label,
                                   .StatGrey4  .radio:first-child label,       
                                   .rbutton2 .radio:nth-child(1) label,
                                   .rbutton3 .radio:nth-child(1) label,
                                   .rbutton  .radio:nth-child(1) label{font-style:italic")), 
         
          tags$style(HTML(".StatGrey2 .radio:nth-child(3) label{color:grey;}")),
             
          #check boxes and radio buttons that are greyed out and not usuable (because the option is not available)       
            tags$style(HTML(".StatGrey3  .checkbox:nth-child(n+3) label{margin-left:17px;color:grey;} 
                                         .checkbox.input:nth-child(n+3) {border: 0px;    width: 0%;    height:0em;}")),
            tags$style(HTML(".StatGrey3  .checkbox:nth-child(5) label{margin-left:0px;color:grey;} 
                                         .checkbox.input:nth-child(5) {border: 0px;    width: 0%;    height:0em;}")),
            tags$style(HTML(".StatGrey4  .radio:nth-child(n+4) label{margin-left:17px;color:grey;} 
                                         .radio.input:nth-child(n+4) {border: 0px;    width: 0%;    height:0em;}")),
            tags$style(HTML(".StatGrey4  .radio:nth-child(6) label{margin-left:0px;color:grey;} .radio.input:nth-child(6) {border: 0px;    width: 0%;    height:0em;}")),
            
          
            #tags$style(HTML(".met_mod label{font-style:italic;margin-bottom:20px;margin-top:-90px;padding-top:0;}")),#{margin-top:-40px;margin-bottom:50px; height:12px;}
            tags$style(HTML(".met_mod  input[type=radio] {border: 0px;    width: 0%;    height:0em;}#")),
            tags$style(HTML(".sectselect >li{position:relative; z-index:10000; background-color:black !important; display:inline; vertical-align:middle;}")),
#            tags$style(HTML(".sectselect{font-size:28px; line-height:28px;}")),
            tags$style(HTML(".actbutton {margin-bottom:5px}")),
            tags$style(HTML(".rbutton {margin-top:15px}")),
            tags$style(HTML('#iof,
                             #isummed,
                             #ifg,
                             #istat,
                             #ipo,
                             #ivs,
                             #iem,
                             #ivariance,
                             #FRr,
                             #FRs,
                             #FRi,
                             #icompare,
                             #iwhiting{width:20px; height:19px; margin:0px;border:none; padding:0px;border-radius:25px;background-color:transparent;font-size:12px; 
                              color:RoyalBlue}'))),
#tags$style(HTML('#iVesSum{width:20px; height:19px; margin:0px;border:none; padding:0px;border-radius:25px;background-color:transparent;font-size:12px; color:RoyalBlue}
# java script 
          tags$style(type='text/css', "#data2, 
                                       #data  { background-color:RoyalBlue; color:white; height:37px;position:absolute;bottom:170%;left:425%;}"),
#{ background-color:RoyalBlue; color:white; height:37px;position:absolute;bottom:170%;left:425%;}          
           tags$head(includeScript("google-analytics.js")),
           tags$head(tags$script(src = "message-handler.js")),
          
           tags$head(
            # Main css page, downloaded from bootswatch
            tags$link(rel="stylesheet", type="text/css", href="bootstrap.css"),
            # secondary css page with fisheye specific attributes
            tags$link(rel="stylesheet", type="text/css", href="fisheye.css"),
            tags$link(rel="stylesheet", href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css"),
            tags$style(type="text/css", ".tab-content {overflow: visible;}")         
            ),
          
         # source("www/shiny_framebuster/framebuster.R")$value,
## example R framebusting code
          appFrameHeaderScrolling(),
### #-- Government Shutdown banner --- ###
#tags$div(class='header', #tags$syle(HTML('background-color:white;color:blue;width:auto; text-align:left;float:center;margin:0 auto; padding: 0.3em 0 0.5em;font-size:large">
#  tags$p("The Federal Government is closed. The site will not be updated; however NOAA websites and social media channels necessary to protect lives and property will be maintained. See", tags$a(href="https://www.weather.gov", "www.weather.gov."), "Learn more at", tags$a(href="https://noaa.gov", "NOAA.gov."))),
### #-- Government Shutdown banner --- ###
          fluidRow(div(style = "padding-bottom: 5px;margin-bottom:0"),
                   tags$h2(style = "margin-left: 15px", 
                     HTML("<div><p style='font-size:120%'><strong><a style='color:white; background-color:#1a5d99;  font-family:Cambria; border-radius:25px; padding:5px' 
                              href='https://dataexplorer.northwestscience.fisheries.noaa.gov/fisheye/'> FISHEyE</a>- Performance Metrics </strong></p> 
                            
                          </div>")), htmlOutput("SectPrint")
                  # ,uiOutput("SectorSelect")  
          ),# <p><i>West Coast Trawl Catch Share Program:</i></p>     
          navbarPage(id="page", collapsible=TRUE, inverse=F,
            title="",

         tabPanel("Explore the data", value="results",    
            sidebarLayout(
              mainPanel(         
                tabsetPanel(id = "tabs", selected='Panel1',
                            tabPanel(title=HTML("Summary Plots <br> and Data"), value="Panel1", padding='10px',
                                   fluidRow(column(12,'',
                                            fluidRow(column(12,
                                                    conditionalPanel(condition="input.VariableSelect==''",  
                                                                     tabsetPanel(tabPanel('Overview',
                                              fluidRow(
                                       column(12, htmlOutput("DefaultPlotText"))#,                                
                                     #  column(2, uiOutput("DataButton")),  
                                     #  column(2, uiOutput("VCNRButton")), 
                                    #   column(12, dataTableOutput("TableMain"), plotOutput("PlotMain", height="auto",width="auto"))
                                     )),
                            tabPanel('Get started',
                                     fluidRow(column(12, htmlOutput('GetStartedText')))))))))), 
                            conditionalPanel(condition="input.VariableSelect!=''",  
                              fluidRow(column(2, uiOutput("DataButton")),  
                                       column(12, dataTableOutput("TableMain"), 
                                                  plotOutput("PlotMain", height="auto",width="auto"#, hover=hoverOpts(id='plot_hover'),click=clickOpts(id='plot_click')
                                                        )
                                            # ,conditionalPanel(condition="input.Ind_sel=='Economic'",uiOutput('hover_info'),uiOutput('click_info'))
                            ))))
###--------------Case Study -------------------------------####
#                ,tabPanel(title='Case studies', value='Panel2', padding='10px',
#                         tags$h3('How does profitability compare between vessels with trawl gear and fixed gear in the catch share program?'),
#                         fluidRow(column(12, htmlOutput('CaseStudyp1')),
#                                  column(12,  actionButton("hideshow1", "Show/Hide VCNR plot", style='color:#fff; background-color:#5bc0de;border-color#:#46b8da')),
#                                  column(12, # conditionalPanel(condition="input.hideshow1 % 2 !=0 & values$shouldShow != TRUE", 
#                                         hidden(plotOutput("PlotMain2"))), 
#                                 
#                                   column(12, htmlOutput('CaseStudyp6')),
#                                 column(12,  actionButton("hideshow6", "Show/Hide Days at sea and VCNR/day plots", style='color:#fff; background-color:#5bc0de;border-color:#46b8da')),
#                                 column(12,  hidden(htmlOutput("CaseStudyFig5"))),
#                                 
#                                 column(12,  htmlOutput('CaseStudyp2')),       
#                                  column(12,  actionButton("hideshow2", "Show/Hide Thirds plot", style='color:#fff; background-color:#5bc0de;border-color:#46b8da')),
#                                  column(12,  #conditionalPanel(condition="input.hideshow2 % 2 !=0",  
#                                         hidden(htmlOutput('CaseStudyFig2'))),#tags$img(src="TrawlThirds.png", height=350))),
#                                  
#                                  #column(12,  actionButton("hideshow3", "Show/Hide TCNR plot for catcher vessels with trawl permit", style='color:#fff; 
#                                  #background-color:#5bc0de;border-color:#46b8da')),
#                                  #column(12,  hidden(plotOutput("PlotMain3"))),#htmlOutput('CaseStudyFig3'))),
#                                  column(12,  htmlOutput('CaseStudyp4')),
#                                  #column(12,  actionButton("hideshow4", "Show/Hide Thirds plot for Groundfish fixed gear with trawl endorsement fishery", style='color:#fff; 
#                                  #background-color:#5bc0de;border-color:#46b8da')),
#                                  column(12,  hidden(htmlOutput('CaseStudyFig3'))),
#                                 
#                                  column(12,  htmlOutput('CaseStudyp5')),
#                                  column(12,  actionButton("hideshow5", "Show/Hide Costs plot", style='color:#fff; background-color:#5bc0de;border-color:#46b8da')),
#                                 column(12,  hidden(htmlOutput("CaseStudyFig4")))
#                                 
#                                 
#                                  )
#)
###-----------End case study-------------------------------######
              )),
                            
                  sidebarPanel( 
                   wellPanel( 
                     tags$head(
                       tags$style(type="text/css", ".well{border: 0px transparent;}"
                       )),
                      fluidRow(
                        column(8, HTML("<p style = 'font-size: 160%'><strong>Control Panel </strong></p> <p style='font-size: 110%'><strong>Make selections in each of the panels below </strong></p>")),
                        column(4,
                               uiOutput("resetButton"),
                               uiOutput('Button'),
                               bookmarkButton())),#end fluidRow
                     
                     fluidRow(
                       column(12,uiOutput("SectorSelect"),
                              style = "background:white; padding:0px;margin-bottom:0px; border: 3px solid #D3D3D3;border-radius:10px;font-size:100%;")), 
                     #         uiOutput("resetButton"),
                     
                       fluidRow(
                         column(12,
                               uiOutput('Layoutselect'),style = "background:white; padding: 0px;margin:0px; border: 3px solid #D3D3D3;border-radius:10px;"
                               )),
                       fluidRow(
                       column(6,
                              uiOutput("Categoryselect"), style = "background:white; padding: 0px;margin:0px; border: 1px solid #D3D3D3;border-radius:1px;"
                          
                              ),
                       column(6, 
                              uiOutput("FishWhitingselect")), style = "background:white; padding: 0px;margin-bottom:10px; border: 3px solid #D3D3D3;border-radius:10px;"
                     ), #end fluid row
                    fluidRow(
                      column(12,
                             " ")),
                     fluidRow(
                       column(6,
                             # uiOutput("resetButton"),
                             # uiOutput('Button'),
                             # wellPanelSub(
                              #  wellPanelHeading(
                               #   uiOutput("CategorySelect")
                              #  )),
                               wellPanelSub(
                                    conditionalPanel(condition="input.Sect_sel=='CV'||
                                                     input.Sect_sel=='FR'&input.Ind_sel=='Economic'||
                                                     input.Sect_sel=='FR'&input.Ind_sel=='Demographic'&
                                                     input.demSelect!='Proportion of revenue from catch share species'",
                                                     uiOutput("SelectText")),
                                    uiOutput("Variableselect")
                                 
                              ),style = "padding-left:-15px;margin-left:-15px;margin-right:0px;padding-right:2px;"
                           ), #end column
                  
                      column(6,
                            #  wellPanelSub(
                            #    uiOutput("FishWhitingSelect")),
                              wellPanelSub(
                                conditionalPanel(condition="input.Ind_sel!='Economic'",
                                               uiOutput("StatSelect2")),
                                uiOutput("IndicatorSelect"),
                                uiOutput("Metricselect"),
                                conditionalPanel(condition="input.Ind_sel=='Demographic'",
                                    uiOutput("demselect")),
                                conditionalPanel(condition="input.Ind_sel=='Economic'",
                                    uiOutput("Shortdescrselect"),
                                    uiOutput("Statselect")),
                                conditionalPanel(condition="input.Ind_sel=='Social and Regional'",
                                    uiOutput("socselect"))

                                     ),#end sub panel
                             
                              wellPanelSub( 
                                  wellPanelSub(
                                  conditionalPanel(condition="input.LayoutSelect!='Metrics'&&input.Sect_sel=='CV'&&
                                                                        input.Ind_sel=='Demographic'&&
                                                                        input.demSelect=='Exponential Shannon Index'
                                                                    ||input.LayoutSelect!='Metrics'&&input.Sect_sel=='CV'&&
                                                                        input.Ind_sel=='Demographic'&&
                                                                        input.demSelect=='Proportion of revenue from CS fishery'
                                                                    ||input.LayoutSelect!='Metrics'&&input.Sect_sel=='CV'&&
                                                                        input.Ind_sel=='Demographic'&&
                                                                        input.demSelect=='Fishery participation'", 
                                                 uiOutput("FishAkselect")), style = "padding: 0px;margin-bottom:0px; border: 3px solid #D3D3D3;border-radius:10px;"),
                                  wellPanelSub(
                                  conditionalPanel(condition="input.Ind_sel!='Economic'&input.AVE_MED2!='Total'&
                                                              input.socSelect!='Seasonality'&
                                                              input.socSelect!='Share of landings by state'||
                                                              input.Ind_sel=='Economic'&input.AVE_MED!='T'",
                                                   uiOutput("Plotselect")), style = "padding: 0px;margin-bottom:0px; border: 3px solid #D3D3D3;border-radius:10px;")#,
                                     ) , #end sub panel
                              wellPanelSub(
                                
                                 uiOutput("Yearselect"),
                                 wellPanelSub(
                                    conditionalPanel(condition=
                                         "input.Sect_sel=='CV'&&input.CategorySelect!='Homeport'&&
                                                  input.CategorySelect!='State'&&
                                          input.CategorySelect!='Vessel length class'&&input.Ind_sel=='Economic'&&
                                                  input.ShortdescrSelect=='Revenue'||
                                          input.Sect_sel=='CV'&&input.CategorySelect!='Homeport'&&input.CategorySelect!='State'&&
                                          input.CategorySelect!='Vessel length class'&&input.Ind_sel=='Demographic'&&input.demSelect=='Gini coefficient'||
                                          input.Sect_sel!='FR'&&input.CategorySelect!='Homeport'&&input.CategorySelect!='State'&&
                                          input.CategorySelect!='Vessel length class'&&input.Ind_sel=='Demographic'&&input.demSelect=='Number of vessels'||
                                          input.Sect_sel=='CV'&&input.CategorySelect!='Homeport'&&input.CategorySelect!='State'&&
                                          input.CategorySelect!='Vessel length class'&&input.Ind_sel=='Demographic'&&input.demSelect=='Vessel length'||
                                          input.Sect_sel!='FR'&&input.CategorySelect!='Homeport'&&input.CategorySelect!='State'&&
                                          input.CategorySelect!='Vessel length class'&&input.Ind_sel=='Social and Regional'&&input.socSelect=='Seasonality'||
                                          input.Sect_sel!='FR'&&input.CategorySelect!='Homeport'&&input.CategorySelect!='State'&&
                                          input.CategorySelect!='Vessel length class'&&input.Ind_sel=='Social and Regional'&&input.socSelect=='Share of landings by state'",
                                    uiOutput('moreOptions')),
                                    style = "padding: 0px;margin-bottom:0px; border: 3px solid #D3D3D3;border-radius:10px;"#,
                                   #conditionalPanel(condition="",uiOutput('moreOptions'))#&&input.ShortdescrSelect=='Revenue'
                                                    )       
                                 ),
                            style = "padding-right:2px;margin-right:0px; padding-left:2px;,width:100%"
                             ),#end column
                        column(4,
                                wellPanel(uiOutput("download_figure"),
                                #tags$br(),
                                 uiOutput("download_Table")#,
                              ))
                       ) #end Fluid row
            ),      style = "padding: 0px;border: 1px solid #000000;") # end right side column

)),
        #tabPanel(HTML('History'), htmlOutput('HistoryText')),
        navbarMenu("Instructions",
                     tabPanel("About", 
                              source("external/explorer/explorerSourceFiles/about.R")$value
                     ),
                  
                      tabPanel("Instructions", 
                              source("external/explorer/explorerSourceFiles/instructions.R")$value
                     ),
                     tabPanel("Definitions", 
                              source("external/explorer/explorerSourceFiles/definitions.R")$value
                     )
            ), # end right side column     
          tabPanel(HTML('<i class="fa fa-thumb-tack" style="margin-right:2ex;display:inline-block;vertical-align:bottom;float:left;white-space:nowrap"> Bulletin Board</i>'),
                              fluidRow(
                                column(12, htmlOutput("BlogText")),
                                     column(5,  htmlOutput("BlogUpdates")),
                                     column(1),
                                column(5,  htmlOutput("BlogResponses")))),
           tabPanel(HTML('<i class="fa fa-envelope-o fa-fw" style="margin-right:9ex;display:inline-block;vertical-align:bottom;float:left;white-space:nowrap"> Contact us</i>'),
                   fluidRow(
                     column(12, htmlOutput("Email")))
                   ),
          tabPanel(HTML('<i class="fa fa-folder-open-o fa-fw" style="margin-right:18ex;display:inline-block;vertical-align:bottom;float:left;white-space:nowrap"> FISHEyE Applications</i>'),
                   fluidRow(
                     column(12, htmlOutput("ApplicationsText"))
                   )),
          tabPanel(HTML('<a class="btn btn-warning", href="http://dataexplorer.northwestscience.fisheries.noaa.gov/fisheye/"
                        style="height:37px;border-radius:25px;margin: -24px -50px; float:top;position:absolute;right:-100px;
                              font-familiy: Arial, Helvetica, sans-serif;font-size: 12pt; padding-top:7px;
                        padding-bottom:10px"> FISHEyE Homepage</a>' ),style='width:1000px')
          ), #end app level fluid row#, target="_blank"
          appFrameFooterScrolling()
) # end fluid Page
}