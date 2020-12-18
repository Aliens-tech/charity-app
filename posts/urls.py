from django.urls import path

from rest_framework.routers import DefaultRouter

from .views import (
    PostViewSet,
    PostsOffersListAPI,
    PostsReuqestsListAPI
)

app_name = 'posts'

router = DefaultRouter()
router.register('', PostViewSet, basename='posts')

urlpatterns = [
    path('offers/', PostsOffersListAPI.as_view(), name='offers-posts'),
    path('requests/', PostsReuqestsListAPI.as_view(), name='requests-posts')
]

urlpatterns += router.urls