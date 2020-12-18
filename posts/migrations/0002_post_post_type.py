# Generated by Django 3.1.3 on 2020-12-18 12:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('posts', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='post',
            name='post_type',
            field=models.CharField(choices=[('O', 'Offer'), ('R', 'Request')], default='O', max_length=1),
        ),
    ]
