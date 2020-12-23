from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from posts.models import Post
from .models import Upvote, Downvote

class UpvotePost(APIView):
    def post(self, request, post_id):
        try:
            post = Post.objects.get(id=post_id)
        except Post.DoesNotExist:
            return Response(
                {'error' : 'Post id is not exist'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        Upvote.objects.create(
            user=request.user,
            post=post
        )
        return Response(
            {'data': 'upvoted successfully.'},
            status=status.HTTP_201_CREATED
        )

class DownvotePost(APIView):
    def post(self, request, post_id):
        try:
            post = Post.objects.get(id=post_id)
        except Post.DoesNotExist:
            return Response(
                {'error' : 'Post id is not exist'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        Downvote.objects.create(
            user=request.user,
            post=post
        )
        return Response(
            {'data': 'downvoted successfully.'},
            status=status.HTTP_201_CREATED
        )
class VotePostCount(APIView):
    def get(self, request, post_id):
        try:
            post = Post.objects.get(id=post_id)
        except Post.DoesNotExist:
            return Response(
                {'error' : 'Post id is not exist'},
                status=status.HTTP_404_NOT_FOUND
            )
        upvote_counts = Upvote.objects.filter(post=post).count()
        downvote_counts = Downvote.objects.filter(post=post).count()
        return Response(
            {'data':{
                'upvotes': upvote_counts,
                'dowvotes': downvote_counts
                }
            },
            status=status.HTTP_200_OK
            )