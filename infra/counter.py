import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visitor_counter')

def handler(event, context):
    try:
        response = table.BatchGetItem (
            Key={
                'id': 'visitor-count',
                'count': 0
            }
        )
        if 'Item' in response:
            count = response['Item']['count'] + 1
        else:
            count = 1

        table.put_item(
            Item={
                'id': 'visitor-count',
                'count': 0
            }
        )

        return {
            'statusCode': 200,
            'body': str(count)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }