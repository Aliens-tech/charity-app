from rest_framework.viewsets import ModelViewSet
from rest_framework import permissions, status
from rest_framework.response import Response

from posts.models import Post

from .models import Comment, Reply
from .permission import IsOwner
from .serializers import (
    CommentListSerializer,
    CommentDetailSerializer,
    ReplyListSerializer,
    ReplyDetailSerializer
)

# Comment ViewSetAPI
class CommentViewSetAPI(ModelViewSet):
    
    queryset = Comment.objects.all()

    # permissions 
    def get_permissions(self):
        if self.action == 'list' or self.action == 'retrieve':
            permission_classes = (permissions.AllowAny,)
        elif self.action == 'create':
            permission_classes = (permissions.IsAuthenticated,)
        else:
            permission_classes = (permissions.IsAuthenticated, IsOwner)
        
        return [permission() for permission in permission_classes]

    # serializers
    def get_serializer_class(self):
        if self.action == 'list' or self.action == 'retrieve':
            return CommentListSerializer
        else:
            return CommentDetailSerializer

    # methods (CRUD) 
    def list(self, request, post_id):
        # check for post by id 
        try:
            post = Post.objects.get(id=post_id)
        except Post.DoesNotExist:
            return Response(
                {'error': 'post is not exist'},
                status=status.HTTP_404_NOT_FOUND
            )
        queryset = post.comments.all()
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def create(self, request, post_id):
        # check for post by id 
        try:
            post = Post.objects.get(id=post_id)
        except Post.DoesNotExist:
            return Response(
                {'error': 'post is not exist'},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save(author=request.user, post=post)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# Reply ViewSetAPI
class ReplyViewSetAPI(ModelViewSet):
    queryset = Reply.objects.all()

    # permissions 
    def get_permissions(self):
        if self.action == 'list' or self.action == 'retrieve':
            permission_classes = (permissions.AllowAny,)
        elif self.action == 'create':
            permission_classes = (permissions.IsAuthenticated,)
        else:
            permission_classes = (permissions.IsAuthenticated, IsOwner)
        
        return [permission() for permission in permission_classes]
    
    #serializers
    def get_serializer_class(self):
        if self.action =='list' or self.action == 'retrieve':
            return ReplyListSerializer
        else:
            return ReplyDetailSerializer
    
    # methods (CRUD) 
    def list(self, request, comment_id):
        # check for comment by id 
        try:
            comment = Comment.objects.get(id=comment_id)
        except Comment.DoesNotExist:
            return Response(
                {'error': 'comment is not exist'},
                status=status.HTTP_404_NOT_FOUND
            )
        queryset = comment.replies.all()
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def create(self, request, comment_id):
        # check for post by id 
        try:
            comment = Comment.objects.get(id=comment_id)
        except Comment.DoesNotExist:
            return Response(
                {'error': 'comment is not exist'},
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save(author=request.user, comment=comment)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)