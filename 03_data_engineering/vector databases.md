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

technically, vector similarity is the mathematical process of measuring how close those vectors are within the multi-dimensional space. **If the vectors are close in the space, then they are semantically similar, if they are apart the data is unrelated**.

three common similar methods to measure closeness:

> remember cosine similarity and dot product return high scores for similar vectors. euclidian returns low scores for similar vectors.
#### 1. cosine similarity

 ==measures the angle between vectors **regardless of their magnitude**.==
 
 because the size of the vectors is not taken into account, this method is useful when the scale of the compared vectors does not play a role in the search. So good when we care about meaning (ex.: *searching across docs might for a specific piece of info has nothing to do with the size of the docs*).

downside: this obliviousness towards a difference in vector scale can be a limiting factor depending on the context.

cosine similarity is always in the interval ([-1, 1]):
- **cos_sim = 1**: The angle (θ) is 0, meaning the vectors point in the same direction (one is a positive scalar multiple of the other). 
- **cos_sim = 0**: The angle (θ) is 90 degrees, meaning the vectors are orthogonal, which often indicates they are unrelated in context.
- **cos_sim = -1**: The angle (θ) is 180 degrees, meaning the vectors are aligned but point in opposite directions.

![[Pasted image 20260909172048.png|398]]
#### 2. dot product or inner product

==measures both similarity and magnitude of vectors.==
useful when both the direction (meaning) and size of vectors is relevant.

dot product similarity returns a scalar ([-inf, inf]). the larger the dot product result the bigger the similarity between vectors.

$dotproduct(a,b) = Σ(aᵢ × bᵢ) = a₁b₁ + a₂b₂ + ... + aₙbₙ$
or geometrically:
$dotproduct(a,b) = |a| × |b| × cos(θ)$ 

**very cheap to compute.** if vectors are normalized to unit length, the dot product and inner product rank similarity identically.
#### 3. euclidian (L2) distance

==measures the straight line distance between vectors.== 

to do this, one must treat the vectors as points in space by calculating the distance between each of the components of the vectors, squaring each difference and summing it.

because euclidian measures the distance, the closer the vectors (more similar) the lower the euclidian distance. So a high score obtained through this method means the vectors are far apart and thus, not similar.

#### when to use each method
1. **cosine:** text similarity, document comparison, and semantic search where document length varies. **best when you care about meaning.**
2. **dot product:** recommendation systems, collaborative filtering, and **applications where magnitude represents importance** (like user activity levels).
3. **euclidian distance:** clustering, anomaly detection, and applications where absolute differences in feature values matter. Works well for count-based features and spatial data.

## how vector databases work
### loading and creating data
1. **embed:** pass raw data (text, images, audio, video...) through an embedding model to get a vector per item.
2. **attach metadata:** add metadata to each of the embeddings . This allows you to combine similarity search with regular search (`where lang = 'es'`).
`{"source": "name_source.pdf", "page": 4, "lang": "es"}`)`
3. **insert into a collection:** the vector + payload get stored. the db updates its index as each item comes in. **indexing does not happen at a separate step, it happens *during insertion***. while bulk loading a dataset, indexing will take time to build, can be slower than you might expect.

#### indexing


### the search
let's say there is a vector database with a set of vectors already stored.
a user queries said db, what happens then?
1. **vectorization:** the query is vectorized/embedded using the **same** model used to create the database.
2. **vector indexing:** instead of comparing the created query vector against all stored embeddings, the **db walks the index built at insertion to jump into the region in space where it is likely to find similar vectors.** This way it skips most of the dataset, but since it is approximating a region in space, **the result might be a similar match but not the closest match.** 
3. **query execution:** once a similar region has been found, candidates from that region get scored against the query vector using a similarity method, payload filters get applied and top-k results are returned ranked.

## when to use vector databases?
most common use cases:
- **large language models**
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

## references
- [databricks](https://www.databricks.com/blog/what-is-vector-database)
- [pinecone](https://www.pinecone.io/learn/vector-similarity/)
- [redis](https://redis.io/blog/vector-similarity/)
- []()