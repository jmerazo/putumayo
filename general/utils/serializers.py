from rest_framework import serializers
from .models import TypeDocuments, Departments, Cities

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