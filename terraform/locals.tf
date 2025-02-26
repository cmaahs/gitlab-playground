locals {
  common_tags = {
    "Purpose"      = "${var.environment}-k8s",
    "Creator"      = var.creator,
    "Date_Created" = formatdate("YYYY-MM-DD'_'hhmm", time_static.date.rfc3339)
  }
  storage_account_name = replace("${var.environment}-backup-bucket", "-", "")
}

resource "time_static" "date" {}
