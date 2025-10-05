############
# LAMBDA FUNCTION that extracts patient_id and patient_name from json file
############

import json
import logging
import os
import urllib.parse
import boto3

# Configure logging
logger = logging.getLogger()
# Set logging to DEBUG to see the 'Full Record' log messages during development
logger.setLevel(logging.INFO)  ## log levels : debug, info, warning, error, critical

# Initialize AWS clients
s3_client = boto3.client('s3')

# Get the target bucket name from environment variables
# This variable is set via Terraform (module."processed-data-bucket".bucket_name)
TARGET_BUCKET = os.environ.get('TARGET_BUCKET_NAME')

def lambda_handler(event, context):
    """
    AWS Lambda function handler triggered by S3 object creation.
    Reads a JSON object list, extracts specific fields (patient_id, patient_name), 
    and writes the resulting transformed JSON list to the target S3 bucket.
    """
    logger.info("--- Lambda function triggered for data transformation ---")
    
    # Make sure the target bucket is available before starting 
    if not TARGET_BUCKET:
        logger.critical("TARGET_BUCKET_NAME environment variable is NOT set. Cannot proceed with writing.")
        raise EnvironmentError("Target bucket name missing.")

    try:
        # 1. PARSE S3 EVENT DATA
        if not event.get('Records'):
            logger.error("No records found in the S3 event.")
            return {'statusCode': 400, 'body': 'No records'}

        record = event['Records'][0]
        source_bucket = record['s3']['bucket']['name']
        source_key = urllib.parse.unquote_plus(record['s3']['object']['key'])

        logger.info(f"Source Bucket: {source_bucket}")
        logger.info(f"Source Key: {source_key}")
        
        # 2. READ, DECODE, AND LOAD SOURCE JSON
        logger.info("trying to read and parse source object...")
        
        try:
            response = s3_client.get_object(Bucket=source_bucket, Key=source_key)
            file_content = response['Body'].read().decode('utf-8')
            data_list = json.loads(file_content)

        except s3_client.exceptions.NoSuchKey:
            logger.error(f"Error: Source object not found: s3://{source_bucket}/{source_key}")
            raise
        except json.JSONDecodeError as e:
            logger.error(f"Error: Failed to decode JSON from file. Exception: {e}")
            raise
            
        # 3. TRANSFORM THE DATA
        logger.info(f"Successfully loaded {len(data_list)} records. Starting transformation.")
        
        # New list to hold the extracted data
        extracted_data = []
        
        for item in data_list:
            # Extract only the required fields
            extracted_record = {
                "patient_id": item.get("patient_id"),
                "patient_name": item.get("patient_name")
            }
            extracted_data.append(extracted_record)
            
        logger.info(f"Transformation complete. {len(extracted_data)} records extracted.")
        
        # 4. WRITE THE TRANSFORMED DATA TO TARGET S3 BUCKET
        
        # Create a new key for the processed data (e.g., input/data.json -> processed/data_summary.json)
        # Using a fixed prefix 'processed_summary' is a good practice.
        source_filename = os.path.basename(source_key)
        target_key = f"processed_summary/{source_filename.replace('.json', '_summary.json')}"
        
        # Convert the Python list back to a JSON string
        target_content = json.dumps(extracted_data, indent=2) 
        
        logger.info(f"trying to write transformed data to s3://{TARGET_BUCKET}/{target_key}")

        s3_client.put_object(
            Bucket=TARGET_BUCKET,
            Key=target_key,
            Body=target_content.encode('utf-8'),
            ContentType='application/json' # Specify content type for the new object
        )
        
        logger.info(f"Data successfully written to target S3 key: {target_key}")
        
        # 5. Return Success
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Data transformation and write successful', 'target_key': target_key})
        }

    except Exception as e:
        # 6. GENERIC ERROR HANDLING (Catch-all)
        logger.error("--- FATAL ERROR DURING LAMBDA EXECUTION ---")
        logger.error(f"An unexpected error occurred: {e}", exc_info=True)
        # Re-raise the exception to mark the invocation as failed
        raise