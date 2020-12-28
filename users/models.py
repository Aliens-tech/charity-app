from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    phone = models.CharField(max_length=20, unique=True)
    email = models.EmailField(unique=True)

    def __str__(self):
        return self.username

class StarUser(models.Model):
    from_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='stars_user')
    to_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='stars')

    def __str__(self):
        return self.from_user.username + ' stars ' + self.to_user.username