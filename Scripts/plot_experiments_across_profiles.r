# Get list of profiles and echo to the console. You will use the left-most number for the
# profile you want to query in the next step.
( ga.profiles <- ga$GetProfileData(access_token) )
ga.profiles<-ga.profiles[c(39,67,1),]
my_start_date <-"2013-09-28"  # Query date range
my_end_date   <-"2013-10-09" 

# Create a filtering for getting specific data on the experiment across domains
filters<-c("ga:experimentId=~I1L9wLVESJen2wS_Cvt_KA","ga:experimentId=~3bo3cnAzTZux591CZabJDA","ga:experimentId=~_7ipfAJyRf2bMKCrXPfaaw")

for (i in 1:nrow(ga.profiles)) {
  print(filters[i])
  # Initiate a Query   
  query <- QueryBuilder()
  # Build the query string, use the profile by setting its index value 
  query$Init(start.date = my_start_date,
             end.date = my_end_date,
             dimensions = "ga:date,ga:experimentVariant,ga:browser",
             metrics = "ga:goal1Completions,ga:transactions,ga:visits,ga:transactionRevenue", 
             sort = "ga:date",
             filters = filters[i], 
             max.results = 1500,
             table.id = paste("ga:",ga.profiles$id[i],sep="",collapse=","),
             access_token=access_token)
  
  # Make a request to get the data from the API
  ga.data.1<- ga$GetReportData(query)
  
  # Merge files, create metrics, limit dataset to just days when tags firing
  ga.data.1$date <-ymd(ga.data.1$date)
  
  # Report Header  
  print(paste("The following graphs and tables are about",ga.profiles$name[i],"experiment performance"))
  
  
  
  # Build the graphs to use with multiplot()
  # REMINDER : Use print() to get ggplot/qplot in loops!
  a<-qplot(experimentVariant, transactionRevenue/transactions,data=ga.data.1, geom="boxplot" 
           , main=paste("AOV per Variant\n",ga.profiles$name[i]),xlab="Variant", ylab="AOV")
  b<-qplot(experimentVariant, goal1Completions/visits,data=ga.data.1, geom="boxplot" 
           , main=paste("Select a flight % per Variant\n",ga.profiles$name[i]),xlab="Variant", ylab="Select a flight (%)")
  c<-qplot(experimentVariant, transactions/visits,data=ga.data.1,geom="boxplot" 
           , main=paste("Conversion (%)\n",ga.profiles$name[i]),xlab="Variant", ylab="Conversion (%)")
  
  print(multiplot(a,b,c, cols=3))
  # The next two are ggplot grpahs and will be use without the multiplot()   
  d<-ggplot(ga.data.1, aes(x=date, y=(transactions/visits)*100, colour=experimentVariant)) 
  e<-ggplot(ga.data.1, aes(x=date, y=(transactionRevenue/transactions), colour=experimentVariant))
  print(d + 
          geom_point(alpha=.3) +
          geom_smooth(alpha=.2, size=1) +
          theme(legend.background = element_rect(fill="gray90", size=.5, linetype="dotted"))+
          labs(title = paste("Conversion (%) per Variant\n",ga.profiles$name[i]),x="Date",y="Conversion (%)"))
  print(e + 
          geom_point(alpha=.3) +
          geom_smooth(alpha=.2, size=1) +
          theme(legend.background = element_rect(fill="gray90", size=.5, linetype="dotted"))+
          labs(title = paste("AOV per Variant\n",ga.profiles$name[i]),x="Date",y="AOV"))
  
}