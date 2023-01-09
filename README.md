# terraform-github-repos-default-branch-protection

Terraform module to manage GitHub repos, multiple branch protection per repo and multiple webhooks per repo.
Requires Terraform 1.3+ to make use of the `optional` keyword.
## Authentication
Set token and optionally owner with:
```shell
export GITHUB_TOKEN=<personal-access-token-or-oauth-token>
export GITHUB_OWNER=<organisation>
```

## Examples
For a full list of available options, see [variables.tf](./variables.tf).
### Minimal
```terraform
module "repos-minimal" {
  source  = "voquis/repos-branch-protection-webhooks/github"
  version = "0.0.1"

  # Uses all defaults, see variables.tf for all options.

  repos = {
    my-repo-1 = {}
    my-repo-2 = {}
  }
}
```
### Repos with branch protections and webhooks
```terraform
module "repos-full" {
  source  = "voquis/repos-branch-protection-webhooks/github"
  version = "0.0.1"

  # Configure repo defaults
  default_allow_auto_merge       = false
  default_delete_branch_on_merge = false
  default_visibility             = "private"
  default_vulnerability_alerts   = false

  # Configure repo webhook defaults if a repo specifies a webhooks block
  default_webhook_events = [
    "issue_comment",
    "issues",
    "pull_request",
    "pull_request_review_comment",
    "push"
  ]

  # Configure team permission defaults if a repo specifies a teams block
  default_team_permission = "maintain"

  # Define repos
  repos = {
    my-repo-1 = {
      allow_auto_merge       = true
      delete_branch_on_merge = true
      webhooks = [
        {
          content_type = "json"
          url = "https://example-1.com/github-webhook/"
        },
        {
          content_type = "form"
          url = "https://example-2.com/github-webhook/"
        },
      ]
      branch_protections = [
        {
          pattern = "main"
        },
        {
          pattern = "develop"
        },
      ]
    },

    my-repo-2 = {
      allow_auto_merge       = true
      delete_branch_on_merge = true
      default_branch         = "develop"
      webhooks = [
        {
          events = [
            "pull_request",
            "push"
          ]
          url = "https://example.com/github-webhook/"
        }
      ]
      team = [
        {
          team_id    = "my-team"
          permission = "push"
        }
      ]
    }
  }
}
```
