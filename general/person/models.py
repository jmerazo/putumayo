from django.db import models
from ..utils.models import TypeDocuments
from ..utils.models import Departments, Cities

class Person(models.Model):
    p_doc_type = models.ForeignKey(TypeDocuments, on_delete=models.RESTRICT)
    doc_number = models.CharField(max_length=30, null=False, blank=False)
    first_name = models.CharField(max_length=60, null=False, blank=False)
    last_name = models.CharField(max_length=60, null=False, blank=False)
    email = models.CharField(max_length=100, null=True, blank=True)
    cellphone = models.CharField(max_length=20, null=True, blank=True)
    address = models.CharField(max_length=100, null=True, blank=True)
    p_department = models.ForeignKey(Departments, on_delete=models.RESTRICT)
    p_city = models.ForeignKey(Cities, on_delete=models.RESTRICT)

    class Meta:
        managed = True
        db_table = 'Person'

# Create your models here.
class Dependencies(models.Model):
    name = models.CharField(max_length=80)
    d_person = models.ForeignKey(Person, null=True, on_delete=models.RESTRICT)
    acronym = models.CharField(max_length=30)

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