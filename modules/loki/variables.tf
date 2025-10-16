/**
 * @fileoverview Variables for Loki module
 * @author Terraform DevOps
 * @date 2025-01-15
 */

variable "network_name" {
  description = "Name of the Docker network"
  type        = string
}

# Loki Server Configuration
variable "loki_http_port" {
  description = "HTTP port for Loki server"
  type        = number
  default     = 3100
}

variable "loki_grpc_port" {
  description = "gRPC port for Loki server"
  type        = number
  default     = 9096
}

variable "loki_log_level" {
  description = "Log level for Loki server"
  type        = string
  default     = "info"
  validation {
    condition     = contains(["debug", "info", "warn", "error"], var.loki_log_level)
    error_message = "Log level must be one of: debug, info, warn, error."
  }
}

# Loki Storage Configuration
variable "loki_storage_path" {
  description = "Storage path for Loki data"
  type        = string
  default     = "/loki"
}

variable "loki_replication_factor" {
  description = "Replication factor for Loki"
  type        = number
  default     = 1
}

# Loki Limits Configuration
variable "loki_max_streams_per_user" {
  description = "Maximum streams per user"
  type        = number
  default     = 0
}

variable "loki_max_line_size" {
  description = "Maximum line size in bytes"
  type        = number
  default     = 256000
}

variable "loki_max_query_parallelism" {
  description = "Maximum query parallelism"
  type        = number
  default     = 32
}

variable "loki_max_query_length" {
  description = "Maximum query length"
  type        = string
  default     = "721h"
}

variable "loki_max_query_series" {
  description = "Maximum query series"
  type        = number
  default     = 500
}

variable "loki_max_entries_limit_per_query" {
  description = "Maximum entries limit per query"
  type        = number
  default     = 5000
}

# Loki Cache Configuration
variable "loki_cache_max_size_items" {
  description = "Maximum cache size in items"
  type        = number
  default     = 1024
}

variable "loki_cache_max_size_bytes" {
  description = "Maximum cache size in bytes"
  type        = number
  default     = 102400
}

variable "loki_cache_validity" {
  description = "Cache validity period"
  type        = string
  default     = "24h"
}

# Loki Analytics Configuration
variable "loki_analytics_enabled" {
  description = "Enable analytics reporting"
  type        = bool
  default     = false
}
