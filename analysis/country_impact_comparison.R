# Load packages
library("dplyr")
library("tidyr")
library("ggplot2")
library("plotly")

# Load dataframe
# setwd("~/2019 - 2020 Junior/AUT2019/INFO201 AE/Info-201-Final-Project/")
#terrorism_df <- read.csv("data/global_terrorism.csv", stringsAsFactors = FALSE)
#View(terrorism_df)

# FUNCTION TO PRODUCE BAR CHART FOR SINGLE COUNTRY SUCH THAT:
#   - The x axis shows the attack type
#   - The y axis shows the total number of people impacted (killed + wounded)
#   - The colors in each bar for each attack type shows number of people
#     killed and wounded, respectively
affected_chart <- function(df, country_name) {
  # Filter data to given country
  # Look at the country, attack type, number wounded, and number killed
  # Look at number of people wounded/killed per attack type
  # Gather Killed and Wounded for bar fill
  rel_data <- df %>%
    filter(country_txt == country_name) %>%
    mutate(affected = nkill + nwound) %>%
    dplyr::select(country_txt, attacktype1_txt, nkill, nwound, affected) %>%
    group_by(attacktype1_txt) %>%
    summarize(
      Killed = sum(nkill, na.rm = TRUE),
      Wounded = sum(nkill, na.rm = TRUE),
      naffected = sum(nkill, nwound, na.rm = TRUE)
    ) %>%
    gather(key = "Impact_Type", value = "affected", Killed, Wounded)

  # Generate bar graph
  chart <- ggplot(rel_data) +
    geom_col(mapping = aes(
      x = reorder(attacktype1_txt, -affected),
      y = affected, fill = Impact_Type
    )) +
    scale_fill_manual(values = c(rep(c("dodgerblue4", "dodgerblue2")))) +
    ggtitle(paste("Effects of Attack Types on Individuals in", "India")) +
    xlab("Attack Type") +
    ylab("Number of People Affected") +
    coord_flip() +
    theme(
      plot.title = element_text(hjust = .5),
      axis.ticks = element_blank(),
      axis.text.x = element_text(angle = 90, hjust = 1)
    )
  # Return interactive version of the bar graph
  ggplotly(chart)
}

# Test to see if function works
# affected_chart(terrorism_df, "India")
