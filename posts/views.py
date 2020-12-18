from rest_framework import viewsets, permissions, status
from rest_framework.generics import ListAPIView
from rest_framework.response import Response

from .models import Post, Category
from .serializers import PostSerializer, PostDetailsSerializer
from .permissions import IsOwner

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()

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

    def get_serializer_class(self):
        
        if self.action == 'list' or self.action == 'retrieve':
            return PostSerializer
        else:
            return PostDetailsSerializer
    
    def create(self, request):
        
        serializer = PostDetailsSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PostsOffersListAPI(ListAPIView):
    queryset = Post.objects.filter(post_type='O')
    serializer_class = PostSerializer

class PostsReuqestsListAPI(ListAPIView):
    queryset = Post.objects.filter(post_type='R')
    serializer_class = PostSerializer