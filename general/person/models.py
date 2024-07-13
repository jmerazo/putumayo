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
    picture = models.CharField(max_length=250, null=False, blank=False)

    class Meta:
        managed = True
        db_table = 'Person'