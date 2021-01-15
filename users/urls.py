from django.urls import path
from . import views

app_name = 'users'

urlpatterns = [
    path('signup/', views.SignupAPIView.as_view(), name='create-user'),
    path('login/', views.LoginAPIView.as_view(), name='login-user'),
    path('logout/', views.LogoutAPIView.as_view(), name='logout-user'),
    path('get-user-data/',views.GetUserDataAPI.as_view(), name='get-user-data'),
    path('star/<int:user_id>/', views.ToggleStarUser.as_view(), name='star-user'),
    path('update/', views.UpdateUserAPI.as_view(), name='update-user'),
    path('add/image/', views.AddProfileImageAPI.as_view(), name='add-image'),
    path('remove/image/', views.DeleteProfileImageAPI.as_view(), name='delete-image')
]
