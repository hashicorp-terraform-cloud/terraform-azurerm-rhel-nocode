
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "random_pet" {
  assert {
    condition     = random_pet.compute_id.length == 3
    error_message = "Length should be 3"
  }
}