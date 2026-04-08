import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('NotesApp')

def lambda_handler(event, context):
    note_id = event['pathParameters']['id']

    table.delete_item(
        Key={'id': note_id}
    )

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Methods': '*'
        },
        'body': json.dumps({
            'message': 'Note deleted',
            'id': note_id
        })
    }
