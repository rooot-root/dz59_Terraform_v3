variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "default_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "vpc_name" {
  type    = string
  default = "develop"
}

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
      default = [
	{ vm_name = "main",    cpu = 2, ram = 2, disk_volume = 20 },
    { vm_name = "replica", cpu = 2, ram = 2, disk_volume = 30 }
  ]
}
