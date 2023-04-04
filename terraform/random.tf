provider "random" {

}

resource "random_string" "random_id" {
  length      = 6
  min_numeric = 6
} 


output "id" {
  value = random_string.random_id.result
}