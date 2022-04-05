locals {
  # Extract optional branch protection list.
  # Flattens nested structure:
  # https://www.terraform.io/language/functions/flatten#flattening-nested-structures-for-for_each
  branch_protections = flatten([
    for repo_name, repo in var.repos : [
      for branch_protection_i, branch_protection in(lookup(repo, "branch_protections", null) == null ? [] : repo.branch_protections) : {
        repo_name           = repo_name
        branch_protection_i = branch_protection_i
        repo                = repo
        branch_protection   = branch_protection
      }
    ]
  ])

  # Extract optional webhooks list.
  # Flattens nested structure:
  # https://www.terraform.io/language/functions/flatten#flattening-nested-structures-for-for_each
  webhooks = flatten([
    for repo_name, repo in var.repos : [
      for webhook_i, webhook in(lookup(repo, "webhooks", null) == null ? [] : repo.webhooks) : {
        repo_name = repo_name
        webhook_i = webhook_i
        repo      = repo
        webhook   = webhook
      }
    ]
  ])

  # Extract optional teams list.
  # Flattens nested structure:
  # https://www.terraform.io/language/functions/flatten#flattening-nested-structures-for-for_each
  teams = flatten([
    for repo_name, repo in var.repos : [
      for team_i, team in(lookup(repo, "teams", null) == null ? [] : repo.teams) : {
        repo_name = repo_name
        team_i    = team_i
        repo      = repo
        team      = team
      }
    ]
  ])
}
