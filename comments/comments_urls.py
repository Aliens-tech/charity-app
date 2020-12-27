from django.urls import path

from . import views

app_name = 'comments'
comment_list = views.CommentViewSetAPI.as_view({'get': 'list'}) 
comment_create = views.CommentViewSetAPI.as_view({'post': 'create'})
comment_detail = views.CommentViewSetAPI.as_view(
    {
        'get': 'retrieve',
        'patch': 'partial_update',
        'put': 'update',
        'delete': 'destroy'
    }
)

urlpatterns = [
    path('all/<int:post_id>/', comment_list, name='post-comments-list'),
    path('new/<int:post_id>/', comment_create, name='create-new-comment'),
    path('<int:pk>/', comment_detail, name='comment-detail')
]