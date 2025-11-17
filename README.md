# PDF Resume (Flutter + Python)

Resuma PDFs localmente com IA open-source (BART).

Este projeto permite resumir arquivos PDF usando um backend em Python com o modelo de IA BART disponível no Hugging Face e um frontend em Flutter para interface do usuário.

## Pré-requisitos
- Python 3.8 ou superior
- Flutter SDK instalado
- Git (para clonar o repositório, se aplicável)

## Instruções de Configuração e Execução

### 1. Backend (Python)
Navegue para o diretório do backend (assumindo que está na raiz do projeto). Crie e ative um ambiente virtual, instale as dependências e execute o servidor.

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python main.py
```
### 2. Frontend (Flutter)
Navegue para o diretório do app Flutter, instale as dependências e execute o aplicativo.

```bash
cd flutter_app
flutter pub get
flutter run -d chrome
```
