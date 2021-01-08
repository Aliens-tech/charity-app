from rest_framework import serializers

from .models import Post, Category, PostImage

class PostImageSerializer(serializers.ModelSerializer):
    img = serializers.SerializerMethodField()

    class Meta:
        model = PostImage
        fields = ('img',)

    def get_img(self, obj):
        return obj.img.url

class PostSerializer(serializers.ModelSerializer):
    
    catgories = serializers.StringRelatedField(many=True)
    user = serializers.StringRelatedField()
    images = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = ("id", "catgories", "user", "images", "title", "description") 

    def get_images(self, obj):
        serializer = PostImageSerializer(obj.images.all(), many=True)
        return serializer.data

class PostDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        exclude = ('user',)