## Configuration for legiscanrr
usethis::use_data("dev_config")

library(devtools)
library(usethis)
library(desc)

# Remove default DESC
unlink("DESCRIPTION")

# Create and clean desc
my_desc <- description$new("!new")

# Set package name
my_desc$set("Package", "legiscanrr")

# Set author name
my_desc$set("Authors@R",
            "person('Fanghui', 'Zhao', email = 'fanghui.z13@gmail.com', role = c('cre', 'aut'))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# Package title
my_desc$set(Title = "API wrapper for LegiScan")

# Package description
my_desc$set(Description = "The LegiScan API provides structured JSON information
            for legislations in US states and Congress, including bill detail,
            status, sponsors, full bill texts, roll call records and more.")

# The urls
my_desc$set("URL", "https://github.com/fanghuiz/legiscanrr")
my_desc$set("BugReports", "https://github.com/fanghuiz/legiscanrr")

# Save everyting
my_desc$write(file = "DESCRIPTION")

use_mit_license(name = "Fanghui Zhao")
use_lifecycle_badge("Experimental")
# use_readme_rmd()

# Get the dependencies
use_package("httr")
use_package("jsonlite")
use_package("curl")
use_package("attempt")
use_package("purrr")
use_package("dplyr")
use_package("data.table")
use_package("magrittr")
use_package("fs")
use_package("progress")
use_package("readtext")

use_package("tidyr")
use_package("checkmate")
use_package("tibble")


# Clean your description
use_tidy_description()
