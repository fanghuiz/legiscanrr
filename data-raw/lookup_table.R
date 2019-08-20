## code to prepare `lookup_table` dataset goes here

library(dplyr)

mimeTypeDict <- tibble(
  mime_type_id = 1:6,
  mime_type = c("text/html", "application/pdf", "application/wpd",
                "application/doc", "application/rtf", "application/docx"),
  mime_type_desc = c("HTML", "PDF", "WordPerfect",
                     "word_doc", "rich_text_format", "word_docx")
)

billTextTypeDict <- tibble(
  bill_text_type_id = 1:14,
  bill_text_type_desc = c("Introduced", "Committee Substitute", "Amended",
                          "Engrossed", "Enrolled", "Chaptered", "Fiscal Note",
                          "Analysis", "Draft", "Conference Substitute", "Prefiled",
                          "Veto Message", "Veto Response", "Substitute")
)

billTypeDict <- tibble(
  bill_type_id = 1:23,
  bill_type = c("B", "R", "CR",
                "JR", "JRCA",
                "EO", "CA","M",
                "CL", "C", "CSR",
                "JM", "P", "SR",
                "A", "CM", "I",
                "PET", "SB", "IP",
                "RB", "RM", "CB"),
  bill_type_name = c("Bill", "Resolution", "Concurrent Resolution",
                     "Joint Resolution", "Joint Resolution Constitutional Amendment",
                     "Executive Order", "Constitutional Amendment", "Memorial",
                     "Claim", "Commendation", "Committee Study Request",
                     "Joint Memorial", "Proclamation", "Study Request",
                     "Address", "Concurrent Memorial", "Initiative",
                     "Petition", "Study Bill", "Initiative Petition",
                     "Repeal Bill", "Remonstration", "Committee Bill")
)

billSponsorDict <- tibble(
  sponsor_type_id = 0:3,
  sponsor_type = c("Sponsor (Generic / Unspecified)",
                   "Primary Sponsor",
                   "Co-Sponsor",
                   "Joint Sponsor")
)

billProgressDict <- tibble(
  event_id = 1:12,
  event_desc = c("Introduced", "Engrossed", "Enrolled", "Passed",
                 "Vetoed", "Failed", "Override", "Chaptered",
                 "Refer", "Report Pass", "Report DNP", "Draft")
)

billStatusDict <- tibble(
  status_id = 0:6,
  status_desc = c("NA", "Introduced", "Engrossed", "Enrolled",
                       "Passed", "Vetoed", "Failed")
)

stateID <- tibble(
  state_id = 1:52,
  state = c("AL", "AK", "AZ", "AR", "CA",
            "CO", "CT", "DE", "FL", "GA",
            "HI", "ID", "IL", "IN", "IA",
            "KS", "KY", "LA", "ME", "MD",
            "MA", "MI", "MN", "MS", "MO",
            "MT", "NE", "NV", "NH", "NJ",
            "NM", "NY", "NC", "ND", "OH",
            "OK", "OR", "PA", "RI", "SC",
            "SD", "TN", "TX", "UT", "VT",
            "VA", "WA", "WV", "WI", "WY",
            "DC", "US"),
  state_name = c("Alabama", "Alaska", "Arizona", "Arkansas", "California",
                 "Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
                 "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
                 "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
                 "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
                 "Montana", "Nebraska", "Nevada", "New Hampshire",  "New Jersey",
                 "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
                 "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
                 "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
                 "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming",
                 "Washington D.C.", "US Congress")
)


lookup_table <- list(stateID = stateID,
                     billStatusDict = billStatusDict,
                     billProgressDict = billProgressDict,
                     billTypeDict = billTypeDict,
                     billTextTypeDict = billTextTypeDict,
                     billSponsorDict = billSponsorDict,
                     mimeTypeDict = mimeTypeDict)


usethis::use_data(lookup_table, overwrite = TRUE)
