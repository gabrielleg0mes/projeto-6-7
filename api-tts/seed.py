import json
import boto3
import os
import uuid

# Defina as variáveis de ambiente diretamente no script
os.environ['AWS_ACCESS_KEY_ID'] = ''
os.environ['AWS_SECRET_ACCESS_KEY'] = ''
os.environ['AWS_SESSION_TOKEN'] = ''

# Inicializa o cliente do DynamoDB
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
STUDENTS_TABLE_NAME = os.environ.get('STUDENTS_TABLE_NAME', 'students')
table = dynamodb.Table(STUDENTS_TABLE_NAME)

def seed_data():
    # Carrega os dados dos alunos do arquivo JSON
    with open('alunos.json', 'r') as file:
        alunos = json.load(file)

    # Insere cada aluno no DynamoDB
    for aluno in alunos:
        aluno['id'] = str(uuid.uuid4())  # Gera um ID único para cada aluno
        table.put_item(Item=aluno)

if __name__ == "__main__":
    seed_data()