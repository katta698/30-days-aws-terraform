import os
import logging
from io import BytesIO
from urllib.parse import unquote_plus

import boto3
from PIL import Image

s3_client = boto3.client("s3")

PROCESSED_BUCKET = os.environ["PROCESSED_BUCKET"]
LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")

logger = logging.getLogger()
logger.setLevel(LOG_LEVEL)

SUPPORTED_EXTENSIONS = (".jpg", ".jpeg", ".png", ".webp", ".gif", ".bmp")


def lambda_handler(event, context):
    logger.info("Event received: %s", event)

    for record in event.get("Records", []):
        source_bucket = record["s3"]["bucket"]["name"]
        object_key = unquote_plus(record["s3"]["object"]["key"])

        logger.info("Processing object: s3://%s/%s", source_bucket, object_key)

        if not object_key.lower().endswith(SUPPORTED_EXTENSIONS):
            logger.warning("Unsupported file format: %s", object_key)
            continue

        process_image(source_bucket, object_key)

    return {
        "statusCode": 200,
        "body": "Image processing completed"
    }


def process_image(source_bucket, object_key):
    response = s3_client.get_object(Bucket=source_bucket, Key=object_key)
    image_bytes = response["Body"].read()

    image = Image.open(BytesIO(image_bytes))
    base_name = os.path.splitext(os.path.basename(object_key))[0]

    rgb_image = image.convert("RGB")

    save_jpeg(rgb_image, f"{base_name}_compressed.jpg", 85)
    save_jpeg(rgb_image, f"{base_name}_low.jpg", 60)
    save_webp(rgb_image, f"{base_name}_webp.webp", 85)
    save_png(image, f"{base_name}_png.png")
    save_thumbnail(rgb_image, f"{base_name}_thumbnail.jpg")

    logger.info("Completed processing for %s", object_key)


def upload(buffer, key, content_type):
    buffer.seek(0)

    s3_client.put_object(
        Bucket=PROCESSED_BUCKET,
        Key=key,
        Body=buffer,
        ContentType=content_type,
        ServerSideEncryption="AES256"
    )

    logger.info("Uploaded: s3://%s/%s", PROCESSED_BUCKET, key)


def save_jpeg(image, key, quality):
    buffer = BytesIO()
    image.save(buffer, format="JPEG", quality=quality, optimize=True)
    upload(buffer, key, "image/jpeg")


def save_webp(image, key, quality):
    buffer = BytesIO()
    image.save(buffer, format="WEBP", quality=quality)
    upload(buffer, key, "image/webp")


def save_png(image, key):
    buffer = BytesIO()

    if image.mode == "P":
        image = image.convert("RGBA")

    image.save(buffer, format="PNG", optimize=True)
    upload(buffer, key, "image/png")


def save_thumbnail(image, key):
    thumbnail = image.copy()
    thumbnail.thumbnail((200, 200))

    buffer = BytesIO()
    thumbnail.save(buffer, format="JPEG", quality=85, optimize=True)
    upload(buffer, key, "image/jpeg")