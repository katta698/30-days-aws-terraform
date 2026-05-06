resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "upload_bucket" {
  bucket = "${local.name_prefix}-upload-${random_id.bucket_suffix.hex}"
  tags   = local.common_tags
}

resource "aws_s3_bucket" "processed_bucket" {
  bucket = "${local.name_prefix}-processed-${random_id.bucket_suffix.hex}"
  tags   = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "upload_bucket_block" {
  bucket = aws_s3_bucket.upload_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "processed_bucket_block" {
  bucket = aws_s3_bucket.processed_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "upload_bucket_encryption" {
  bucket = aws_s3_bucket.upload_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "processed_bucket_encryption" {
  bucket = aws_s3_bucket.processed_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "upload_bucket_versioning" {
  bucket = aws_s3_bucket.upload_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "processed_bucket_versioning" {
  bucket = aws_s3_bucket.processed_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_lambda_layer_version" "pillow_layer" {
  filename            = "${path.module}/../build/pillow_layer.zip"
  layer_name          = "${local.name_prefix}-pillow-layer"
  compatible_runtimes = ["python3.11"]
  description         = "Pillow layer for image processing"
}

resource "aws_lambda_function" "image_processor" {
  function_name = "${local.name_prefix}-lambda"
  role          = aws_iam_role.lambda_role.arn

  runtime = "python3.11"
  handler = "lambda_function.lambda_handler"

  filename         = "${path.module}/../build/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/../build/lambda_function.zip")

  memory_size = 1024
  timeout     = 60

  layers = [
    aws_lambda_layer_version.pillow_layer.arn
  ]

  environment {
    variables = {
      PROCESSED_BUCKET = aws_s3_bucket.processed_bucket.bucket
      LOG_LEVEL        = "INFO"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attach
  ]

  tags = local.common_tags
}

resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.upload_bucket.arn
}

resource "aws_s3_bucket_notification" "upload_bucket_notification" {
  bucket = aws_s3_bucket.upload_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3_to_invoke_lambda
  ]
}