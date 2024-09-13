from rest_framework import serializers
from .models import TypeDocuments, Departments, Cities, CalendarEvents, News, NewsCategory
from ..person.models import Dependencies, Subdependencies, Person
from ..auth.models import Auth

class TypeDocumentsSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = TypeDocuments
        fields = '__all__'

class DepartmentSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Departments
        fields = '__all__'

class CitiesSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Cities
        fields = '__all__'

class DependencieCalendarSerializer(serializers.ModelSerializer):
    class Meta:
        model = Dependencies
        fields = ['id', 'name']

class SubdependencieCalendarSerializer(serializers.ModelSerializer):
    class Meta:
        model = Subdependencies
        fields = ['id', 'name']

class PersonCalendarSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = ['id', 'first_name', 'last_name']

class CalendarEventsSerializer(serializers.ModelSerializer):
    c_dependencie = DependencieCalendarSerializer()
    c_subdependencie = SubdependencieCalendarSerializer()
    organizer = PersonCalendarSerializer()
    dependency = DependencieCalendarSerializer() 

    class Meta:
        model = CalendarEvents
        fields = '__all__'

class NewsCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = NewsCategory
        fields = '__all__'

class AuthNewsSerializer(serializers.ModelSerializer):
    a_person = PersonCalendarSerializer()

    class Meta:
        model = Auth
        fields = ['id', 'a_person']

class NewsSerializer(serializers.ModelSerializer):
    category = NewsCategorySerializer()
    author = AuthNewsSerializer()

    class Meta:
        model = News
        fields = '__all__'

class NewsCreateSerializer(serializers.ModelSerializer):
    category = serializers.PrimaryKeyRelatedField(queryset=NewsCategory.objects.all())
    author = serializers.PrimaryKeyRelatedField(queryset=Auth.objects.all())
    
    class Meta:
        model = News
        fields = '__all__'