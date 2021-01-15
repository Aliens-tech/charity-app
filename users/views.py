from rest_framework.generics import CreateAPIView, GenericAPIView
from rest_framework import status, permissions
from rest_framework.response import Response
from rest_framework.generics import GenericAPIView
from rest_framework.views import APIView
from rest_framework.authtoken.models import Token

from django.contrib.auth import authenticate

from .serializers import (
    SignupUserSerializer, 
    UserDataSerializer,
    UserUpdateSerializer
)

from .models import User, StarUser

from posts.serializers import PostUserDataSerializer, PostSerializer
from posts.models import Post

class SignupAPIView(GenericAPIView):
    serializer_class = SignupUserSerializer

    permission_classes = (permissions.AllowAny,)

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
    permission_classes = (permissions.AllowAny,)

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

class GetUserCurrentDataAPI(APIView):
    def get(self, request):
        user_serializer =  UserDataSerializer(request.user)
        return Response(user_serializer.data, status=status.HTTP_200_OK)

class GetUserProfileAPI(APIView):
    def get(self, request, user_id):
        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response(
                {'error': 'user does not exist'},
                status=status.HTTP_404_NOT_FOUND
            )
        user_serializer = UserDataSerializer(user)
        requests_post_serializer = PostUserDataSerializer(user.posts.filter(post_type='R'), many=True)
        offers_post_serializer = PostUserDataSerializer(user.posts.filter(post_type='O'), many=True)

        return Response(
            {
                'user': user_serializer.data,
                'requests': requests_post_serializer.data,
                'offers': offers_post_serializer.data
            },
            status=status.HTTP_200_OK
        )

class UpdateUserAPI(GenericAPIView):
    queryset = User.objects.all()
    serializer_class = UserUpdateSerializer

    def put(self, request):
        serializer = self.get_serializer(instance=request.user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            returned_serializer = UserDataSerializer(request.user)
            return Response(
                {'data': returned_serializer.data},
                status=status.HTTP_200_OK
            )
        else:
            return Response(
                {'error': serializer.errors},
                status=status.HTTP_400_BAD_REQUEST
            )

class DeleteProfileImageAPI(APIView):
    def delete(self, request):
        if request.user.image:
            request.user.image = None
            request.user.save()
            return Response(status=status.HTTP_204_NO_CONTENT)
        else:
            return Response(
                {'error': 'user does not have image'},
                status=status.HTTP_400_BAD_REQUEST
            )

class AddProfileImageAPI(APIView):
    def post(self, request):
        if request.data.get('image'):
            request.user.image = request.data.get('image')
            request.user.save()
            return Response(
                {'data': 'image added'},
                status=status.HTTP_201_CREATED
            )
        else:
            return Response(
                {'error': 'you do not add image'},
                status=status.HTTP_400_BAD_REQUEST
            )

class ToggleStarUser(APIView):
    def post(self, request, user_id):
        # get user by id
        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response(
                {'error': 'user is not exist'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # check if the current user starts user
        star_user_object = StarUser.objects.filter(
            from_user=request.user,
            to_user=user).first()
        
        # staring object exists so will delete the star from user 
        if star_user_object:
            
            # delete the object 
            star_user_object.delete()

            # return response 
            return Response(
                {"data": 'star removed'},
                status=status.HTTP_204_NO_CONTENT
            )

        # staring object does not exist, so will add the star to the user
        else:
            # create star to the user 
            new_star_object = StarUser.objects.create(
                from_user=request.user,
                to_user=user
            )

            # return response 
            return Response(
                {'data': 'star added'},
                status=status.HTTP_201_CREATED
            )