# --------------------------------------------------------------------------------------------------
# Manage repositories
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
# --------------------------------------------------------------------------------------------------

resource "github_repository" "this" {
  for_each = {
    for i, repo in var.repos : i => repo
  }

  allow_auto_merge       = lookup(each.value, "allow_auto_merge", null) == null ? var.default_allow_auto_merge : each.value.allow_auto_merge
  allow_merge_commit     = lookup(each.value, "allow_merge_commit", null) == null ? var.default_allow_merge_commit : each.value.allow_merge_commit
  allow_rebase_merge     = lookup(each.value, "allow_rebase_merge", null) == null ? var.default_allow_rebase_merge : each.value.allow_rebase_merge
  allow_squash_merge     = lookup(each.value, "allow_squash_merge", null) == null ? var.default_allow_squash_merge : each.value.allow_squash_merge
  archive_on_destroy     = lookup(each.value, "archive_on_destroy", null) == null ? var.default_archived : each.value.archived
  archived               = lookup(each.value, "archived", null) == null ? var.default_archived : each.value.archived
  auto_init              = lookup(each.value, "auto_init", null) == null ? var.default_auto_init : each.value.auto_init
  delete_branch_on_merge = lookup(each.value, "delete_branch_on_merge", null) == null ? var.default_delete_branch_on_merge : each.value.delete_branch_on_merge
  description            = lookup(each.value, "description", null)
  gitignore_template     = lookup(each.value, "gitignore_template", null)
  has_downloads          = lookup(each.value, "has_downloads", null) == null ? var.default_has_downloads : each.value.has_downloads
  has_issues             = lookup(each.value, "has_issues", null) == null ? var.default_has_issues : each.value.has_issues
  has_projects           = lookup(each.value, "has_projects", null) == null ? var.default_has_projects : each.value.has_projects
  has_wiki               = lookup(each.value, "has_wiki", null) == null ? var.default_has_wiki : each.value.has_wiki
  homepage_url           = lookup(each.value, "homepage_url", null)
  is_template            = lookup(each.value, "is_template", null) == null ? var.default_is_template : each.value.is_template
  license_template       = lookup(each.value, "license_template", null)
  name                   = each.key
  topics                 = lookup(each.value, "topics", null) == null ? var.default_topics : each.value.topics
  visibility             = lookup(each.value, "visibility", null) == null ? var.default_visibility : each.value.visibility
  vulnerability_alerts   = lookup(each.value, "vulnerability_alerts", null) == null ? var.default_vulnerability_alerts : each.value.vulnerability_alerts

  # Optional source template repo config
  dynamic "template" {
    for_each = lookup(each.value, "template_owner", null) != null && lookup(each.value, "template_repository", null) != null ? { template = true } : {}
    content {
      owner      = each.value.template_owner
      repository = each.value.template_repository
    }
  }

  # Optional github pages config
  dynamic "pages" {
    for_each = lookup(each.value, "pages_branch", null) != null ? { pages = true } : {}
    content {

      cname = lookup(each.value, "pages_cname", null)

      source {
        branch = each.value.pages_branch
        path   = lookup(each.value, "pages_path", null) == null ? var.default_pages_path : each.value.pages_path
      }
    }
  }
}

# --------------------------------------------------------------------------------------------------
# Configure default branch for each repository
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default
# --------------------------------------------------------------------------------------------------

resource "github_branch_default" "this" {
  for_each = {
    for i, repo in var.repos : i => repo
  }

  repository = each.key
  branch     = lookup(each.value, "default_branch", null) == null ? var.default_default_branch : each.value.default_branch
}

# --------------------------------------------------------------------------------------------------
# Configure branch protection rules for repo
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection
# --------------------------------------------------------------------------------------------------

resource "github_branch_protection" "this" {
  # Flatten nested structure
  # https://www.terraform.io/language/functions/flatten#flattening-nested-structures-for-for_each
  for_each = {
    for branch_protection in local.branch_protections : "${branch_protection.repo_name}.${branch_protection.branch_protection_i}" => branch_protection
  }

  allows_deletions                = lookup(each.value.branch_protection, "allows_deletions", null) == null ? var.default_allows_deletions : each.value.branch_protection.allows_deletions
  allows_force_pushes             = lookup(each.value.branch_protection, "allows_force_pushes", null) == null ? var.default_allows_force_pushes : each.value.branch_protection.allows_force_pushes
  enforce_admins                  = lookup(each.value.branch_protection, "enforce_admins", null) == null ? var.default_enforce_admins : each.value.branch_protection.enforce_admins
  repository_id                   = github_repository.this[each.value.repo_name].node_id
  pattern                         = lookup(each.value.branch_protection, "pattern", null) == null ? var.default_pattern : each.value.branch_protection.pattern
  push_restrictions               = lookup(each.value.branch_protection, "push_restrictions", null) == null ? var.default_push_restrictions : each.value.branch_protection.push_restrictions
  require_conversation_resolution = lookup(each.value.branch_protection, "require_conversation_resolution", null) == null ? var.default_require_conversation_resolution : each.value.branch_protection.require_conversation_resolution
  require_signed_commits          = lookup(each.value.branch_protection, "require_signed_commits", null) == null ? var.default_require_signed_commits : each.value.branch_protection.require_signed_commits
  required_linear_history         = lookup(each.value.branch_protection, "required_linear_history", null) == null ? var.default_required_linear_history : each.value.branch_protection.required_linear_history

  required_pull_request_reviews {
    dismiss_stale_reviews           = lookup(each.value.branch_protection, "dismiss_stale_reviews", null) == null ? var.default_dismiss_stale_reviews : each.value.branch_protection.dismiss_stale_reviews
    dismissal_restrictions          = lookup(each.value.branch_protection, "dismissal_restrictions", null) == null ? var.default_dismissal_restrictions : each.value.branch_protection.dismissal_restrictions
    require_code_owner_reviews      = lookup(each.value.branch_protection, "require_code_owner_reviews", null) == null ? var.default_require_code_owner_reviews : each.value.branch_protection.require_code_owner_reviews
    required_approving_review_count = lookup(each.value.branch_protection, "required_approving_review_count", null) == null ? var.default_required_approving_review_count : each.value.branch_protection.required_approving_review_count
    restrict_dismissals             = lookup(each.value.branch_protection, "restrict_dismissals", null) == null ? var.default_restrict_dismissals : each.value.branch_protection.restrict_dismissals
  }

  required_status_checks {
    contexts = lookup(each.value.branch_protection, "contexts", [])
    strict   = lookup(each.value.branch_protection, "strict", null) == null ? var.default_strict : each.value.branch_protection.strict
  }
}

# --------------------------------------------------------------------------------------------------
# Configure webhooks for repository
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook
# --------------------------------------------------------------------------------------------------

resource "github_repository_webhook" "this" {
  # Flatten nested structure
  # https://www.terraform.io/language/functions/flatten#flattening-nested-structures-for-for_each
  for_each = {
    for webhook in local.webhooks : "${webhook.repo_name}.${webhook.webhook_i}" => webhook
  }

  active     = lookup(each.value.webhook, "active", null) == null ? var.default_webhook_active : each.value.webhook.active
  events     = lookup(each.value.webhook, "events", null) == null ? var.default_webhook_events : each.value.webhook.events
  repository = each.value.repo_name

  configuration {
    content_type = lookup(each.value.webhook, "content_type", null) == null ? var.default_webhook_content_type : each.value.webhook.content_type
    insecure_ssl = lookup(each.value.webhook, "insecure_ssl", null) == null ? var.default_webhook_insecure_ssl : each.value.webhook.insecure_ssl
    url          = lookup(each.value.webhook, "url", null) == null ? var.default_webhook_url : each.value.webhook.url
  }
}
