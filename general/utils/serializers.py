from rest_framework import serializers
from .models import Dependencies, Subdependencies, TypeDocuments, Departments, Cities

class DependenciesSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Dependencies
        fields = '__all__'

class SubdependenciesSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Subdependencies
        fields = '__all__'

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