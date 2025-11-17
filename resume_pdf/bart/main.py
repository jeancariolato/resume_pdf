from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import fitz  # PyMuPDF
from transformers import pipeline


app = FastAPI()
summarizer = pipeline("summarization", model="facebook/bart-large-cnn")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],          # ou ["http://localhost:xxx"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def pdf2text(data: bytes) -> str:
    doc = fitz.open(stream=data, filetype="pdf")
    return " ".join(page.get_text() for page in doc)

@app.post("/resuma")
async def summarize(pdf: UploadFile = File(...)):
    text = pdf2text(await pdf.read())
    # limita tokens para não estourar GPU/CPU
    summary = summarizer(text[:3000], max_length=130, min_length=30, do_sample=False)
    return {"summary": summary[0]["summary_text"]}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)