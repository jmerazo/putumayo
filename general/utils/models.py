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

class CalendarEvents(models.Model):
    title = models.CharField(max_length=255, blank=False, null=False)
    description = models.TextField(blank=False, null=False)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    c_dependencie = models.ForeignKey('general.Dependencies', on_delete=models.RESTRICT, related_name='calendar_events_as_dependencie')
    c_subdependencie = models.ForeignKey('general.Subdependencies', on_delete=models.RESTRICT, blank=True, null=True)
    dependency = models.ForeignKey('general.Dependencies', on_delete=models.CASCADE, related_name='calendar_events_as_subdependencie')
    organizer = models.ForeignKey('general.Person', on_delete=models.RESTRICT)
    official_document = models.FileField(upload_to='files/documents/calendar/', null=True, blank=True)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        managed = True
        db_table = 'calendar_events'

class NewsCategory(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True, null=True)

    class Meta:
        db_table = 'news_categories'

class News(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    summary = models.CharField(max_length=500, blank=True, null=True)
    category = models.ForeignKey(NewsCategory, on_delete=models.SET_NULL, null=True, blank=True)
    author = models.ForeignKey('general.Auth', on_delete=models.RESTRICT)  # Relaciona con el modelo de usuarios/personas
    is_active = models.BooleanField(default=True)  # Para desactivar una noticia si es necesario
    featured_image = models.CharField(max_length=250, null=True, blank=True)  # Imagen destacada
    document = models.CharField(max_length=250, null=True, blank=True)  # Documento relacionado (ej. circular oficial)
    publication_date = models.DateTimeField(auto_now_add=True)     
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'news'
        ordering = ['-publication_date']