import json
import uuid
import datetime
import boto3
from botocore.exceptions import ClientError
import hashlib  # Importa hashlib para gerar um hash mais seguro
import os

# Inicializa os clientes do DynamoDB, S3 e Polly
dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')
polly_client = boto3.client('polly')

# Nome da tabela DynamoDB e do bucket S3
TABLE_NAME = os.environ['TABLE_NAME']
BUCKET_NAME = os.environ['BUCKET_NAME']
STUDENTS_TABLE_NAME = os.environ['STUDENTS_TABLE_NAME']


def health(event, context):
    body = {
        "message": "Go Serverless v3.0! Your function executed successfully!"
    }
    return generate_response(200, body)

def v1_description(event, context):
    body = {"message": "TTS API version 1."}
    return generate_response(200, body)

def text_to_speech(event, context):
    """Função principal de conversão de texto para fala."""
    try:
        body = json.loads(event.get("body", "{}"))
        phrase = body.get("phrase")
        if not phrase:
            return generate_response(400, {"message": "Phrase is required"})

        # Verifica se o texto já existe no DynamoDB
        existing_item = check_phrase_exists(phrase)
        if existing_item:
            return generate_response(200, {
                "message": "Information retrieved successfully",
                "id": existing_item['id'],
                "url_to_audio": existing_item['url_to_audio']
            })

        # Converte texto em áudio e salva no S3
        audio_url, unique_id = generate_and_store_audio(phrase)
        
        # Salva as informações no DynamoDB
        save_audio_info(phrase, audio_url, unique_id)

        return generate_response(201, {
            "message": "Information saved successfully",
            "id": unique_id,
            "url_to_audio": audio_url
        })

    except ClientError as e:
        return generate_response(500, {"message": f"AWS Error: {e.response['Error']['Message']}"})
    except Exception as e:
        return generate_response(500, {"message": f"Internal server error: {str(e)}"})

def options(event, context):
    """Manipulador para requisições OPTIONS."""
    return generate_response(200, {})

# Funções auxiliares
def generate_response(status_code, body):
    """Gera uma resposta HTTP formatada."""
    return {
        "statusCode": status_code,
        "headers": {
            "Access-Control-Allow-Origin": "*",  # Permite todas as origens
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",  # Métodos permitidos
            "Access-Control-Allow-Headers": "Content-Type"  # Cabeçalhos permitidos
        },
        "body": json.dumps(body)
    }

def check_phrase_exists(phrase):
    """Verifica se a frase já existe no DynamoDB usando a frase hasheada como ID."""
    table = dynamodb.Table(TABLE_NAME)
    hashed_phrase = hashlib.sha256(phrase.strip().lower().encode()).hexdigest()  # Gera um hash seguro da frase
    response = table.get_item(
        Key={'id': hashed_phrase}  # Usa o hash como chave
    )
    return response.get('Item')  # Retorna o item se existir

def generate_and_store_audio(phrase):
    """Converte o texto em fala e faz o upload no S3."""
    try:
        response = polly_client.synthesize_speech(
            Text=phrase,
            OutputFormat='mp3',
            VoiceId='Vitoria'
        )
        audio_stream = response['AudioStream'].read()

        unique_id = str(uuid.uuid4())
        file_name = f"{unique_id}.mp3"
        
        # Faz o upload no S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=file_name,
            Body=audio_stream,
            ContentType="audio/mpeg",
        )

        audio_url = f"https://{BUCKET_NAME}.s3.amazonaws.com/{file_name}"
        return audio_url, hashlib.sha256(phrase.strip().lower().encode()).hexdigest()  # Gera um hash seguro da frase
    except ClientError as e:
        raise Exception(f"Error generating or storing audio: {e.response['Error']['Message']}")

def save_audio_info(phrase, audio_url, unique_id):
    """Salva as informações da conversão no DynamoDB."""
    table = dynamodb.Table(TABLE_NAME)
    timestamp = datetime.datetime.now().isoformat()
    try:
        table.put_item(
            Item={
                "received_phrase": phrase,
                "url_to_audio": audio_url,
                "created_audio": timestamp,
                "id": unique_id
            }
        )
    except ClientError as e:
        raise Exception(f"Error saving data to DynamoDB: {e.response['Error']['Message']}")

def get_student_info(event, context):
    """Busca informações de um estudante no DynamoDB com base no nome."""
    try:
        body = json.loads(event.get("body", "{}"))
        student_name = body.get("name")

        if not student_name:
            return generate_response(400, {"message": "Name is required"})

        # Busca as informações do estudante no DynamoDB
        student_info = fetch_student_info(student_name)

        if not student_info:
            return generate_response(404, {"message": "Student not found"})

        return generate_response(200, {
            "message": "Student information retrieved successfully",
            "student": student_info
        })

    except ClientError as e:
        return generate_response(500, {"message": f"AWS Error: {e.response['Error']['Message']}"})
    except Exception as e:
        return generate_response(500, {"message": f"Internal server error: {str(e)}"})

def fetch_student_info(name):
    """Busca as informações do aluno no DynamoDB."""
    table = dynamodb.Table(STUDENTS_TABLE_NAME)
    try:
        # Realiza um scan na tabela para encontrar o estudante pelo nome
        response = table.scan(
            FilterExpression=boto3.dynamodb.conditions.Attr('name').eq(name)
        )
        items = response.get('Items', [])
        return items[0] if items else None
    except ClientError as e:
        raise Exception(f"Error fetching data from DynamoDB: {e.response['Error']['Message']}")