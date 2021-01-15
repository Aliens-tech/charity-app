from django.db import models
from users.models import User

class Category(models.Model):
    name = models.CharField(max_length=50)

    def __str__(self):
        return self.name
    
    class Meta:
        verbose_name_plural = 'Categories'
         
class Post(models.Model):

    # Post types
    POST_STATUS_TYPES = (
        ('O', 'Offer'),
        ('R', 'Request')
    )

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='posts')
    post_type = models.CharField(choices=POST_STATUS_TYPES, max_length=1, default='O')
    categories = models.ManyToManyField(Category)
    title = models.CharField(max_length=100)
    address = models.CharField(max_length=100, default='')
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


    class Meta:
        ordering = ('-created_at',)

    def __str__(self):
        return self.title

class PostImage(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='images')
    img = models.ImageField(upload_to='media/')

    def __str__(self):
        return str(self.id)
