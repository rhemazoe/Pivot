variable "region" {
    description = "Default Region for Provider"
    type        = string 
    default     = "us-east-1"
}

variable "bucket" {
    description = "s3 Bucket Name"
    type        = string 
    default     = "pivotbio"
}


variable "name" {
    description = "sns topic name"
    type        = string 
    default     = "pivotbio-notify"
}

