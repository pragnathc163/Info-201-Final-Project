# Load packages
library("dplyr")
library("ggplot2")

# Load dataframe
terrorism_df <- read.csv("data/global_terrorism.csv", stringsAsFactors = FALSE)

# FUNCTION TO PRODUCE BAR CHART FOR SINGLE COUNTRY SUCH THAT:
#   - The x axis shows the attack type
#   - The y axis shows the total number of people impacted (killed + wounded)
#   - The colors in each bar for each attack type shows number of people
#     killed and wounded, respectively
affected_chart <- function(df, country) {
  # Filter data to given country
  # Look at the country, attack type, number wounded, and number killed
  # Look at number of people wounded/killed per attack type
  # Gather Killed and Wounded for bar fill
  rel_data <- df %>% 
    filter(country_txt == country) %>% 
    mutate(affected = nkill + nwound) %>% 
    select(country_txt, attacktype1_txt, nkill, nwound, affected) %>% 
    group_by(attacktype1_txt) %>% 
    summarize(Killed = sum(nkill, na.rm = TRUE),
              Wounded = sum(nkill, na.rm = TRUE),
              naffected = sum(nkill, nwound, na.rm = TRUE)) %>% 
    gather(key = "Impact Type",
           value = "affected",
           Killed, Wounded)
  
  # Generate bar graph 
  chart <- ggplot(data) +
    geom_col(mapping = aes(x = attacktype1_txt, y = affected, fill = affect_type)) +
    ggtitle("Effects of Attack Types on Individuals") +
    xlab("Attack Type") +
    ylab("Number of People Affected") + 
    coord_flip() +
    theme(plot.title = element_text(hjust = .5),
          axis.ticks = element_blank())
  # Return the bar graph
  chart
}

affected_chart(terrorism_df, India)