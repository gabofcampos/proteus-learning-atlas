==free, open-source platform that let's you download and run larg llm models locally.==

running the models locally means:
1. you keep your data private since it all stays in your machine.
2. you can run models offline once they've been downloaded.
3. no per token costs. once the model is downloaded you run your prompts against it free of charge.
## how I used it
used in [[corporate_rag]] for both, prepping for the Retrieval and the Generation steps:
- in the generation of the RAG's answer
	`response = ollama.chat(model="llama3.2", messages=[{"role": "user", "content": prompt}])`
- to create embeddings for our qdrant database to store our sample documents.
	`ollama.embeddings(model="nomic-embed-text", prompt=text)`

## issue with ollama disconnecting
so `ollama serve` starts a local server, then python code talks to it over a REST API (`ollama.chat(), ollama.embeddings()`). 
However, colab does not guarantee the background process stays alive (specially in our case since we were setting up qdrant and the rest of the tech stack). So basically the ollama server died on us without us knowing and when we tried to call it again, the server had disconnected.
## related
- [[corporate_rag]]