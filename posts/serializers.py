from rest_framework import serializers

from .models import Post, Category, PostImage

import json

class PostImageSerializer(serializers.ModelSerializer):
    img = serializers.SerializerMethodField()

    class Meta:
        model = PostImage
        fields = ('img',)

    def get_img(self, obj):
        return obj.img.url

class PostSerializer(serializers.ModelSerializer):
    
    categories = serializers.SerializerMethodField()
    user = serializers.StringRelatedField()
    images_list = serializers.SerializerMethodField()
    created_at = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = ("id", "categories", "user", "images_list", "title", "description", 'address', 'created_at',) 

    def get_categories(self, obj):
        post_categories = ''
        for category in obj.categories.all():
            post_categories +='#%s '%(category.name)
        return post_categories

    def get_images_list(self, obj):
        images_list  = obj.images.all()
        images = []
        for image in images_list:
            images.append(image.img.url)
        
        return images

    def get_created_at(self, obj):
        return obj.created_at.strftime("%m/%d/%Y, %H:%M:%S")

class PostDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        exclude = ('user', 'categories')

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields ='__all__'