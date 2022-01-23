variable "service_account_key_file" {
  description = "Yandex Cloud security SA file"
  default = "key.json"
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID where resources will be created"
  default     = "fill your value"
}

variable "cloud_id" {
  description = "Yandex Cloud ID where resources will be created"
  default     = "fill your value"
}

variable "public_key_path" {
  description = "Path to ssh public key, which would be used to access workers"
  default     = "~/.ssh/id_rsa.pub"
}

variable "user" {
  type = string
  default = "yc-user"
}

