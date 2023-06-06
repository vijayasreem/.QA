from flask import Flask, request
from elasticsearch import Elasticsearch

app = Flask(__name__)

# Connect to elasticsearch
es = Elasticsearch()

@app.route('/products/index', methods=['POST'])
def index_products():
    # Get product data from request
    data = request.get_json()
    
    # Index product data in Elasticsearch
    es.index(index='products', doc_type='product', body=data)
    
    return 'Product data indexed successfully'

@app.route('/products/search', methods=['GET'])
def search_products():
    # Get search query from request
    query = request.args.get('query')
    
    # Search product data in Elasticsearch
    res = es.search(index='products', body={'query': {'match': {'name': query}}})
    
    return res

@app.route('/products/update', methods=['PUT'])
def update_products():
    # Get product data from request
    data = request.get_json()
    
    # Update product data in Elasticsearch
    es.update(index='products', doc_type='product', body=data)
    
    return 'Product data updated successfully'

@app.route('/products/delete', methods=['DELETE'])
def delete_products():
    # Get product data from request
    data = request.get_json()
    
    # Delete product data in Elasticsearch
    es.delete(index='products', doc_type='product', body=data)
    
    return 'Product data deleted successfully'

if __name__ == '__main__':
   app.run()