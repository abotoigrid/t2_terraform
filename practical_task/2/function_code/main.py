import os
from google.cloud import secretmanager, storage

def hello_http(request):
    # Get environment variables
    secret_id = os.environ["SECRET_ID"]
    bucket_name = os.environ["BUCKET_NAME"]
    project_id = os.environ["GOOGLE_CLOUD_PROJECT"]

    # Initialize clients
    secret_client = secretmanager.SecretManagerServiceClient()
    storage_client = storage.Client()

    # Retrieve secret
    secret_name = f"projects/{project_id}/secrets/{secret_id}/versions/latest"
    response = secret_client.access_secret_version(name=secret_name)
    secret_value = response.payload.data.decode("UTF-8")

    # List files in bucket
    bucket = storage_client.bucket(bucket_name)
    blobs = bucket.list_blobs()
    file_names = [blob.name for blob in blobs]

    # Return response
    return f"Secret retrieved: {secret_value}\nFiles: {', '.join(file_names) if file_names else 'None'}"