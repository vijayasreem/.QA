from django.views import View
from django.http import HttpResponse
from django.db.models import Q
from .models import Product

import elasticsearch

class IndexView(View):
    """
    This view handles indexing of product data in the search engine or database
    """
    def post(self, request):
        # Connect to the search engine
        es = elasticsearch.Elasticsearch()

        # Get all products from the database
        products = Product.objects.all()

        # Index each product in the search engine
        for product in products:
            es.index(index="products", doc_type="product", id=product.id, body=product.to_dict())

        return HttpResponse("Product data successfully indexed!")

class SearchView(View):
    """
    This view handles searching of product data in the search engine or database
    """
    def get(self, request):
        # Connect to the search engine
        es = elasticsearch.Elasticsearch()

        # Get the search query from the request
        query = request.GET.get('query', None)

        # Execute the search query against the search engine
        results = es.search(index="products", body={
            "query": {
                "query_string": {
                    "query": query
                }
            }
        })

        # Get the list of product ID's for the search results
        product_ids = [result['_id'] for result in results['hits']['hits']]

        # Get the product details from the database
        products = Product.objects.filter(Q(id__in=product_ids))

        return HttpResponse("Search results retrieved successfully!")