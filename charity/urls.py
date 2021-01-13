from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

from posts.views import ListCategoriesAPI

schema_view = get_schema_view(
   openapi.Info(
      title="Charity API",
      default_version='v1',
      contact=openapi.Contact(email="contact@snippets.local"),
      license=openapi.License(name="BSD License"),
   ),
   public=True,
   permission_classes=(permissions.AllowAny,),
)

urlpatterns = [
   path('admin/', admin.site.urls),
   path('api/users/', include('users.urls', namespace='users')),
   path('api/posts/', include('posts.urls', namespace='posts')),
   path('api/votes/', include('votes.urls', namespace='votes')),
   path('api/comments/', include('comments.comments_urls', namespace='comments')),
   path('api/replies/', include('comments.replies_urls', namespace='comments')),
   path('api/categories/', ListCategoriesAPI.as_view(), name='categories'),
   
   path('docs/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
