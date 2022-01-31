# --------------------------------------------------------------------------------------------------
# Repo variables
# --------------------------------------------------------------------------------------------------

variable "repos" {
  type = map(object({
    // Repo config
    allow_auto_merge       = optional(bool)
    allow_merge_commit     = optional(bool)
    allow_rebase_merge     = optional(bool)
    allow_squash_merge     = optional(bool)
    archived               = optional(bool)
    auto_init              = optional(bool)
    delete_branch_on_merge = optional(bool)
    description            = optional(string)
    gitignore_template     = optional(string)
    has_downloads          = optional(bool)
    has_issues             = optional(bool)
    has_projects           = optional(bool)
    has_wiki               = optional(bool)
    homepage_url           = optional(string)
    is_template            = optional(bool)
    license_template       = optional(string)
    topics                 = optional(list(string))
    pages_branch           = optional(string)
    pages_cname            = optional(string)
    pages_path             = optional(string)
    visibility             = optional(string)
    template_owner         = optional(string)
    template_repository    = optional(string)
    vulnerability_alerts   = optional(bool)
    // Default branch config
    default_branch = optional(string)
    // Branch protections config
    branch_protections = optional(list(object({
      allows_deletions                = optional(bool)
      allows_force_pushes             = optional(bool)
      contexts                        = optional(list(string))
      dismiss_stale_reviews           = optional(bool)
      dismissal_restrictions          = optional(list(string))
      enforce_admins                  = optional(bool)
      pattern                         = string
      require_code_owner_reviews      = optional(bool)
      require_conversation_resolution = optional(bool)
      require_signed_commits          = optional(bool)
      required_linear_history         = optional(bool)
      restrict_dismissals             = optional(bool)
      strict                          = optional(bool)
    })))
    // Webhooks config
    webhooks = optional(list(object({
      active = optional(bool)
      events = optional(list(string))
      // configuration values
      content_type = optional(string)
      insecure_ssl = optional(bool)
      secret       = optional(string)
      url          = string
    })))
  }))
  description = "(optional) List of repositories"
}

# --------------------------------------------------------------------------------------------------
# Default repo variables
# --------------------------------------------------------------------------------------------------

variable "default_allow_auto_merge" {
  type        = bool
  description = "(optional) Default value for whether the option to auto merge is available once all PR checks have completed"
  default     = true
}

variable "default_allow_merge_commit" {
  type        = bool
  description = "(optional) Default value for whether merge commits are allowed for pull requests"
  default     = true
}

variable "default_allow_rebase_merge" {
  type        = bool
  description = "(optional) Default value for whether rebase marge is allowed for pull requests"
  default     = true
}

variable "default_allow_squash_merge" {
  type        = bool
  description = "(optional) Default value for whether squash merge is allowed for pull requests"
  default     = true
}

variable "default_archived" {
  type        = bool
  description = "(optional) Default value for whether a repository is archived"
  default     = false
}

variable "default_auto_init" {
  type        = bool
  description = "(optional) Default value for whether a repository is auto initialised with a commit"
  default     = false
}

variable "default_delete_branch_on_merge" {
  type        = bool
  description = "(optional) Whether branches should be automatically deleted on merge"
  default     = true
}

variable "default_has_downloads" {
  type        = bool
  description = "(optional) Whether repository has downloads enabled"
  default     = true
}

variable "default_has_issues" {
  type        = bool
  description = "(optional) Whether repository has issues enabled"
  default     = true
}

variable "default_has_projects" {
  type        = bool
  description = "(optional) Whether repository has projects enabled"
  default     = true
}

variable "default_has_wiki" {
  type        = bool
  description = "(optional) Whether repository has wiki enabled"
  default     = true
}

variable "default_is_template" {
  type        = bool
  description = "(optional) Whether repository is a template repository"
  default     = false
}

variable "default_pages_path" {
  type        = string
  description = "(optional) Default GitHub pages source path"
  default     = "/"
}

variable "default_topics" {
  type        = list(string)
  description = "(optional) Default topics to apply to repos"
  default     = null
}

variable "default_visibility" {
  type        = string
  description = "(optional) Whether repos are private or public, defaults to private"
  default     = "private"
}

variable "default_vulnerability_alerts" {
  type        = bool
  description = "(optional) Whether repository has vulnerability alerts enabled"
  default     = true
}

# --------------------------------------------------------------------------------------------------
# Default branch variables
# --------------------------------------------------------------------------------------------------

variable "default_default_branch" {
  type        = string
  description = "(optional) Default name for repository default branch"
  default     = "main"
}

# --------------------------------------------------------------------------------------------------
# Branch protection variables
# --------------------------------------------------------------------------------------------------

variable "default_allows_deletions" {
  type        = bool
  description = "(optional) Default value for whether branch protection allows users with push access to delete matching branches"
  default     = false
}

variable "default_allows_force_pushes" {
  type        = bool
  description = "(optional) Default value for whether branch protection permits force pushes for all users with push access."
  default     = false
}

variable "default_enforce_admins" {
  type        = bool
  description = "(optional) Default value for whether branch protections apply to admins"
  default     = true
}

variable "default_pattern" {
  type        = string
  description = "(optional) Default branch protection pattern"
  default     = "main"
}

variable "default_push_restrictions" {
  type        = list(string)
  description = "(optional) Default list of actor IDs that may push to the branch"
  default     = null
}

variable "default_require_conversation_resolution" {
  type        = bool
  description = "(optional) Default value for whether branch protection requires conversation resolution"
  default     = true
}

variable "default_require_signed_commits" {
  type        = bool
  description = "(optional) Default value for whether branch protection requires signed commits"
  default     = true
}

variable "default_required_linear_history" {
  type        = bool
  description = "(optional) Default value for whether branch protection requires linear history"
  default     = false
}

# Required pull request review variables

variable "default_require_code_owner_reviews" {
  type        = bool
  description = "(optional) Default value for whether to require an approved review in pull requests including files with a designated code owner"
  default     = false
}

variable "default_dismiss_stale_reviews" {
  type        = bool
  description = "(optional) Default value for whether branch protection dismisses stale reviews"
  default     = true
}

variable "default_dismissal_restrictions" {
  type        = list(string)
  description = "(optional) Default list of actor IDs with dismissal access"
  default     = null
}

variable "default_required_approving_review_count" {
  type        = number
  description = "(optional) Default value for number of approving reviews for branch protection"
  default     = 1
}

variable "default_restrict_dismissals" {
  type        = bool
  description = "(optional) Default value for whether branch protection should restric dismissals"
  default     = true
}

# Required status check variables

variable "default_contexts" {
  type        = list(string)
  description = "(optional) Default list of status checks to require in order to merge into this branch"
  default     = null
}

variable "default_strict" {
  type        = bool
  description = "(optional) Default value for whether status checks require branches to be up to date before merging"
  default     = true
}

# Webhook variables
variable "default_webhook_active" {
  type        = bool
  description = "(optional) Default webhook active status"
  default     = true
}

variable "default_webhook_content_type" {
  type        = string
  description = "(optional) Default content type for webhooks"
  default     = "json"
}

variable "default_webhook_events" {
  type        = list(string)
  description = "(optional) Default list of webhook events"
  default     = null
}

variable "default_webhook_insecure_ssl" {
  type        = bool
  description = "(optional) Whether webhooks should use insecure SSL"
  default     = false
}


variable "default_webhook_url" {
  type        = string
  description = "(optional) Default webhook url"
  default     = null
}
