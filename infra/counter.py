import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('visitor_counter')

def handler(event, context):
    # Retrieve the current id
    response = table.get_item(
        Key={'id': 1}
    )

    # Verify if the 'count' key exists in the response before it's accessed
    item = response.get("Item", {"count": 0})
    count = item["count"]

    # Increment the visitor count
    count += 1

    # Update the visitor_counter table
    table.put_item(
        Item={
            "id": 1,
            "count": count
        }
    )

    return count