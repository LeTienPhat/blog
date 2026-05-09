require 'aws-sdk-s3'

Aws.config.update(
  credentials: Aws::Credentials.new(
    ENV["AWS_ACCESS_KEY_ID"],
    ENV["AWS_SECRET_ACCESS_KEY"]
  ),
  region: ENV["AWS_REGION"],
  endpoint: ENV["AWS_ENDPOINT"],
  force_path_style: true # Required for LocalStack S3
)

S3_CLIENT = Aws::S3::Client.new
