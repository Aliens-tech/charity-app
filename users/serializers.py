from rest_framework import serializers
from .models import User

class SignupUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'phone']

    
    def create(self, validated_data):
        user = User.objects.create(
            username=validated_data['username'],
            email=validated_data['email'],
            phone=validated_data['phone']
        )
        user.set_password(validated_data['password'])
        user.save()

        return user

class UserDataSerializer(serializers.ModelSerializer):
    stars = serializers.SerializerMethodField()
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'phone', 'stars')
    
    def get_stars(self, obj):
        return obj.stars.all().count()