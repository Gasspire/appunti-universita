from ollama import Client

# Inizializza il client con l'IP corretto
client = Client(host='http://100.71.36.74:11434')

# Correggi 'messages' trasformandolo in una lista di dizionari
response = client.chat(
    model='llama3.1',
    messages=[
        {
            'role': 'user',
            'content': 'Ciao come stai?',
        },
    ]
)

# Accedi al contenuto usando la sintassi corretta
print(response['message']['content'])