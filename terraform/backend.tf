#terraform {
#  backend "remote" {
#    organization = "lidoy19"
#    workspaces {
#      name = "flaskapp1114-t"
#    }
#  }
#}

#terraform {
#  backend "local" {
#    path = "terraform.tfstate"
#  }
#}

terraform {
  backend "gcs" {
    bucket = "terraformstate-bucket-flaskapp"
    prefix = "terraform/state"
  }
}
