#Code in this file is for instructions page.

tags$div(style = "margin: 15px; 15px; 30px; width: 60%",
         HTML("<div style='display:inline-block;width:100%;padding:0;line-height: 0.72em; margin-top:5px; margin-bottom:5px;'>
                     <h3>Instructions</h3></div>",
              '<a class="btn btn-primary", href="Definitions.htm" target="_blank"  style="height:47px;margin: -54px 0px 0px 930px"> Open Instructions <br> in new browser tab</a>'
         ),
         #tags$h3('Instructions'), 
          tags$p('To use the Costs Explorer, make data selections in each of the fields in the Control Panel (this panel will only appear when you are on the',tags$em('Explore the data'), 'page).
          Output will be automatically generated when each of the fields in the Control Panel has at least one selection.', tags$br(), tags$br(),
          'A button to download the plot(s) and data table can be found at the bottom of the Control Panel. Download the data and analyze externally to generate plots and analyses beyond what is 
          provided in the Costs Explorer.',
          tags$br(),tags$br(),'To switch between viewing plots and data table, use the button above the plot or data output.'),
           tags$ul(style="margin-top:15px;" ,
                   
           tags$li(tags$h4("Summary Plots and Data")),
           tags$p('Visualize', tags$a(href="https://www.nwfsc.noaa.gov/research/divisions/fram/economic/overview.cfm",'Economic Data Collection (EDC)', target="_blank"), 'summary statistics for variable and fixed costs of 
                  catcher vessels (both at-sea and shoreside), mothership vessels, catcher-processor vessels, and first receivers and shorebased processors that participate in the',
                  tags$a(href="https://www.nwfsc.noaa.gov/research/divisions/fram/catch_shares.cfm", 'catch share program. ', target="_blank")),
                 
                tags$strong('Plots'),tags$p('Visualize costs data.', tags$br(),
                
                tags$em('Plot Options '),  'allows you to switch between bar, stacked bar, and line plots.'), 
           
                tags$strong("Data Table"),
              tags$p('View data used to generate the plots.', tags$br(), 'After a table has been displayed, the data can be filtered using the', tags$em('Search'), 'box, or filtered within a column using the boxes at the bottom of the table.'),
              tags$br(),
              tags$br(),
                
            
              tags$br())
)
              
