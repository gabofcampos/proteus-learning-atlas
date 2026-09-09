indexes and stores high dimensional vector embeddings for fast semantic similarity not exact match

## vector embeddings: what they are and how they are created
a vector embedding is the mathematical representation of  features or attributes contained in data.

the vector can be located in a multidimensional space and its closeness to other embeddings will determine how similar the data they represent is.

### what does high dimensional vector embeddings mean?
high dimensional only means a large number of dimensions. 
each dimension captures a specific aspect of the data it represents. So a high level of dimensions allows the embedding to capture the complexity of the data.

> the downside of high dimensional embeddings is that they become computationally expensive to store and process. there are techniques for dimensionality reduction (ex.: PCA) to reduce the size of the embedding without losing information.



## what is the benefit of these dbs in contrast with traditional dbs?
- **traditional databases** are suited towards structured data (organized in rows and columns).
	*good to look for exact matches.*
- **vector databases** allow for the storage and efficient search of unstructured data (text (ex.: pdfs), video, images) by storing instead the vectorial representations of that data.
	*optimized to look for similarity matches. Ex.: find complaint tickets related to 'computer screen freeze'* .


## when to use vectorial databases?

vector embeddings are a valuable technique for transforming complex data into a format suitable for machine learning algorithms.







