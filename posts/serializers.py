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
    
    categories = serializers.SerializerMethodField()
    user = serializers.StringRelatedField()
    images = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = ("id", "categories", "user", "images", "title", "description", 'city', 'region', 'created_at', 'price') 

    def get_categories(self, obj):
        post_categories = ''
        for category in obj.categories.all():
            post_categories +='#%s '%(category.name)
        return post_categories

    def get_images(self, obj):
        serializer = PostImageSerializer(obj.images.all(), many=True)
        return serializer.data

class PostDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        exclude = ('user', 'categories')

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields ='__all__'