variable "buckets_configurations" {
  type = map(object({
    bucket_name          = string
    force_destroy_policy = optional(bool, false)
    bucket_versioning = optional(map(string), {
      status     = false
      mfa_delete = false
    })
    bucket_lifecycle_rules                = optional(any, [])
    attach_deny_insecure_transport_policy = optional(bool, false)
    attach_policy                         = optional(bool, true)
    policy = list(object({
      sid       = string
      action    = list(string)
      effect    = optional(string, "Deny")
      resources = optional(list(string), ["*"])
      principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })), [])
      condition = optional(list(object({
        test     = string
        variable = string
        values   = list(string)
      })), [])
    }))
    bucket_enabled = bool
  }))
  description = "Map of configurations that are needed for creating S3 buckets"
  default     = {}
}