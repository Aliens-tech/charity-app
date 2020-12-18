from rest_framework import serializers

from .models import Post, Category

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = "__all__" 

class PostDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        exclude = ('user',)