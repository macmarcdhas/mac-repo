resource "aws_s3_bucket" "terraform-state" {
  bucket = var.bucket_name
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/backend/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "terraform-state"
    yor_trace            = "b44d0b89-ebd5-4a94-94a6-f272b6d7f07e"
  }
}

resource "aws_dynamodb_table" "terraform-locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/backend/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "terraform-locks"
    yor_trace            = "7b91113e-46b9-4bba-b2c8-8203fb2650b2"
  }
}