terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias = "localstack"
  region = "us-east-1"
  shared_credentials_files = ["$HOME/.aws/credentials"]
  skip_credentials_validation = true
  skip_metadata_api_check = true
  skip_requesting_account_id = true
  endpoints {
    dynamodb = "http://localhost:4566"
  }
}

resource "aws_dynamodb_table" "order_table" {
  provider = aws.localstack
  name = "order"
  billing_mode = "PROVISIONED"
  read_capacity = 1
  write_capacity = 1
  hash_key = "order_id" #PK
  range_key = "created_at" #SK
  
  #PK
  attribute {
    name = "order_id"
    type = "S"
  }
  #SK
  attribute {
    name = "created_at"
    type = "S"
  }

  attribute {
    name = "confirmed_by"
    type = "S"
  }
  global_secondary_index {
    name = "confirmed_by_index"
    hash_key = "confirmed_by"
    range_key = "created_at"
    projection_type = "ALL"
    read_capacity = 1
    write_capacity = 1
  }
}

resource "aws_dynamodb_table" "user_table" {
  provider = aws.localstack
  name = "user"
  billing_mode = "PROVISIONED"
  read_capacity = 1
  write_capacity = 1
  hash_key = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}