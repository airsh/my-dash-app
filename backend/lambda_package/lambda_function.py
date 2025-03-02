import boto3
import pandas as pd
import json
import io

# S3 設定
s3 = boto3.client('s3')
BUCKET_NAME = "my-dash-appdata"  # S3のバケット名
FILE_KEY = "data.tsv"  # S3にアップロードしたデータファイル名

def lambda_handler(event, context):
    try:
        # S3 から TSV データを取得
        response = s3.get_object(Bucket=BUCKET_NAME, Key=FILE_KEY)
        data = response['Body'].read().decode('utf-8')

        # TSV を DataFrame に変換
        df = pd.read_csv(io.StringIO(data), sep="\t")

        # JSON形式に変換
        json_data = df.to_dict(orient="records")

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(json_data)
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }

