variable "rg" {
  type        = string
  description = "Shared gallery resources group"
}

variable "shared_gallery" {
  type        = string
  description = "Shared gallery name"
}

variable "image_definition_baseline" {
  type        = string
  description = "Image definition name for baseline image"
}

variable "image_definition_generalized" {
  type        = string
  description = "Image definition name for generalized image"
}