resource "aws_secretsmanager_secret" "db" {
  count = var.create_db_secret ? 1 : 0

  name        = "${var.name_prefix}/database"
  description = "Database credentials for ${var.name_prefix}"

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-database-secret"
      Type = "database"
    }
  )
}

resource "aws_secretsmanager_secret_version" "db" {
  count = var.create_db_secret ? 1 : 0

  secret_id = aws_secretsmanager_secret.db[0].id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    engine   = var.db_engine
    host     = var.db_host
    port     = var.db_port
    dbname   = var.db_name
  })
}

resource "aws_secretsmanager_secret" "api" {
  count = var.create_api_secret ? 1 : 0

  name        = "${var.name_prefix}/api"
  description = "API credentials for ${var.name_prefix}"

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-api-secret"
      Type = "api"
    }
  )
}

resource "aws_secretsmanager_secret_version" "api" {
  count = var.create_api_secret ? 1 : 0

  secret_id = aws_secretsmanager_secret.api[0].id

  secret_string = jsonencode({
    api_key    = var.api_key
    api_secret = var.api_secret
  })
}

resource "aws_secretsmanager_secret" "app_config" {
  count = var.create_app_config_secret ? 1 : 0

  name        = "${var.name_prefix}/app-config"
  description = "Application configuration for ${var.name_prefix}"

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-app-config-secret"
      Type = "app-config"
    }
  )
}

resource "aws_secretsmanager_secret_version" "app_config" {
  count = var.create_app_config_secret ? 1 : 0

  secret_id     = aws_secretsmanager_secret.app_config[0].id
  secret_string = jsonencode(var.app_config)
}