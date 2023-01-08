library(rvest)

url <- "https://www.electromaps.com/pt/estacoes-de-carregamento/portugal/porto/porto"

html_page <- read_html(url)

#Find the div class "chargepoints-stations-container"
page_div <- html_page %>% 
  html_nodes(xpath='//*[@id="stations"]')

#Find the elements "a" inside the div
page_a <- page_div %>% 
  html_nodes("a")

#Extract the classes "chargepoints-stations-text" and "chargepoints-stations-title" for each element
page_a %>% 
  html_nodes(xpath='.//div[@class="chargepoints-stations-text"]') %>% 
  html_text()

page_a %>% 
  html_nodes(xpath='.//div[@class="chargepoints-stations-title"]') %>% 
  html_text()
