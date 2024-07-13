from django.contrib.auth.models import User
from django.db import models

# Create your models here.
class Dependencies(models.Model):
    name = models.CharField(max_length=80)
    user = models.ForeignKey(User, null=True, on_delete=models.SET_NULL)

    class Meta:
        managed = True
        db_table = 'dependencies'

    def __str__(self):
        return self.name

class Subdependencies(models.Model):
    name = models.CharField(max_length=80, blank=False, null=False)
    dependencie = models.ForeignKey(Dependencies, on_delete=models.RESTRICT)
    acronym = models.CharField(max_length=5, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'subdependencies'
    
class TypeDocuments(models.Model):
    name = models.CharField(max_length=60, blank=False, null=False)

    class Meta:
        managed = True
        db_table = 'type_documents'

class Departments(models.Model):
    code = models.IntegerField(unique=True)
    name = models.CharField(max_length=100, blank=False, null=False)

    class Meta:
        managed = True
        db_table = 'departments'

class Cities(models.Model):
    code = models.IntegerField()
    name = models.CharField(max_length=60, blank=False, null=False)
    department_id = models.IntegerField(blank=False, null=False)

    class Meta:
        managed = True
        db_table = 'cities'