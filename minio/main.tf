provider "minio" {
  minio_server   = var.minio_creds.endpoint
  minio_user     = var.minio_creds.username
  minio_password = var.minio_creds.password
  minio_ssl      = true
}

resource "minio_iam_user" "ops" {
  name          = "ops"
  force_destroy = true
  tags = {
    role = "operations"
  }
}

resource "minio_iam_group" "operations_group" {
  name = "operations"
}

resource "minio_iam_policy" "operations_group_policy" {
  name = "rw_on_operations_bucket"
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "s3:*"
          ],
          Resource = "arn:aws:s3:::operations/*"
        }
      ]
    }
  )

  depends_on = [
    minio_iam_group.operations_group,
  ]
}

resource "minio_iam_group_policy_attachment" "developer" {
  group_name  = minio_iam_group.operations_group.name
  policy_name = minio_iam_policy.operations_group_policy.name
}

resource "minio_iam_group_membership" "operations_group_membership" {
  name = "infra-ops-membership"

  users = [
    "${minio_iam_user.ops.name}",
  ]

  group = minio_iam_group.operations_group.name

  depends_on = [
    minio_iam_user.ops,
    minio_iam_group.operations_group,
  ]
}

resource "minio_s3_bucket" "operations_bucket" {
  bucket = "operations"
  acl    = "private"
  quota  = 16000000000
}
resource "minio_s3_bucket_versioning" "operations_bucket_versioning" {
  bucket = minio_s3_bucket.operations_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [
    minio_s3_bucket.operations_bucket,
  ]
}

output "operations_bucket_url" {
  value = minio_s3_bucket.operations_bucket.bucket_domain_name
}

