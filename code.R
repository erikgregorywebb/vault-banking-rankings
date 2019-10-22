# import libraries
library(tidyverse)

# import data
url = 'https://raw.githubusercontent.com/erikgregorywebb/vault-banking-rankings/master/data.csv'
bank = read_csv(url)

# define theme function
# source: https://luisdva.github.io/rstats/dog-bump-chart/
my_theme <- function() {
  
  # Colors
  color.background = "white"
  color.text = "#22211d"
  
  # Begin construction of chart
  theme_bw(base_size=15) +
    
    # Format background colors
    theme(panel.background = element_rect(fill=color.background, color=color.background)) +
    theme(plot.background  = element_rect(fill=color.background, color=color.background)) +
    theme(panel.border     = element_rect(color=color.background)) +
    theme(strip.background = element_rect(fill=color.background, color=color.background)) +
    
    # Format the grid
    theme(panel.grid.major.y = element_blank()) +
    theme(panel.grid.minor.y = element_blank()) +
    theme(axis.ticks       = element_blank()) +
    
    # Format the legend
    theme(legend.position = "none") +
    
    # Format title and axis labels
    theme(plot.title       = element_text(color=color.text, size=20, face = "bold")) +
    theme(axis.title.x     = element_text(size=14, color="black", face = "bold")) +
    theme(axis.title.y     = element_text(size=14, color="black", face = "bold", vjust=1.25)) +
    theme(axis.text.x      = element_text(size=10, vjust=0.5, hjust=0.5, color = color.text)) +
    theme(axis.text.y      = element_text(size=10, color = color.text)) +
    theme(strip.text       = element_text(face = "bold")) +
    
    # Plot margins
    theme(plot.margin = unit(c(0.35, 0.2, 0.3, 0.35), "cm"))
}

# create visual
plot = bank %>%
  filter(Type == 'Bulge Bracket') %>%
  ggplot(., aes(x = Year, y = Rank, group = Bank)) +
  geom_line(aes(color = Bank, alpha = 1), size = 2) +
  geom_point(aes(color = Bank, alpha = 1), size = 1) +
  scale_color_brewer(palette = 'Spectral') + 
  scale_x_continuous(limits = c(2010, 2020), expand = c(0.0, 2), breaks = c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019)) +
  scale_y_reverse(breaks = 1:nrow(bank))+
  theme(legend.position = "none") +
  labs(title = 'Vault 50 Banking Rankings', subtitle = "Large Banks, 2011-2019") + 
  my_theme() + 
  geom_text(data = bank %>% filter(Year == 2011 & Type == 'Bulge Bracket'), 
            aes(y = Rank, x = 2011, label = paste(Name, ' (', Rank, ')', sep = '')), hjust = "right", nudge_x = -0.15) +
  geom_text(data = bank %>% filter(Year == 2019 & Type == 'Bulge Bracket'), 
            aes(y = Rank, x = 2019, label = paste(Name, ' (', Rank, ')', sep = '')), hjust = "left", nudge_x = +0.15)

# export    
tiff('plot.tiff', width = 10, height = 6, units = 'in', res = 800)
plot
dev.off()
