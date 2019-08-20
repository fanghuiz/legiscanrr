
# Retrieve bill master list for current session in the given state



url <- paste0("https://api.legiscan.com/?key=", api_key = "1e16291b307d2a789d7f7bf7bbd8f8a4",
              "&op=getMasterList&state=", state = "PA")

master_list <- httr::GET(url) %>%
  httr::content()

