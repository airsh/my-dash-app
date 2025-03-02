#!/bin/bash

set -e  # エラーが発生したら停止

# AWS情報
S3_BUCKET="my-dash-app-frontend"
CLOUDFRONT_DISTRIBUTION_ID="YOUR_CLOUDFRONT_DISTRIBUTION_ID"

# S3 にアップロード
aws s3 sync ./ s3://$S3_BUCKET --delete

# CloudFront キャッシュを無効化
aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --paths "/*"

echo "フロントエンドのデプロイ完了 🚀"

