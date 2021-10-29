locals {

  environment = var.environment
  name        = lower("${var.prefix}-${var.environment}")

}
