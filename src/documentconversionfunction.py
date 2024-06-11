import boto3
import json

s3 = boto3.client('s3')
textract = boto3.client('textract')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    document = event['Records'][0]['s3']['object']['key']

    response = textract.analyze_document(
        Document={'S3Object': {'Bucket': bucket, 'Name': document}},
        FeatureTypes=['TABLES', 'FORMS']
    )

    text = extract_text(response)
    save_converted_document(bucket, document, text)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Document converted successfully!')
    }

def extract_text(textract_response):
    # Extract text from Textract response
    return "extracted text"

def save_converted_document(bucket, document, text):
    # Save the converted document back to S3
    converted_document_key = document.replace('.pdf', '.txt')
    s3.put_object(Bucket=bucket, Key=converted_document_key, Body=text)

