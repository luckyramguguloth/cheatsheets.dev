# RAG & Vector Databases Cheatsheet

> Reference guide for Retrieval-Augmented Generation (RAG), chunking strategies, embeddings, ChromaDB, Qdrant, Milvus, and query retrieval troubleshooting.
> Last verified: May 2026 | Version: Qdrant 1.9+ / Chroma 0.5+ / LangChain 0.2+

---

## Quick Reference

| Component | Industry Standard Choice | Purpose |
|---|---|---|
| Vector DB (Embedded) | ChromaDB | Fast prototyping, in-memory/local storage |
| Vector DB (Production) | Qdrant / Milvus | Distributed, million-vector scale, filtering |
| Dense Embedding Model | `BAAI/bge-large-en-v1.5` | Semantic text embedding (1024-dim) |
| Reranker Model | `BAAI/bge-reranker-large` | Re-score top-K vector results |
| Chunking Strategy | RecursiveCharacterTextSplitter | 512–1024 tokens with 10–15% overlap |

---

## Vector Store Operations (Qdrant Python Client)

```python
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct

client = QdrantClient(url="http://localhost:6333")

# 1. Create collection with cosine distance
client.recreate_collection(
    collection_name="knowledge_base",
    vectors_config=VectorParams(size=1024, distance=Distance.COSINE)
)

# 2. Insert vectors with structured payload
points = [
    PointStruct(
        id=1,
        vector=[0.05] * 1024,
        payload={"doc_id": "kernel_tuning", "author": "admin", "section": "sysctl"}
    )
]
client.upsert(collection_name="knowledge_base", points=points)

# 3. Query vector with metadata filtering
search_result = client.search(
    collection_name="knowledge_base",
    query_vector=[0.05] * 1024,
    query_filter={"must": [{"key": "doc_id", "match": {"value": "kernel_tuning"}}]},
    limit=5
)
```

---

## Two-Stage Retrieval (Dense Search + Cross-Encoder Reranking)

```python
from sentence_transformers import SentenceTransformer, CrossEncoder

embedder = SentenceTransformer("BAAI/bge-large-en-v1.5", device="cuda")
reranker = CrossEncoder("BAAI/bge-reranker-large", device="cuda")

query = "How to handle out of memory in Linux?"
query_embedding = embedder.encode(query)

# Stage 1: Fast vector retrieval (Top 25)
candidate_docs = ["Document snippet 1...", "Document snippet 2..."]

# Stage 2: Deep Cross-Encoder Reranking (Top 3)
pairs = [[query, doc] for doc in candidate_docs]
scores = reranker.predict(pairs)
reranked_docs = [doc for _, doc in sorted(zip(scores, candidate_docs), reverse=True)][:3]
```

---

## Troubleshooting & Recovery

### 1. Low Retrieval Relevance ("Lost in the Middle")
- **Cause:** Chunk sizes too large (diluting semantics) or too small (losing context).
- **Solution:**
  - Reduce chunk size to 512 tokens with 64 token overlap.
  - Apply Contextual Compression or Parent-Document Retrieval (retrieving small chunks for embedding match, but sending parent section to LLM).

### 2. High Latency During Batch Embedding
- **Fix:** Batch inference with `embedder.encode(texts, batch_size=64, show_progress_bar=True)` on GPU instead of iterating row-by-row.

---

## Tips & Tricks

- **HNSW Index Tuning:** Tune `m` (number of bi-directional links) and `ef_construct` (construction search depth) in vector DB configs to trade indexing speed for 99%+ recall accuracy.
- **Hybrid Search:** Combine sparse BM25 keyword matching with dense embeddings using Reciprocal Rank Fusion (RRF) for optimal technical vocabulary search.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
