from rest_framework import serializers
from .models import Person, Dependencies, Subdependencies
from ..utils.serializers import TypeDocumentsSerializer, DepartmentSerializer, CitiesSerializer
from ..utils.models import TypeDocuments, Departments, Cities

class PersonSerializer(serializers.ModelSerializer):
    p_doc_type = TypeDocumentsSerializer()
    p_department = DepartmentSerializer()
    p_city = CitiesSerializer()
    
    class Meta:
        model = Person
        fields = '__all__'

class PersonCreateSerializer(serializers.ModelSerializer):
    p_doc_type = serializers.PrimaryKeyRelatedField(queryset=TypeDocuments.objects.all())
    p_department = serializers.PrimaryKeyRelatedField(queryset=Departments.objects.all())
    p_city = serializers.PrimaryKeyRelatedField(queryset=Cities.objects.all())
    
    class Meta:
        model = Person
        fields = '__all__'

class DependenciesSerializer(serializers.ModelSerializer):
    d_person = PersonSerializer()
    
    class Meta:
        model = Dependencies
        fields = '__all__'

class DependenciesCreateSerializer(serializers.ModelSerializer):
    d_person = serializers.PrimaryKeyRelatedField(queryset=Person.objects.all())
    
    class Meta:
        model = Dependencies
        fields = '__all__'

class SubdependenciesSerializer(serializers.ModelSerializer):
    dependencie = DependenciesSerializer()
    
    class Meta:
        model = Subdependencies
        fields = '__all__'

class SubdependenciesCreateSerializer(serializers.ModelSerializer):
    dependencie = serializers.PrimaryKeyRelatedField(queryset=Dependencies.objects.all())
    
    class Meta:
        model = Subdependencies
        fields = '__all__'