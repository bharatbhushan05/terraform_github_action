# These are the VARIABLE NAMES - they MUST match the argument names in the module block
variable "vpc_id" {          # ← Must match "vpc_id" in module block
  type = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
}

/*
                                                Variables> vpc_id
┌─────────────┐    Outputs    ┌─────────────┐               ┌──────────────────┐
│   VPC       │───────────────│   Root      │───────────────│  Security Group  │
│   Module    │               │   Module    │               │     Module       │
└─────────────┘               └─────────────┘               └──────────────────┘
     │                              │                              │
     │                              │                              │
     │ - vpc_id                     │                              │
     │ - vpc_cidr_block             │                              │
     └────────────────────────────▶                               | 
                                    │                              │
                                    │ - vpc_id                     │
                                    │ - vpc_cidr_block             │
                                    └─────────────────────────────▶
The Rule:
✅ Argument names in module block must match variable names in the module's variables.tf
❌ The VALUES you assign (like module.vpc.vpc_id) can have any name
*/