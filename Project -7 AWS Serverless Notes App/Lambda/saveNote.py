import json
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('NotesApp')

def lambda_handler(event, context):
    body = json.loads(event['body'])
    note_id = str(uuid.uuid4())
    title = body['title']

    table.put_item(
        Item={
            'id': note_id,
            'title': title
        }
    )

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Methods': '*'
        },
        'body': json.dumps({
            'message': 'Note saved',
            'id': note_id
        })
    }
