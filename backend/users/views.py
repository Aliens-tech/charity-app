from rest_framework import status
from rest_framework.response import Response
from rest_framework.generics import GenericAPIView
from rest_framework.views import APIView
from rest_framework.authtoken.models import Token

from django.contrib.auth import authenticate

from .serializers import SignupUserSerializer

class SignupAPIView(GenericAPIView):
    serializer_class = SignupUserSerializer
    
    def post(self, request):
        user_serializer = SignupUserSerializer(data=request.data)

        if user_serializer.is_valid():
            user_serializer.save()
            return Response(
                {'data': user_serializer.data}, 
                status=status.HTTP_201_CREATED
            )
        else:
            return Response(
                {'error': user_serializer.errors}, 
                status=status.HTTP_400_BAD_REQUEST
            )


class LoginAPIView(APIView):

    def post(self, request):
        
        data = request.data

        if not data.get('username') or not data.get('password'):
            return Response(
                {"error": "invalid data. please try again with valid data"}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        user = authenticate(username=data['username'], password=data['password'])

        if user:
            token, _ = Token.objects.get_or_create(user=user)
            return Response(
                {'token': token.key},
                status=status.HTTP_200_OK
            )
        else:
            return Response(
                {"error": "invalid data"}, 
                status=status.HTTP_404_NOT_FOUND
            )

class LogoutAPIView(APIView):

    def post(self, request):

        if request.auth and request.user:
            Token.objects.get(user=request.user).delete()
            return Response(status=status.HTTP_200_OK)
        else:
            return Response({'error': 'you are not logged in'}, status=status.HTTP_400_BAD_REQUEST)
