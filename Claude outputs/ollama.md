==ollama is a tool to run open-weight LLMs (and embedding models) locally, without building custom model-serving infra==

## why would I use it?
one command to pull and run a model, no GPU/infra setup needed to get something working. exposes a local REST API + CLI that other tools (langchain, langgraph, your own scripts) can call.

## core concepts

### the model library
ollama pulls pre-packaged, pre-quantized models from its own registry (`ollama pull <model>`) — similar idea to `docker pull`, models ship as layered artifacts.
- **Modelfile:** ollama's equivalent of a Dockerfile — defines a model's base, parameters (temperature, context length...), system prompt. lets you customize/create your own named model variant.

### server + CLI
`ollama serve` starts a local server (default `127.0.0.1:11434`) exposing a REST API. `ollama run <model>` is a CLI convenience wrapper for quick manual chatting — actual programmatic use (like in a notebook/app) goes through the API or the python client instead.

### chat vs. embedding models
ollama serves both kinds through the same server, but they're different tools for different jobs:
- **chat/generation models** (ex.: `llama3.2`) — take a prompt, return generated text.
- **embedding models** (ex.: `nomic-embed-text`) — take text, return a vector. not for generation, purely to produce embeddings for search/RAG.

## how I used it
used in [[corporate_rag]] as the local model runtime for both halves of the RAG pipeline:
- `nomic-embed-text` via `ollama.embeddings(...)` — embeds both the stored doc chunks and the incoming query. same model on both sides, so they land in the same vector space. feeds into [[qdrant]] and the `retrieve` step in [[langgraph]].
- `llama3.2` via `ollama.chat(...)` — used in the `generate` node to answer from the retrieved context.

installed and started inside the Colab notebook itself (`curl -fsSL https://ollama.com/install.sh | sh`, then `ollama serve` as a background process) rather than a separately hosted server — so it only exists for the lifetime of that Colab session, has to be re-pulled/re-started each run.

## Things I didn't understand
- quantization — how much quality is actually lost running a quantized model vs. the full-size one?
- what running ollama outside a throwaway Colab session looks like (persistent server, always-on host) if this ever needed to be more than a notebook experiment

## Related
- [[corporate_rag]]
- [[langgraph]]
- [[qdrant]]
- [[RAG]]
