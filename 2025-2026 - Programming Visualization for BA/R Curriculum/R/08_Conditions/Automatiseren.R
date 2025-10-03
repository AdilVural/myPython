a <- 0

for (i in 1:5)
{
  a <- a + 1
}

for (i in seq(from = 1, to = 5, by=0.5))
{
  print(i)
  print(a)
  a <- a + i
}

for (i in seq(from = 5, to = 1, by=-0.5))
{
  print(i)
  a <- a + i
}

klanten = list("Kwik", "Kwek", "Kwak")
for (i in 1:length(klanten))
{
   print(klanten[i])
}

# while loop
aantal_klanten <- 0
capaciteit <- 100

while (aantal_klanten < capaciteit) 
{
  aantal_klanten <- aantal_klanten + 1
}

# If statement
klant_id = NULL
if (!is.null(klant_id))
{
  print(klant_id)
}else 
{
  print('Klant ID is onbekend.')
}

# Geneste if statement
transactie_id = 1001
if (!is.null(transactie_id))
{
  if (transactie_id == 1000)
  {
    print('Gefeliciteerd! U bent de 1,000e klant!')
  }else if (transactie_id < 1000)
  {
    print('Helaas! Volgende keer beter!')
  }else
  {
    print('Deze actie is afgelopen.')
  }
}else 
{
  print('Transactie ID is onbekend.')
}


# gecombineerde while loop en if
worp <- 1
while (worp <= 6) {
  if (worp < 6) {
    print("Geen Yahtzee")
  } else {
    print("Yahtzee!")
  }
  worp <- worp + 1
}

# Ben and Jerry voorbeeld
library(readxl)
BenAndJerry <- read_excel("BenAndJerry.xlsx")  # Excel bestand laden
nbObs <- length(BenAndJerry$household_id)
BenAndJerry$unit_price <- 0
for (i in 1:nbObs)
{
  if (BenAndJerry$quantity[i] > 0)
  {
    BenAndJerry$unit_price[i] <- BenAndJerry$price_paid[i]/BenAndJerry$quantity[i]
  }
}


# Ben and Jerry voorbeeld met mutate
B <- BenAndJerry %>%
  mutate(unit_price = if_else(quantity > 0, price_paid / quantity, 0))
         




