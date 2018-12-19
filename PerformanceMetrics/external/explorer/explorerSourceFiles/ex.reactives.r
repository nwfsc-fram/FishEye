#This file handles the reactive expressions for data management and statistical operations.

# creating the dat() reactive function that contains the user selected dataset
# The re-classification of data types can be transfered to the read-in file


DatMain <- reactive({ # data load moved to serverhead
  # data is loaded from serverHead.R load call
  if(input$Sect_sel=="CV"){
    dat <- CVperfmetrics
  } else if(input$Sect_sel=="M"){
    dat <- Mperfmetrics#[-which(Mperfmetrics$METRIC=='Days at sea'&Mperfmetrics$FISHAK=='TRUE'),]
  } else if(input$Sect_sel=="CP"){
    dat <- CPperfmetrics
  } else if(input$Sect_sel=="FR"){
    dat <- FRperfmetrics
  } 
})


DatVars <- reactive({
  # create a list of variable names used in the sidebar inputs
  dat <- DatMain()
  if(input$Sect_sel=="CV"){
    datVars <- with(dat, 
      list(
        YEAR = 2004:currentyear,
        SHORTDESCR = c("Revenue","Variable costs","Fixed costs","Variable Cost Net Revenue","Total Cost Net Revenue"),
        CATEGORY = c("Fisheries","Homeport","State of homeport"="State","Vessel length class"),
        FISHAK = unique(FISHAK),
        whitingv = c("All vessels","Non-whiting vessels","Whiting vessels"),
        STAT =  c("Mean per vessel","Mean per vessel/day","Mean per vessel/metric ton caught",
                  "Median per vessel","Median per vessel/day","Median per vessel/metric ton caught",
                  "Fleet-wide total","Fleet-wide average/day","Fleet-wide average/metric ton caught"),
        METRIC =  c("Number of vessels","Vessel length","Fishery participation","Proportion of revenue from catch share fishery"="Proportion of revenue from CS fishery",
                  "Days at sea","Exponential Shannon Index","Gini coefficient","Number of positions (captain and crew)"='Number of positions',"Crew wage per day","Revenue per position-day",
                  "Seasonality","Share of landings by state")
  ))
  } else if(input$Sect_sel=="FR"){
    datVars <- with(dat, 
                    list(
                      YEAR = 2004:currentyear,
                      SHORTDESCR = c("Revenue","Variable costs","Fixed costs","Variable Cost Net Revenue","Total Cost Net Revenue"),
                      CATEGORY = c("Production activities"="Fisheries","Region","Processor size"),
                      whitingv = c("All processors", "Whiting processors","Non-whiting processors"),
                      STAT =  c("Mean per processor","Mean per processor/metric ton of groundfish products produced"="Mean per processor/metric ton produced",
                                "Median per processor", "Median per processor/metric ton of groundfish products produced"="Median per processor/metric ton produced",
                                "Industry-wide total","Industry-wide average/metric ton of groundfish products produced"="Industry-wide average/metric ton produced"),
                      METRIC =  c("Number of processors","Number of species processed","Proportion of production value from West Coast groundfish"="Proportion of revenue from catch share species",
                                  "Exponential Shannon Index","Gini coefficient",'Number of workers',"Hourly compensation")#, "Share of landings by state")
                    ))
  }else if(input$Sect_sel=="M"|input$Sect_sel=="CP"){
      datVars <- with(dat, 
           list(
                YEAR = 2004:currentyear,
                SHORTDESCR = c("Revenue","Variable costs","Fixed costs","Variable Cost Net Revenue","Total Cost Net Revenue"),
                CATEGORY = "Fisheries",
                FISHAK = unique(FISHAK),
                whitingv = "Whiting vessels",
                STAT =  c("Mean per vessel","Mean per vessel/day","Mean per vessel/metric ton produced",
                          "Median per vessel","Median per vessel/day","Median per vessel/metric ton produced",
                            "Fleet-wide total",'Fleet-wide average/day','Fleet-wide average/metric ton produced'),
                METRIC =  c("Number of vessels","Vessel length",
                            "Proportion of landings from catch share fishery"="Proportion of landings from CS fishery","Days at sea","Gini coefficient",
                             "Number of positions (captain and crew)"='Number of positions',
                            "Crew wage per day", "Revenue per crew-day", "Seasonality")
                    ))
  }
})



# Subset data for table
# selecting plot variables, subsetting the data AND casting for individual level ID (fun.agg=sum)
# build dcast formula using if controls and using the quoted method in dcast
DatSubTable <- reactive({
    dat <- DatMain()      
    dat$SUMSTAT <- ifelse(dat$SUMSTAT=='Average', 'Mean', as.character(dat$SUMSTAT))
    dat$STAT <- ifelse(dat$STAT=="Average per vessel", "Mean per vessel",
                       ifelse(dat$STAT=="Average per vessel/day","Mean per vessel/day",
                              ifelse(dat$STAT=="Average per vessel/metric ton produced","Mean per vessel/metric ton produced",
                                     ifelse(dat$STAT=="Average per vessel/metric ton caught","Mean per vessel/metric ton caught",
                                            ifelse(dat$STAT=="Average per processor","Mean per processor",
                                                   ifelse(dat$STAT=="Average per processor/metric ton produced","Mean per processor/metric ton produced",as.character(dat$STAT)))))))
    dat$VARIABLE <- ifelse(dat$VARIABLE=='Small vessel (< 60 ft)', 'Small vessel (<= 60 ft)', as.character(dat$VARIABLE))
    
    #subsetting
    if(input$Sect_sel=="CV"|input$Sect_sel=="FR"){    
    datSub <- subset(dat, YEAR %in% seq(input$YearSelect[1], input$YearSelect[2], 1) &  
                       CATEGORY == input$CategorySelect &
                       VARIABLE %in% input$VariableSelect &
                       whitingv %in% input$FishWhitingSelect)
    } else {
      datSub <- subset(dat, YEAR %in% seq(input$YearSelect[1], input$YearSelect[2], 1))
    } 
    
   
    if(input$Ind_sel=="Demographic") {
      if(input$LayoutSelect!="Metrics"){
        #        if(input$MetricSelect!="Number of vessels"&input$MetricSelect!="Seasonality"&input$MetricSelect!="Share of landings by state"&input$MetricSelect!="Gini coefficient"){
        #           if(input$LayoutSelect!="Metrics"){}
        if(input$Sect_sel=="FR"){
          datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2) 
        }
        else if(input$demSelect[1]=="Exponential Shannon Index"|input$Sect_sel=="CV" &input$demSelect[1]=="Proportion of revenue from CS fishery"|input$Sect_sel=="CV" &input$demSelect[1]=="Fishery participation"){
          datSub <- subset(datSub,  METRIC%in%input$demSelect & SUMSTAT==input$AVE_MED2 &  FISHAK==input$FishAkSelect)
        } else if(input$Sect_sel=="CV" &input$demSelect[1]=="Days at sea"){
          datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT==input$AVE_MED2& FISHAK=='FALSE')
        }  else {
          datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2)
          }
      }  else {
        if(input$Sect_sel=="CV"){
          datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2 & FISHAK!='FALSE')
        } else if(input$Sect_sel=="FR") {
          datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2)
        } else {
          datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2 & FISHAK!='TRUE')
        }
      }
    } else if(input$Ind_sel=="Economic"){
      datSub <- subset(datSub,  SHORTDESCR %in% input$ShortdescrSelect & STAT == input$StatSelect)
    }else if(input$Ind_sel=="Social and Regional")  {
      if(input$LayoutSelect!="Metrics"){
        #        if(input$MetricSelect!="Number of vessels"&input$MetricSelect!="Seasonality"&input$MetricSelect!="Share of landings by state"&input$MetricSelect!="Gini coefficient"){
        if(input$socSelect!="Share of landings by state"&input$socSelect!="Seasonality"){
           datSub <- subset(datSub,  METRIC %in% input$socSelect & SUMSTAT == input$AVE_MED2 & !is.na(input$socSelect))
            
        }   else {
          datSub <- subset(datSub,  METRIC %in% input$socSelect & !is.na(input$socSelect))
        }} else {
          if(input$Sect_sel=="CV"){
            datSub <- subset(datSub,  METRIC %in% input$socSelect & SUMSTAT == input$AVE_MED2 & !is.na(input$socSelect)& FISHAK!='FALSE')
          } else if(input$Sect_sel=="FR") {
            datSub <- subset(datSub,  METRIC %in% input$socSelect & SUMSTAT == input$AVE_MED2 & !is.na(input$socSelect))
          } else {
            datSub <- subset(datSub,  METRIC %in% input$socSelect & SUMSTAT == input$AVE_MED2 & !is.na(input$socSelect)& FISHAK!='TRUE')
          }
        }
    }
 #    if(input$Ind_sel!="Economic")  {
#      if(input$MetricSelect!="Number of vessels"&input$MetricSelect!="date"&input$MetricSelect!="landings"&input$MetricSelect!="GINI"){
#        datSub <- subset(datSub,  METRIC %in% input$MetricSelect & !is.na(input$MetricSelect) & SUMSTAT == input$AVE_MED2)}
#      else {
#        datSub <- subset(datSub,  METRIC %in% input$MetricSelect& !is.na(input$MetricSelect) )
#      }}
#    if(input$Ind_sel!="Economic")  {
#      if(input$MetricSelect!="Number of vessels"&input$MetricSelect!="Seasonality"&input$MetricSelect!="Share of landings by state"&input$MetricSelect!="Gini coefficient"){
#        if(input$MetricSelect=="Exponential Shannon Index"|input$Sect_sel=="CV" &input$MetricSelect=="Proportion of revenue from CS fishery"|input$MetricSelect=="Fishery participation"|input$MetricSelect=="Days at sea"){
#          datSub <- subset(datSub,  METRIC %in% input$MetricSelect & SUMSTAT == input$AVE_MED2 & !is.na(input$MetricSelect)& FISHAK==input$FishAkSelect)
#        } else {
#          datSub <- subset(datSub,  METRIC %in% input$MetricSelect & SUMSTAT == input$AVE_MED2 & !is.na(input$MetricSelect))}
#      }   else {
#        datSub <- subset(datSub,  METRIC %in% input$MetricSelect & !is.na(input$MetricSelect))
#      }}
    
 
   
     datSub$VALUE <- round(as.numeric(as.character(datSub$VALUE)),2)
     datSub$VARIANCE <- round(as.numeric(as.character(datSub$VARIANCE)),2)
     datSub$q25 <- round(as.numeric(as.character(datSub$q25)),2)
     datSub$q75 <- round(as.numeric(as.character(datSub$q75)),2)
     datSub$N <- as.numeric(datSub$N)
#     datSub$PCHANGE <- as.numeric(datSub$PCHANGE)
 
#When to subset by CS (All fisheries, all CS fisheries, all non-CS fisheries)    
     if(input$Sect_sel=="CV" &input$CategorySelect != "Fisheries"){
       datSub <- subset(datSub, CS == input$inSelect)
     }
     if(input$Sect_sel=="FR"){
       if(!input$Ind_sel=='Demographic') {
         if(input$CategorySelect != "Fisheries") {
           datSub <- subset(datSub, CS == input$inSelect)}
       } else {
         if (input$CategorySelect != "Fisheries"&&input$demSelect!="Proportion of revenue from catch share species"){
           datSub <- subset(datSub, CS == input$inSelect)}
       }}
     
     
     if(input$Sect_sel=="FR"){
       datSub[datSub$METRIC!="Number of processors",'VALUE'] <- ifelse(datSub$N[datSub$METRIC!="Number of processors"]<3, NA, datSub$VALUE)
       datSub[datSub$METRIC!="Number of processors",'VARIANCE'] <- ifelse(datSub$N[datSub$METRIC!="Number of processors"]<3, NA, datSub$VARIANCE)
       datSub[datSub$METRIC!="Number of processors",'q25'] <- ifelse(datSub$N[datSub$METRIC!="Number of processors"]<3, NA, datSub$q25)
       datSub[datSub$METRIC!="Number of processors",'q75'] <- ifelse(datSub$N[datSub$METRIC!="Number of processors"]<3, NA, datSub$q75)
     } else {
     datSub[datSub$METRIC!="Number of vessels",'VALUE'] <- ifelse(datSub$N[datSub$METRIC!="Number of vessels"]<3, NA, datSub$VALUE)
     datSub[datSub$METRIC!="Number of vessels",'VARIANCE'] <- ifelse(datSub$N[datSub$METRIC!="Number of vessels"]<3, NA, datSub$VARIANCE)
     datSub[datSub$METRIC!="Number of vessels",'q25'] <- ifelse(datSub$N[datSub$METRIC!="Number of vessels"]<3, NA, datSub$q25)
     datSub[datSub$METRIC!="Number of vessels",'q75'] <- ifelse(datSub$N[datSub$METRIC!="Number of vessels"]<3, NA, datSub$q75)
     }
     
#    datSub$N <- ifelse(datSub$N<3, NA, datSub$N)
#    datSub$N <- ifelse(datSub$N>2&is.na(datSub$VALUE)==T, NA, datSub$N)
    datSub$VARIANCE <- ifelse(datSub$N>2&is.na(datSub$VALUE)==T, NA, datSub$VARIANCE)
    datSub$q25 <- ifelse(datSub$N>2&is.na(datSub$VALUE)==T, NA, datSub$q25)
    datSub$q75 <- ifelse(datSub$N>2&is.na(datSub$VALUE)==T, NA, datSub$q75)
    #datSub$FISHAK <- ifelse(datSub$FISHAK=="TRUE", "Vessels included", "Vessels not included")
   # datSub$whitingv <- ifelse(datSub$whitingv=="TRUE", "Vessels included", "Vessels not included") 
      
           validate(
         need(sum(!is.na(as.numeric(datSub$VALUE)))!=0, 
              paste('Sorry, the selected statistic is not available for the selected metric. Try selecting a different statistic.
                  ')))
       
  
           validate(
             need(datSub$METRIC!="Vessel length",
                  need(datSub$SUMSTAT!="Total", 
                       paste('Sorry, this plot could not be generated as total vessel length is not calculated. Try selecting the average or median statistic.
                             '))))
           
           validate(
             need(datSub$METRIC!="Exponential Shannon Index",
                  need(datSub$SUMSTAT!="Total", 
                       paste('Sorry, this plot could not be generated as the total exponential shannon index is not calculated. Try selecting the average or median statistic.
                             '))))
           
           validate(
             need(datSub$METRIC!="Fishery participation",
                  need(datSub$SUMSTAT!="Total", 
                       paste('Sorry, this plot could not be generated as the total fishery participation is not calculated. Try selecting the average or median statistic.
                  '))))
           
           validate(
             need(datSub$METRIC!="Number of vessels",
                  need(datSub$SUMSTAT!="Average"&datSub$SUMSTAT!="Median", 
                       paste('Sorry, this plot could not be generated as the average and median number of vessels are not calculated. Try selecting the total statistic.
                  '))))
           
           validate(
             need(datSub$METRIC!="Number of processors",
                  need(datSub$SUMSTAT!="Average"&datSub$SUMSTAT!="Median", 
                       paste('Sorry, this plot could not be generated as the average and median number of processors are not calculated. Try selecting the total statistic.
                  '))))
           
           validate(
             need(datSub$METRIC!="Gini coefficient",
                  need(datSub$SUMSTAT!="Average"&datSub$SUMSTAT!="Median", 
                       paste('Sorry, this plot could not be generated as the average and median Gini coefficient are not calculated. Try selecting the total statistic.
                  '))))
           validate(
             need(datSub$METRIC!="Hourly compensation",
                  need(datSub$SUMSTAT!="Total", 
                       paste('Sorry, this plot could not be generated as the total hourly compensation is not calculated. Try selecting the average or median statistic.
                  '))))
           
           validate(
             need(datSub$METRIC!="Crew wage per day",
                  need(datSub$SUMSTAT!="Total", 
                       paste('Sorry, this plot could not be generated as the crew wage per day is not calculated. Try selecting the average or median statistic.
                  '))))
           
           
    if(input$Ind_sel=="Social and Regional"){
      if(input$socSelect[1]=="Share of landings by state"){
      datSub$VALUE <- datSub$VALUE*100
      datSub$VARIANCE <- datSub$VARIANCE*100
      datSub$q25 <- datSub$q25*100
      datSub$q75 <- datSub$q75*100
    }
      } #else if(input$Ind_sel=="Demographic"){
#           if(input$demSelect=="Number of vessels"){
#             datSub$VALUE <- ifelse(datSub$N<3, NA, datSub$VALUE)
#             datSub$N <- ifelse(datSub$N<3, NA, datSub$N)
#           }
#      }     
           

#           datSub$VARIANCE <- ifelse(input$Ind_sel=="Economic"&input$AVE_MED=='T'||input$Ind_sel=="Economic"&input$AVE_MED=='A'||datSub$VARIANCE, paste(datSub$q25, ',', datSub$q75))
          datSub$VARIANCE <- if(input$Ind_sel!='Economic'){
             ifelse(datSub$SUMSTAT %in% c('Median'), paste(datSub$q25, ',', datSub$q75), datSub$VARIANCE)
           } else {
             ifelse(grepl('Median',datSub$STAT), paste(datSub$q25, ',', datSub$q75), datSub$VARIANCE)
             }
           
       
if(input$LayoutSelect!="Metrics"){   
   if(input$Ind_sel=="Demographic") {
           if(input$demSelect[1]=="Exponential Shannon Index"|input$demSelect[1]=="Fishery participation"| 
              input$Sect_sel=="CV"&input$demSelect[1]=="Proportion of revenue from CS fishery"
            ){
             if(input$Sect_sel!="FR"){
             datSub <- datSub[,c(which(colnames(datSub)=="YEAR"),which(colnames(datSub)=="VARIABLE"),which(colnames(datSub)=="CATEGORY"),which(colnames(datSub)=="CS")
                                 ,which(colnames(datSub)=="SUMSTAT"),
                                 which(colnames(datSub)=="METRIC"),which(colnames(datSub)=="whitingv"),which(colnames(datSub)=="FISHAK"),which(colnames(datSub)=="N"),
                                 which(colnames(datSub)=="VALUE"),which(colnames(datSub)=="VARIANCE"))]
             datSub$FISHAK <- ifelse(datSub$FISHAK=="TRUE","Included","Not included")
             } else {
               datSub <- datSub[,c(which(colnames(datSub)=="YEAR"),which(colnames(datSub)=="VARIABLE"),which(colnames(datSub)=="CATEGORY"),which(colnames(datSub)=="CS"),
                                   which(colnames(datSub)=="SUMSTAT"),
                                   which(colnames(datSub)=="METRIC"),which(colnames(datSub)=="whitingv"),which(colnames(datSub)=="N"),which(colnames(datSub)=="VALUE")
                                   ,which(colnames(datSub)=="VARIANCE"))]
             }
             }
          else if(input$demSelect=="Number of vessels"|input$demSelect=="Number of processors"){
             datSub <- datSub[,c(which(colnames(datSub)=="YEAR"),which(colnames(datSub)=="VARIABLE"),which(colnames(datSub)=="CATEGORY"),which(colnames(datSub)=="CS"),
                                 which(colnames(datSub)=="SUMSTAT"),
                            which(colnames(datSub)=="METRIC"),which(colnames(datSub)=="whitingv"),which(colnames(datSub)=="N"))]
            }else {
             datSub <- datSub[,c(which(colnames(datSub)=="YEAR"),which(colnames(datSub)=="VARIABLE"),which(colnames(datSub)=="CATEGORY"),which(colnames(datSub)=="CS"),
                                 which(colnames(datSub)=="SUMSTAT"),
                                 which(colnames(datSub)=="METRIC"),which(colnames(datSub)=="whitingv"),which(colnames(datSub)=="N"),which(colnames(datSub)=="VALUE"),
                                 which(colnames(datSub)=="VARIANCE"))]
           }}# End Demographic 
      else if(input$Ind_sel=="Economic") {
      datSub <- datSub[,c(which(colnames(datSub)=="YEAR"),which(colnames(datSub)=="VARIABLE"),which(colnames(datSub)=="CATEGORY"),which(colnames(datSub)=="CS"),
                          which(colnames(datSub)=="STAT"),which(colnames(datSub)=="SHORTDESCR"),which(colnames(datSub)=="whitingv"),which(colnames(datSub)=="N"),
                        which(colnames(datSub)=="VALUE"),which(colnames(datSub)=="VARIANCE"))]
      } else if(input$Ind_sel=="Social and Regional") {
        if(input$socSelect=="Share of landings by state"){
          datSub <- datSub[,c(which(colnames(datSub)=="YEAR"),which(colnames(datSub)=="VARIABLE"),which(colnames(datSub)=="CATEGORY"),which(colnames(datSub)=="CS"),
                              which(colnames(datSub)=="SUMSTAT"),
                          which(colnames(datSub)=="METRIC"),which(colnames(datSub)=="whitingv"),which(colnames(datSub)=="N"),which(colnames(datSub)=="VALUE"),
                          which(colnames(datSub)=="AGID"))]
        }else {
          datSub <- datSub[,c(which(colnames(datSub)=="YEAR"),which(colnames(datSub)=="VARIABLE"),which(colnames(datSub)=="CATEGORY"),which(colnames(datSub)=="CS"),
                              which(colnames(datSub)=="SUMSTAT"),
                          which(colnames(datSub)=="METRIC"),which(colnames(datSub)=="whitingv"),which(colnames(datSub)=="N"),which(colnames(datSub)=="VALUE"),
                          which(colnames(datSub)=="VARIANCE"))]
        }}
 } # Compare vessels
##I think this is where I need to trouble shoot##Ashley###      
  else if(input$LayoutSelect=="Metrics"){
    if(input$Ind_sel=="Economic") {
      datSub <- datSub[,c(which(colnames(datSub)=="YEAR"),which(colnames(datSub)=="VARIABLE"),which(colnames(datSub)=="CATEGORY"),which(colnames(datSub)=="CS"),
                          which(colnames(datSub)=="STAT"),
                        which(colnames(datSub)=="SHORTDESCR"),which(colnames(datSub)=="whitingv"),which(colnames(datSub)=="N"),which(colnames(datSub)=="VALUE"),
                        which(colnames(datSub)=="VARIANCE"))]
    } else {
      datSub <- datSub[,c(which(colnames(datSub)=="YEAR"),which(colnames(datSub)=="VARIABLE"),which(colnames(datSub)=="CATEGORY"),which(colnames(datSub)=="CS"),
                          which(colnames(datSub)=="SUMSTAT"),
                      which(colnames(datSub)=="METRIC"),which(colnames(datSub)=="whitingv"),which(colnames(datSub)=="N"),which(colnames(datSub)=="VALUE"),
                      which(colnames(datSub)=="VARIANCE"))]
  }}
     if(input$Ind_sel!="Economic"){
             if(input$LayoutSelect=="Metrics"){
                  if(input$AVE_MED2=="Average"|input$AVE_MED2 == 'Mean' | input$AVE_MED2=="Median"){
                      if(table(table(datSub$METRIC)>1)[2]>1){
                      datSub <- subset(datSub,  !METRIC %in% c("Number of vessels","Gini coefficient","Number of processors"))
                  }}
                  else if(input$AVE_MED2=="Total"){
                      if(table(table(datSub$METRIC)>1)[2]>1){
                      datSub <- subset(datSub,  !METRIC %in% c("Vessel length","Exponential Shannon Index","Fishery participation","Hourly compensation",'Crew wage per day'))
                  }}
               else {
                  datSub
               }
      }} 
  
  
        validate(
           need(dim(datSub)[1]>0, 
                if(input$Sect_sel!="FR"){
               paste('Sorry, this output could not be generated as no vessels matched your selections. Try selecting a different variable.')
                } else {
                  paste('Sorry, this output could not be generated as no processors matched your selections. Try selecting a different variable.')
                }
               ))
              return(datSub)

})


# selecting plot variables, subsetting the data AND casting for individual level ID (fun.agg=sum)
# build dcast formula using if controls and using the quoted method in dcast
DatSub <- reactive({
      dat <- DatMain()   
      dat$SUMSTAT <- ifelse(dat$SUMSTAT=='Average', 'Mean', as.character(dat$SUMSTAT))

      dat$STAT <- ifelse(dat$STAT=="Average per vessel", "Mean per vessel",
                         ifelse(dat$STAT=="Average per vessel/day","Mean per vessel/day",
                                ifelse(dat$STAT=="Average per vessel/metric ton produced","Mean per vessel/metric ton produced",
                                       ifelse(dat$STAT=="Average per vessel/metric ton caught","Mean per vessel/metric ton caught",
                                              ifelse(dat$STAT=="Average per processor","Mean per processor",
                                                     ifelse(dat$STAT=="Average per processor/metric ton produced","Mean per processor/metric ton produced",as.character(dat$STAT)))))))
      dat$VARIABLE <- ifelse(dat$VARIABLE=='Small vessel (< 60 ft)', 'Small vessel (<= 60 ft)', as.character(dat$VARIABLE))
    
        if(input$Sect_sel=="CV"|input$Sect_sel=='FR'){    
        datSub <- subset(dat, YEAR %in% seq(input$YearSelect[1], input$YearSelect[2], 1) &  
                            CATEGORY == input$CategorySelect &
                            VARIABLE %in% input$VariableSelect &
                            whitingv %in% input$FishWhitingSelect)
      } else {
        datSub <- subset(dat, YEAR %in% seq(input$YearSelect[1], input$YearSelect[2], 1))
      }
      
      if(input$Ind_sel=="Economic") {
                datSub <- subset(datSub,  SHORTDESCR %in% input$ShortdescrSelect & STAT == input$StatSelect) 
     } else if(input$Ind_sel=="Demographic")  {
        if(input$LayoutSelect!="Metrics"){
             if(input$Sect_sel=='FR'){
              datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2)
            }
            else if(input$demSelect[1]=="Exponential Shannon Index"|input$Sect_sel=="CV" &input$demSelect[1]=="Proportion of revenue from CS fishery"|
                    input$Sect_sel=="CV" &input$demSelect[1]=="Fishery participation"){
              datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT==input$AVE_MED2& FISHAK==input$FishAkSelect)
            } else if(input$Sect_sel=="CV" &input$demSelect[1]=="Days at sea"){
              datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT==input$AVE_MED2& FISHAK=='FALSE')
              }else {
              datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2 )}
            } else {
            if(input$Sect_sel=="CV"){
              datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2 & FISHAK!='FALSE')
            } else if(input$Sect_sel=="FR") {
              datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2)
            } else {
              datSub <- subset(datSub,  METRIC %in% input$demSelect & SUMSTAT == input$AVE_MED2 & FISHAK!='TRUE')
            }
          }
      } else if(input$Ind_sel=="Social and Regional")  {
        if(input$LayoutSelect!="Metrics"){
#        if(input$MetricSelect!="Number of vessels"&input$MetricSelect!="Seasonality"&input$MetricSelect!="Share of landings by state"&input$MetricSelect!="Gini coefficient"){
          if(input$socSelect!="Share of landings by state"){
 #           if(input$LayoutSelect!="Metrics"){}
            if(input$Sect_sel=='FR'){
              datSub <- subset(datSub,  METRIC %in% input$socSelect & SUMSTAT == input$AVE_MED2)
            }
             else {
            datSub <- subset(datSub,  METRIC %in% input$socSelect & SUMSTAT == input$AVE_MED2)
            }
          }   else {
          datSub <- subset(datSub,  METRIC %in% input$socSelect & !is.na(input$socSelect))
          }} else {
            if(input$Sect_sel=="CV"){
          datSub <- subset(datSub,  METRIC %in% input$socSelect & SUMSTAT == input$AVE_MED2 & FISHAK!='FALSE')
            }else if(input$Sect_sel=="FR") {
              datSub <- subset(datSub,  METRIC %in% input$socSelect & SUMSTAT == input$AVE_MED2)
            } else {
              datSub <- subset(datSub,  METRIC %in% input$socSelect & SUMSTAT == input$AVE_MED2 & FISHAK!='TRUE')
            }
                  }
      } #End Social and Regional
      
          
        validate(
        need(dim(datSub)[1]>0, 
             if(input$Sect_sel!="FR"){
               paste('Sorry, this plot could not be generated as no vessels matched your selections. Try selecting a different variable.')
             } else {
               paste('Sorry, this plot could not be generated as no processors matched your selections. Try selecting a different variable.')
             }
        ))
      
      validate(
        need(datSub$METRIC!="Vessel length",
             need(datSub$SUMSTAT!="Total", 
             paste('Sorry, this plot could not be generated as total vessel length is not calculated. Try selecting the mean or median statistic.
                  '))))
 
      validate(
        need(datSub$METRIC!="Exponential Shannon Index",
             need(datSub$SUMSTAT!="Total", 
                  paste('Sorry, this plot could not be generated as the total exponential shannon index is not calculated. Try selecting the mean or median statistic.
                  '))))
 
      validate(
        need(datSub$METRIC!="Fishery participation",
             need(datSub$SUMSTAT!="Total", 
                  paste('Sorry, this plot could not be generated as the total fishery participation is not calculated. Try selecting the mean or median statistic.
                  '))))
      
      validate(
        need(datSub$METRIC!="Number of vessels",
             need(datSub$SUMSTAT!="Mean"&datSub$SUMSTAT!="Median", 
                  paste('Sorry, this plot could not be generated as the mean and median number of vessels are not calculated. Try selecting the total statistic.
                  '))))

      validate(
        need(datSub$METRIC!="Number of processors",
             need(datSub$SUMSTAT!="Mean"&datSub$SUMSTAT!="Median", 
                  paste('Sorry, this plot could not be generated as the mean and median number of processors are not calculated. Try selecting the total statistic.
                  '))))
      
      validate(
        need(datSub$METRIC!="Gini coefficient",
                     need(datSub$SUMSTAT!="Mean"&datSub$SUMSTAT!="Median", 
                  paste('Sorry, this plot could not be generated as the mean and median Gini coefficient are not calculated. Try selecting the total statistic.
                  '))))
      validate(
        need(datSub$METRIC!="Hourly compensation",
             need(datSub$SUMSTAT!="Total", 
                  paste('Sorry, this plot could not be generated as the total hourly compensation is not calculated. Try selecting the mean or median statistic.
                  '))))

      validate(
        need(datSub$METRIC!="Crew wage per day",
             need(datSub$SUMSTAT!="Total", 
                  paste('Sorry, this plot could not be generated as the crew wage per day is not calculated. Try selecting the mean or median statistic.
                  '))))
      

      if(input$Sect_sel=="CV" &input$CategorySelect != "Fisheries"){
              datSub <- subset(datSub, CS == input$inSelect)
      }
      if(input$Sect_sel=="FR"){
        if(input$Ind_sel !='Demographic') {
          if(input$CategorySelect != "Fisheries") {
              datSub <- subset(datSub, CS == input$inSelect)}
        } else {
          if (input$CategorySelect != "Fisheries"&&input$demSelect!="Proportion of revenue from catch share species"){
              datSub <- subset(datSub, CS == input$inSelect)}
        }}
 
      datSub$N <- as.numeric(datSub$N)
      datSub$VALUE <- as.numeric(datSub$VALUE)
      datSub$VARIANCE <- as.numeric(datSub$VARIANCE)
    
       validate( 
        need(max(datSub$N, na.rm=T)>2, 
             if(input$Sect_sel!='FR'){
             paste('Sorry, this plot could not be generated as data has been suppressed to protect confidentiality. 
                  Try selecting "All fisheries" in the "Show data summed across these fisheries" button or a different variable.')
             } else {
               paste('Sorry, this plot could not be generated as data has been suppressed to protect confidentiality. 
                  Try selecting "All processors" in the "Show data summed across:" checkbox option or a different variable.')    
               }
             ))
       validate(
           need(sum(!is.na(as.numeric(datSub$VALUE)))!=0, 
                   paste('Sorry, the selected statistic is not available for the selected metric. Try selecting a different statistic.
                  ')))
              
      if(input$Ind_sel=='Demographic'){
        datSub$VALUE <- datSub$VALUE
        datSub$VARIANCE <- datSub$VARIANCE
        datSub$q25 <- datSub$q25
        datSub$q75 <- datSub$q75
      }else if(input$Ind_sel=="Social and Regional") {
          if(input$socSelect=="Revenue per crew-day" |
             input$socSelect=="Crew wage per day" |
             input$socSelect=="Revenue per position-day"){
          datSub$VALUE <- datSub$VALUE/1000
          datSub$VARIANCE <- datSub$VARIANCE/1000  
          datSub$q25 <- datSub$q25/1000
          datSub$q75 <- datSub$q75/1000
      } else if(input$socSelect=="Share of landings by state"){
          datSub$VALUE <- datSub$VALUE*100
          datSub$VARIANCE <- datSub$VARIANCE*100
      } else {
          datSub$VALUE <- datSub$VALUE
          datSub$VARIANCE <- datSub$VARIANCE
          datSub$q25 <- datSub$q25
          datSub$q75 <- datSub$q75
      }}
     else if(input$Ind_sel=="Economic"&input$StatSelect!='Mean per vessel/metric ton caught'&input$StatSelect!='Median per vessel/metric ton caught'&input$StatSelect!='Fleet-wide average/metric ton caught'&
         input$StatSelect!='Mean per processor/metric ton produced'&input$StatSelect!='Median per processor/metric ton produced'&input$StatSelect!='Industry-wide average/metric ton produced'){
          datSub$VALUE <-datSub$VALUE/1000
          datSub$VARIANCE <- datSub$VARIANCE/1000
          datSub$q25 <- datSub$q25/1000
          datSub$q75 <- datSub$q75/1000
        } else {
        datSub$VALUE <- datSub$VALUE
        datSub$VARIANCE <- datSub$VARIANCE
        datSub$q25 <- datSub$q25
        datSub$q75 <- datSub$q75
      }
              
      # order for plotting
#      datSub$SHORTDESCR <- factor(datSub$SHORTDESCR, 
#        levels = factorOrder$shortdescr)
 
      if(input$Sect_sel=="CV"){
        if(input$CategorySelect == "Homeport"){
        datSub$VARIABLE <- factor(datSub$VARIABLE, levels = factorOrder$port)
      } else if(input$CategorySelect == "State"){
        datSub$VARIABLE <- factor(datSub$VARIABLE, levels = factorOrder$state)
      } else if(input$CategorySelect == "Fisheries"){
        
        datSub$VARIABLE <- factor(datSub$VARIABLE, levels = c("All fisheries",'All catch share fisheries combined'='All catch share fisheries','Pacific whiting',"At-sea Pacific whiting","Shoreside Pacific whiting",
                                                              'Groundfish with trawl gear',"DTS trawl with trawl endorsement","Non-whiting midwater trawl","Non-whiting, non-DTS trawl with trawl endorsement",  "Groundfish fixed gear with trawl endorsement",
                                                              "All non-catch share fisheries combined"="All non-catch share fisheries", "Groundfish fixed gear with fixed gear endorsement","Crab","Shrimp","Other fisheries"))
        }} else if(input$Sect_sel=="FR"){
                if(input$CategorySelect == "Region"){
                datSub$VARIABLE <- factor(datSub$VARIABLE, levels = c('Washington and Oregon','California'))
                } else if(input$CategorySelect == "Fisheries"){
                datSub$VARIABLE <- factor(datSub$VARIABLE, levels = c("All production","Groundfish production","Pacific whiting production","Non-whiting groundfish production","Other species production"))
                } else if(input$CategorySelect == "Processor size") {
                  datSub$VARIABLE <- factor(datSub$VARIABLE, levels =c("Small","Medium","Large"))
                }
           } else {
        datSub$VARIABLE <- "At-sea Pacific whiting"
        }
              
      
      if(input$Ind_sel=="Social and Regional"){
        if(input$socSelect!="Share of landings by state"){
        if(length(input$VariableSelect)>1){
         datSub$star <- ifelse(is.na(datSub$VALUE)==T, "*", "")
         datSub$VARIANCE <- ifelse(is.na(datSub$VARIANCE)==T, 0, datSub$VARIANCE)
#        datSub$con_flag <- ifelse(datSub$con_flag==1, 0, datSub$con_flag)
      }
      else if(length(input$VariableSelect)==1){
        datSub$star <- ""
      }}} else { datSub$star <- ""}
         datSub$VARIANCE <- ifelse(datSub$N<3, NA, datSub$VARIANCE)
         if(!"Number of processors" %in% datSub$METRIC){
         datSub$VALUE <- ifelse(datSub$N<3, NA, datSub$VALUE)
         }

   if(input$LayoutSelect!="Metrics"){
        if(input$Ind_sel=='Social and Regional'&&input$socSelect=='Share of landings by state'){
            datSub$sort <- as.character(datSub$AGID)
          } else {
            if(input$Sect_sel=="CV"){
            if(input$CategorySelect=="Fisheries"){
            datSub$sort <- ifelse(datSub$VARIABLE=="All fisheries", 1, 
                                  ifelse(datSub$VARIABLE=="All catch share fisheries", 2, 
                                        ifelse(datSub$VARIABLE=="Pacific whiting", 3,  
                                               ifelse(datSub$VARIABLE=="At-sea Pacific whiting", 4,  
                                                     ifelse(datSub$VARIABLE=="Shoreside Pacific whiting", 5,  
                                                            ifelse(datSub$VARIABLE=="Groundfish with trawl gear", 6,  
                                                                   ifelse(datSub$VARIABLE=="DTS trawl with trawl endorsement", 7, 
                                                                          ifelse(datSub$VARIABLE=="Non-whiting midwater trawl", 8,  
                                                                                 ifelse(datSub$VARIABLE=="Non-whiting, non-DTS trawl with trawl endorsement", 9,  
                                                                                        ifelse(datSub$VARIABLE=="Groundfish fixed gear with trawl endorsement", 10,  
                                                                                               ifelse(datSub$VARIABLE=="All non-catch share fisheries", 11,  
                                                                                                       ifelse(datSub$VARIABLE=="Other fisheries", 12,  
                                                                                                               ifelse(datSub$VARIABLE=="Crab", 13,  
                                                                                                                      ifelse(datSub$VARIABLE=="Shrimp", 14,  15
                                                                                                                             ))))))))))))))
            } else if(input$CategorySelect == "Homeport") {
            datSub$sort <- ifelse(datSub$VARIABLE=="Puget Sound", 1,                
                                  ifelse(datSub$VARIABLE=="South and central WA coast", 2, 
                                         ifelse(datSub$VARIABLE=="Astoria", 3,                  
                                                ifelse(datSub$VARIABLE=="Tillamook", 4,                  
                                                       ifelse(datSub$VARIABLE=="Newport", 5,                   
                                                              ifelse(datSub$VARIABLE=="Coos Bay",6,                   
                                                                     ifelse(datSub$VARIABLE=="Brookings",7,         
                                                                            ifelse(datSub$VARIABLE=="Crescent City", 8,           
                                                                                   ifelse(datSub$VARIABLE=="Eureka", 9,                    
                                                                                          ifelse(datSub$VARIABLE=="Fort Bragg", 10,                
                                                                                                 ifelse(datSub$VARIABLE=="San Francisco", 11, 12
                                                                                                        )))))))))))              
            } else {
            datSub$sort <- datSub$VARIABLE 
            }
        }# End CV
        else if(input$Sect_sel=='FR'){
            if(input$CategorySelect=="Fisheries"){
              datSub$sort <- ifelse(datSub$VARIABLE=="All production",1, 
                                      ifelse(datSub$VARIABLE=="Non-whiting groundfish production", 2, 
                                              ifelse(datSub$VARIABLE=="Pacific whiting production", 3, 4)))
            } else if(input$CategorySelect == "Region"){
              datSub$sort <- ifelse(datSub$VARIABLE=="Washington and Oregon", 1, 2)
            } else {
              datSub$sort <- as.character(datSub$VARIABLE)
            }
        } #end FR
        else {datSub$sort <- "At-sea Pacific whiting"
        } #end MS and CP  
          }#end not social and regional
    } #end not Metrics
      else {
        if(input$Ind_sel=="Economic"){
      datSub$sort <- ifelse(datSub$SHORTDESCR=="Revenue", 1, 
                              ifelse(datSub$SHORTDESCR=="Variable costs", 2, 
                                    ifelse(datSub$SHORTDESCR=="Fixed costs", 3, 
                                            ifelse(datSub$SHORTDESCR=="Variable Cost Net Revenue", 4,  5))))
       # }  else if(input$MetricSelect=="Share of landings by state"){
        #  datSub$sort <- ifelse(datSub$agid=="In Washington", "...In Washington", as.character(datSub$agid))
        #  datSub$sort <- ifelse(datSub$agid=="In Oregon", "..In Oregon", as.character(datSub$sort))
        #  datSub$sort <- ifelse(datSub$agid=="In California", ".In California", as.character(datSub$sort))
        #  datSub$sort <- ifelse(datSub$agid=="At sea", ".At sea",  as.character(datSub$sort))
        } else {
       datSub$sort <- as.character(datSub$METRIC)
     }}
        
      datSub$whitingv <- if(input$Sect_sel=='FR'){
        factor(datSub$whitingv, levels=c("Whiting processors","Non-whiting processors","All processors"))
      } else {
        factor(datSub$whitingv, levels=c("Whiting vessels","Non-whiting vessels","All vessels"))
      }
#      if(input$Ind_sel!="Economic"&input$MetricSelect=="Number of vessels"){
#        if(input$Ind_sel=="Demographic"&input$demSelect=="Number of vessels"){
#          datSub$star <- ifelse(datSub$N<3, "*", datSub$star)
#        datSub$VALUE <- ifelse(datSub$N<3, NA, datSub$VALUE)
#        datSub$N <- ifelse(datSub$N<3, NA, datSub$N)
#      }
      datSub$flag <- max(datSub$flag, na.rm=T)
      datSub$metric_flag <- max(datSub$metric_flag, na.rm=T)
      datSub$conf <- ifelse(datSub$CS=="All fisheries", 0, datSub$conf)
      datSub$conf <- max(datSub$conf, na.rm=T)
 
#      if(input$Ind_sel=="Demographic"&input$demSelect=="Number of vessels"){#    if(datSub$METRIC=="Number of vessels"){
#        datSub$VALUE <- ifelse(datSub$N<3, NA, datSub$VALUE)
#        datSub$N <- ifelse(datSub$N<3, NA, datSub$N)
#      }
      
      if(input$LayoutSelect=="Metrics"){
         if(input$AVE_MED2!="Total"){
           if(table(table(datSub$METRIC)>1)[2]>1){
          datSub <- subset(datSub,  !METRIC %in% c("Number of vessels","Gini coefficient","Number of processors"))
         }}}else {
          datSub
         }

      if(input$LayoutSelect=="Metrics"){
        if(input$AVE_MED2=="Total"){
          if(table(table(datSub$METRIC)>1)[2]>1){
            datSub <- subset(datSub,  !METRIC %in% c("Vessel length","Exponential Shannon Index","Fishery participation","Hourly compensation",'Crew wage per day'))
          }}}else {
            datSub
          }

      #      datSub$YEAR2 <- factor(datSub$YEAR, levels = min(DatSub$YEAR), max(datSub$YEAR))
      
    
      return(datSub)
          
  #   } else return()
#   )
})




PermitPlot <- reactive({
 
  if(!(is.null(input$YearSelect) | is.null(input$CategorySelect) | 
       is.null(input$VariableSelect))){
    if(!(input$YearSelect[1]=="" | 
         input$CategorySelect[1] == "" | input$VariableSelect[1] == "")){      
      x <- TRUE
    } else {
      x <- FALSE
    }
  } else x <- FALSE
  x
 
})

#PermitMessage <- reactive({
#  if(!(is.null(input$YearSelect) | is.null(input$CategorySelect) | 
#       is.null(input$VariableSelect))){
#    if(any(grepl(2009, input$YearSelect))){
#      if(any(grepl("Groundfish fixed gear with trawl endorsement",input$VariableSelect))
#      ){      
#        x <- TRUE
#      } else {
#        x <- FALSE
#      }
#    } else x <- FALSE
#  } else x <- FALSE
#  x
#})

#Download buttons only shows up if PermitPlot()==T
output$download_Table <- renderUI({
  if(PermitPlot()) {
    tags$div(class="actbutton",downloadButton("dlTable", "Download Data Table",class = "btn btn-info"))
#    tags$div(actionButton("", "Download Data Table coming soon",class = "btn btn-info"))
    #    }
  }
})

output$download_figure <- renderUI({
  if(PermitPlot()){
    tags$div(class="actbutton",downloadButton("dlFigure", "Download Plot(s)",class = "btn btn-info"))
#    tags$div(actionButton("", "Download Plot(s) coming soon",class = "btn btn-info"))
  }
})

output$resetButton <- renderUI({
  if(PermitPlot()){
    tags$div(class="actbutton",actionButton("reset_input", HTML("<strong>Clear selections & <br> Return to Instructions</strong>"), class="btn btn-info"))
  }
})

#Show Plot/Show data buttons
vars = reactiveValues(counter = 0.5)
output$DataButton <- renderUI({
  if(PermitPlot()){
    actionButton("data", label = label()) }
})

observe({
  if(!is.null(input$data)){
    input$data
    isolate({
      vars$counter <- vars$counter + .5
    })
  }
})

label <- reactive({
  if(!is.null(input$data)){
    if(vars$counter%%2 != 0) label <- "Show Data"
    else label <- "Show Plot(s)"
  }
})



vars2 = reactiveValues(counter = 0.5)
output$DataButton2 <- renderUI({
  if(PermitPlot()){
    actionButton("data2", label = label2())
  }
})

observe({
  if(!is.null(input$data2)){
    input$data2
    isolate({
      vars2$counter <- vars2$counter + .5
    })
  }
})

label2 <- reactive({
  if(!is.null(input$data2)){
    if(vars2$counter%%2 != 0) label2 <- "Show Data"
    else label2 <- "Show Plot(s)"
  }
})


###-------------Case study buttons --------------------------###
#values <- reactiveValues(shouldShow = FALSE)
#observeEvent(input$hideshow2, {
#    values$shouldShow = TRUE
#})

vars3 = reactiveValues(counter = 0.5)
observeEvent(input$hideshow1, {
  toggle("PlotMain2")
#  hide('CaseStudyFig2')
#  hide('PlotMain3')
#  isolate({
#    vars3$counter <- vars3$counter + .5
#  })
})
vars4 = reactiveValues(counter = 0.5)
observeEvent(input$hideshow2, {
  toggle('CaseStudyFig2')
#  hide('PlotMain2') 
#  hide('PlotMain3')
  })
observeEvent(input$hideshow3, {
toggle('PlotMain3')
  #  toggle('CaseStudyFig3')
#  hide('PlotMain2') 
##  isolate({
#    vars4$counter <- vars4$counter + .5
#  })
#  hide('CaseStudyFig2')
})

observeEvent(input$hideshow4, {
  toggle('CaseStudyFig3')
})

observeEvent(input$hideshow5, {
  toggle('CaseStudyFig4')
})

observeEvent(input$hideshow6, {
  toggle('CaseStudyFig5')
})
###-------------End Case study buttons --------------------------###

