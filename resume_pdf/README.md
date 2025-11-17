# PDF Resume (Flutter + Python)

Resuma PDFs localmente com IA open-source (BART)

### 1. Backend (Python)
```bash
cd 
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
# servidor em http://127.0.0.1:8000

### 2. Frontend (Flutter)
```bash
cd flutter_app
flutter pub get
flutter run -d chrome  