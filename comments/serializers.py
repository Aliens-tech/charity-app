from rest_framework import serializers

from .models import Comment, Reply

# CommentSerializer for list or retrieve
class CommentListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = '__all__'

# CommentSerializer for create, update
class CommentDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ('content',)


# ReplySerializer for list or retrieve
class ReplyListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reply
        fields = '__all__'

# ReplySerializer for create or update
class ReplyDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reply
        fields = ('content',)