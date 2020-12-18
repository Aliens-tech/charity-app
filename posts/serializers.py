from rest_framework import serializers

from .models import Post, Category

class PostSerializer(serializers.ModelSerializer):
    
    catgories = serializers.StringRelatedField(many=True)
    user = serializers.StringRelatedField()
    
    class Meta:
        model = Post
        fields = "__all__" 

class PostDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        exclude = ('user',)