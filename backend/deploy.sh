#!/bin/bash

set -e  # エラー時にスクリプトを停止

# AWS情報
LAMBDA_FUNCTION_NAME="DashBackend"
ZIP_FILE="lambda_function.zip"

# 依存ライブラリのインストール
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies..."
    mkdir -p package
    pip install --target package -r requirements.txt
else
    echo "No requirements.txt found, skipping dependencies installation."
fi

# 確認: package フォルダに何があるか表示
echo "Contents of package directory:"
ls -l package || echo "package directory is empty"

# ZIP の作成（package/ にファイルが存在する場合のみ）
if [ "$(ls -A package 2>/dev/null)" ]; then
    cd package
    zip -r9 ../$ZIP_FILE .
    cd ..
else
    echo "No dependencies to include in ZIP."
fi

# lambda_function.py が存在するか確認
if [ -f "lambda_function.py" ]; then
    echo "Adding lambda_function.py to ZIP..."
    zip -g $ZIP_FILE lambda_function.py
else
    echo "Error: lambda_function.py not found!"
    exit 1
fi

# Lambdaにデプロイ
echo "Deploying Lambda function..."
aws lambda update-function-code --function-name $LAMBDA_FUNCTION_NAME --zip-file fileb://$ZIP_FILE

echo "Lambda デプロイ完了 🚀"

