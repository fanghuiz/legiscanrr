## Configuration for legiscanrr
# usethis::use_data("dev_config")

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
my_desc$set(Description = "Tools to interact with the LegiScan API, retrieving
            and parsing JSON information for legislations in US states and Congress,
            such as bill details, sponsors, full bill texts, roll call records and more.")

# The urls
my_desc$set("URL", "https://github.com/fanghuiz/legiscanrr")
my_desc$set("BugReports", "https://github.com/fanghuiz/legiscanrr/issues")

# Save everyting
my_desc$write(file = "DESCRIPTION")

use_mit_license(name = "Fanghui Zhao")
# use_lifecycle_badge("Experimental")
# use_readme_rmd()

# Get the dependencies
use_package("httr")
use_package("assertthat")
use_package("jsonlite")
use_package("tibble")
use_package("readtext")
use_package("curl")
use_package("purrr")
use_package("data.table")
use_package("fs")
use_package("progress")


# Clean your description
use_tidy_description()
