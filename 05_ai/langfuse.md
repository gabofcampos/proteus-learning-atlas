==open source platform designed for LLM observability, testing and debugging.==

allows for teams to iterate and have version control over their LLM agents.

### core concepts
- **observability:** provides tracing capabilities to understand what an llm application is doing.
- **prompt management:** systematic approach to create, store, version and optimize LLM instructions. Langfuse provides tools for this.
- **evaluation:** to ensure the quality and reliability of an application.

### how I used it
used in [[corporate_rag]] to trace the langgraph pipeline. Nodes `retrieve` and `generate` are wrapped with `observe` and the rag graph regenerated. 
because the nodes are being watched, once the invocation for the query happens, a call now shows up in the langfuse dashboard and you can check for each of the nodes, what the context was and the answer given by each node.

![[images/langfuse.png]]
## related
- [[corporate_rag]]