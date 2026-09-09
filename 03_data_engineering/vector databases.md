indexes and stores high dimensional vector embeddings for fast semantic similarity not exact match

### vector embeddings: what they are & how they are created
a vector embedding is the mathematical representation of  features or attributes contained in data.

the vector can be located in a multidimensional space and its closeness to other embeddings will determine how similar the data they represent is.

### what does high dimensional vector embeddings mean?
high dimensional only means a large number of dimensions. 
each dimension captures a specific aspect of the data it represents. So a high level of dimensions allows the embedding to capture the complexity of the data.

> the downside of high dimensional embeddings is that they become computationally expensive to store and process. there are techniques for dimensionality reduction (ex.: PCA) to reduce the size of the embedding without losing information.

### why these dbs and not traditional dbs?
- **traditional databases** are suited towards structured data (organized in rows and columns).
	*good to look for exact matches.*
- **vector databases** allow for the storage and efficient search of unstructured data (text (ex.: pdfs), video, images) by storing instead the vectorial representations of that data.
	*optimized to look for similarity matches. Ex.: find complaint tickets related to 'computer screen freeze'* .

## similarity or how closeness is measured

todo

## how vector databases work
todo
### loading and creating data
### the search
let's say there is a vector database with a set of vectors already stored.
a user queries said db, what happens then?
1. **vectorization:** 
2. **vector indexing:**
3. **query execution:**

## when to use vector databases?
most common use cases:
- **large language models*
- **image recognition:** used in e-commerce to find similar items, social media as recommendation system. Used also in facial recognition.
- **natural language processing:** used in the storage and retrieval of word representation for NLP. Semantic search.
- **fraud detection:** in the detection of fraudulent transactions through similarity with known fraud patterns.

## when *not* to use a dedicated vector db
if your dataset is small enough that brute force cosine similarity over a numpy array is fast enough (thousands, not millions, of vectors)

## vector dbs
- **[[qdrant]]**: dedicated vector DB, written in Rust, strong filtering support, easy to self-host via docker.
- **pgvector**: a Postgres extension. Adds vector similarity search to a DB you may already be running.
- **pinecone**: fully managed, no self-hosting option. Easy to start, less control.`
- **weavite**: dedicated vector DB, built in modules for embedding generation, hybrid search.`
- **milvus**: dedicated vector DB, built for large-scale/production, more operational overhead.`
- **chroma**: lightweight, popular for local prototyping/small RAG projects.