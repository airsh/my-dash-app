import boto3
import json

s3 = boto3.client('s3', region_name="ap-northeast-1")  # S3のリージョンを指定
BUCKET_NAME = "my-dash-appdata"  # ここに自分のS3バケット名を入れる
FILE_KEY = "data.tsv"  # ここにS3上のTSVファイル名を入れる

def lambda_handler(event, context):
    try:
        # S3からTSVデータを取得
        response = s3.get_object(Bucket=BUCKET_NAME, Key=FILE_KEY)
        data = response['Body'].read().decode("utf-8").splitlines()

        # 1行目をキー（カラム名）として取得
        keys = data[0].split("\t")
        
        # 残りの行をデータとしてリストに格納
        json_data = [dict(zip(keys, line.split("\t"))) for line in data[1:]]

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

