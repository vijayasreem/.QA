from django.urls import path

urlpatterns = [
    path('index/', IndexView.as_view(), name='index'),
    path('search/', SearchView.as_view(), name='search'),
]