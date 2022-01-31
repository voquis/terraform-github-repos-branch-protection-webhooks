output "repository" {
  value = github_repository.this
}

output "branch_default" {
  value = github_branch_default.this
}

output "branch_protection" {
  value = github_branch_protection.this
}
