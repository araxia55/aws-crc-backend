import boto3, json

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

    # Log the current count value
    print(f"Current count: {count}")

    # Increment the visitor count
    count = float(count) + 1
    count = int(count)

    # Update the visitor_counter table
    table.put_item(
        Item={
            "id": 1,
            "count": count
        }
    )

    # Log the updated count value
    print(f"Updated count: {count}")

     # Return the JSON structure that the APIGW expects
     # Including CORS to enforce secure data exchange
    return {
        "statusCode": 200,
        'headers': {
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': '*'
        },
        "body": json.dumps({"count": count})
    }