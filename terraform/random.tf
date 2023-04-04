provider "random" {

}

resource "random_string" "random_id" {
  length      = 6
  min_numeric = 6
} 