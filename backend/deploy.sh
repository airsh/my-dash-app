#!/bin/bash

set -e  # エラーが発生したら停止

# AWS情報
LAMBDA_FUNCTION_NAME="DashBackend"
ZIP_FILE="lambda_function.zip"

# 依存ライブラリをインストール
pip install --target package -r requirements.txt
cd package
zip -r ../$ZIP_FILE .
cd ..
zip -g $ZIP_FILE lambda_function.py

# Lambdaにデプロイ
aws lambda update-function-code --function-name $LAMBDA_FUNCTION_NAME --zip-file fileb://$ZIP_FILE

echo "Lambda デプロイ完了 🚀"

