from django.contrib import admin

from .models import User, StarUser

admin.site.register(User)
admin.site.register(StarUser)