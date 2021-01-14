from django.urls import path

from rest_framework.routers import DefaultRouter

from .views import (
    PostViewSet,
    PostsOffersListAPI,
    PostsReuqestsListAPI,
    FilterByPrice,
    FilterByAlphapetical,
    SearchPostTitleAPI
)

app_name = 'posts'

router = DefaultRouter()
router.register('', PostViewSet, basename='posts')

urlpatterns = [
    path('offers/', PostsOffersListAPI.as_view(), name='offers-posts'),
    path('requests/', PostsReuqestsListAPI.as_view(), name='requests-posts'),
    path('filter/price/', FilterByPrice.as_view(), name='filter-by-price'),
    path('filter/alpha/', FilterByAlphapetical.as_view(), name='filter-by-alpha'),
    path('search/', SearchPostTitleAPI.as_view(), name='search-by-title'),
    
]

urlpatterns += router.urls