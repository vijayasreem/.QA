from django.db import models

# Create your models here.
class Product(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    price = models.DecimalField(max_digits=8, decimal_places=2)
    stock = models.IntegerField()

# Create a search index for the Product model
class ProductIndex(models.Model):
    product_id = models.IntegerField()
    name = models.CharField(max_length=255)
    description = models.TextField()
    price = models.DecimalField(max_digits=8, decimal_places=2)
    stock = models.IntegerField()

# Automate the indexing process for newly created/deleted products
def index_products():
    products = Product.objects.all()
    for product in products:
        if product.id not in ProductIndex.objects.filter(product_id=product.id):
            product_index = ProductIndex(product_id=product.id,
                                        name=product.name,
                                        description=product.description,
                                        price=product.price,
                                        stock=product.stock)
            product_index.save()
        elif product not in ProductIndex.objects.filter(product_id=product.id):
            ProductIndex.objects.filter(product_id=product.id).delete()

# Automatically update the search index when changes in the product data occur
def update_search_index():
    products = Product.objects.all()
    for product in products:
        product_index = ProductIndex.objects.filter(product_id=product.id)[0]
        product_index.name = product.name
        product_index.description = product.description
        product_index.price = product.price
        product_index.stock = product.stock
        product_index.save()

# Execute search queries against the search index instead of directly querying the database
def search(query):
    return ProductIndex.objects.filter(name__icontains=query)