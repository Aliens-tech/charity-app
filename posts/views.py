
from rest_framework import viewsets
from rest_framework import permissions
from rest_framework.generics import ListAPIView

from .models import Post, Category
from .serializers import PostSerializer
from .permissions import IsOwner

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def get_permissions(self):
        if self.action == 'list' or self.action =='retrieve':
            permission_classes = (permissions.AllowAny,)

        elif self.action == 'create':
            permission_classes = (permissions.IsAuthenticated,)

        elif self.action == 'update' or self.action == 'destroy' \
            or self.action == 'partial_update':
            permission_classes = (permissions.IsAuthenticated, IsOwner)

        else:
            permission_classes = (permissions.IsAdminUser,)
        
        return [permission() for permission in permission_classes]

class PostsOffersListAPI(ListAPIView):
    queryset = Post.objects.filter(post_type='O')
    serializer_class = PostSerializer

class PostsReuqestsListAPI(ListAPIView):
    queryset = Post.objects.filter(post_type='R')
    serializer_class = PostSerializer