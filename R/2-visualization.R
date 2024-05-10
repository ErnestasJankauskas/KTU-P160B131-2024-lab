library(tidyverse)
library(plotly)
library(gganimate)
library(htmlwidgets)

data <- readRDS("../data/kaunas15.rds")

# 2.1. Histograma

hist(data$avgWage, breaks = 10)

data %>%
  filter(avgWage <100000) %>%
  ggplot(aes(x = avgWage)) +
  geom_histogram(bins = 100)
ggsave("../data/averagewage.png")

# 2.2. Išrinkti 5 įmones, kurių faktinis sumokėtas darbo užmokestis per metus buvo didžiausias
top5 <- data %>%
  group_by(name) %>%
  summarise(sumWage = sum(avgWage)) %>%
  arrange(desc(sumWage)) %>%
  head(5)

# Atvaizduoti šių įmonių vidutinio atlyginimo kitimo dinamiką metų eigoje
p <- data %>%
  filter(name %in% top5$name) %>%
  mutate(month = ym(month)) %>%
  ggplot(aes(x = month, y = avgWage, color = name)) +
  geom_line()

# Pasiverčiame ggplot grafiką į plotly formatą
p_plotly <- ggplotly(p)

# Animate
p_animate <- p +
  transition_reveal(month)

p_animated <- animate(p_animate, nframes = 50, duration = 5, width = 1600, height = 1000)

# Išsaugoti animaciją kaip gif failą
anim_save("../data/animated_plot.gif", animation = p_animated)

# 2.3. uzduotis
# Išrinkti 5 įmones, kurios turi maksimalų apdraustų darbuotojų skaičių
top5 <- data %>%
  group_by(name) %>%
  summarise(maxInsured = max(numInsured)) %>%
  arrange(desc(maxInsured)) %>%
  head(5)

# Atvaizduoti šių įmonių maksimalų apdraustų darbuotojų skaičių stulpeline diagrama mažėjimo tvarka
p <- top5 %>%
  ggplot(aes(x = maxInsured, y = reorder(name, -maxInsured), fill = name)) +
  geom_col() +
  labs(x = "Įmonės pavadinimas", y = "Maksimalus apdraustų darbuotojų skaičius") +
  coord_flip()

# Atvaizduoti stulpelinę diagramą
p_plotly <- ggplotly(p)

# Sukurti animaciją
p_animate <- p +
  transition_states(states = name, transition_length = 2, state_length = 1)
p_animated <- animate(p_animate, nframes = 50, duration = 5, width = 1600, height = 1000)
anim_save("../data/animated_plot.gif", animation = p_animated)
