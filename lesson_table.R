library(jsonlite)
library(htmltools)
library(reactable)
library(dplyr)
lesson_data <- fromJSON("https://feeds.carpentries.org/community_lessons.json")
lesson_data <- lesson_data[,c(5,2,8,9,1,3,4,6,7)]

tbl <- reactable(
  lesson_data,
  pagination = FALSE,
  defaultSorted = "description",
  defaultColDef = colDef(headerClass = "header", align = "left"),
  columns = list(
    full_name = colDef(
      show=FALSE
    ),
    description = colDef(
      name = "Lesson Title",
      cell = function(value, index, colname) {
        url <- lesson_data[index,"rendered_site"]
        tags$a(href = url, target = "_blank", value)
      },
      sortable=FALSE,
      filterable=TRUE
    ),
    rendered_site = colDef(
      show=FALSE
    ),
    github_topics = colDef(
      show=FALSE
    ),
    life_cycle_tag = colDef(
      name = "Life Cycle Stage",
      filterable = TRUE,
      class = function(value) {
        paste0("<p class='", value, "'>", value, "</p>")
      }
    ),
    lesson_tags = colDef(
      name = "Tags",
      cell = function(value) {
        content = c()
        tag_strings = strsplit(value, ",")
        for (tag_str in tag_strings) {
          content <- c(content, paste0("<li class='info'>", tag_str, "</li>"))
        }
        paste0("<ul>",paste0(content, collapse=""),"</ul>")
      },
      html=TRUE,
      filterable = TRUE
    ),
    carpentries_org = colDef(
      name = "Organisation",
      filterable = TRUE
    ),
    repo = colDef(
      name = "Repository",
      cell = function(value, index, colname) {
        url <- lesson_data[index,"repo_url"]
        tags$a(href = url, target = "_blank", value)
      },
      filterable = TRUE
    ),
    repo_url = colDef(
      show=FALSE
    )
  ),
  compact = TRUE,
  highlight = TRUE,
  class = "lesson-tbl"
)
