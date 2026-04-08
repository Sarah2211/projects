import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('NotesApp')

def lambda_handler(event, context):
    note_id = event['pathParameters']['id']
    body = json.loads(event['body'])
    title = body['title']

    table.update_item(
        Key={'id': note_id},
        UpdateExpression='SET title = :t',
        ExpressionAttributeValues={
            ':t': title
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
            'message': 'Note updated',
            'id': note_id
        })
    }
