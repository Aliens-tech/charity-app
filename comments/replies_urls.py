from django.urls import path

from . import views

app_name = 'comments'

reply_list = views.ReplyViewSetAPI.as_view({'get': 'list'}) 
reply_create = views.ReplyViewSetAPI.as_view({'post': 'create'})
reply_detail = views.ReplyViewSetAPI.as_view(
    {
        'get': 'retrieve',
        'patch': 'partial_update',
        'put': 'update',
        'delete': 'destroy'
    }
)

urlpatterns = [
    path('all/<int:comment_id>/', reply_list, name='comment-reply-list'),
    path('new/<int:comment_id>/', reply_create, name='create-new-reply'),
    path('<int:pk>/', reply_detail, name='reply-detail')
]