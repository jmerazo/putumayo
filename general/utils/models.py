from django.db import models
    
class TypeDocuments(models.Model):
    name = models.CharField(max_length=60, blank=False, null=False)
    acronym = models.CharField(max_length=30, blank=True, null=False)

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