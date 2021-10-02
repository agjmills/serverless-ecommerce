import simplejson as json
import os
import time
import stripe
import boto3

dynamodb = boto3.resource('dynamodb')


def get_price(id, prices):
    for price in prices:
        if price.product == id:
            return {
                "id": price.id,
                "currency": price.currency,
                "type": price.type,
                "unit_amount": price.unit_amount
            }


def list(event, context):
    table = dynamodb.Table(os.getenv("PRODUCTS_TABLE"))
    response = table.scan()
    products = response['Items']

    if len(products) == 0:
        stripe.api_key = os.getenv("STRIPE_SECRET_KEY")
        stripe_products = stripe.Product.list()
        stripe_prices = stripe.Price.list()
        ttl = round(time.time() + 86400)

        products = []
        for product in stripe_products:

            table.put_item(
                Item={
                    "id": product.id,
                    "name": product.name,
                    "images": product.images,
                    "description": product.description,
                    "price": get_price(product.id, stripe_prices),
                    "ttl": ttl
                }
            )

            products.append(
                {
                    "id": product.id,
                    "name": product.name,
                    "images": product.images,
                    "description": product.description,
                    "price": get_price(product.id, stripe_prices),
                    "ttl": ttl
                }
            )

    response = {
        "statusCode": 200,
        "body": json.dumps(products)
    }

    return response