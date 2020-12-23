from django.urls import path
from . import views

app_name = 'users'

urlpatterns = [
    path('signup/', views.SignupAPIView.as_view(), name='create-user'),
    path('login/', views.LoginAPIView.as_view(), name='login-user'),
    path('logout/', views.LogoutAPIView.as_view(), name='logout-user'),
    path('get-user-data/',views.GetUserDataAPI.as_view(), name='get-user-data')
]
