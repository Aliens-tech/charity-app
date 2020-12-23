from django.urls import path

from . import views

app_name = 'votes'

urlpatterns = [
    path('upvote/<int:post_id>/', views.UpvotePost.as_view(), name='upvote-post'),
    path('downvote/<int:post_id>/', views.DownvotePost.as_view(), name='downvote-post'),
    path('votes-count/<int:post_id>/', views.VotePostCount.as_view(), name='post-vote-counts')
]