from rest_framework import serializers
from .models import Person
from ..utils.serializers import TypeDocumentsSerializer

class PersonSerializer(serializers.ModelSerializer):
    p_doc_type = TypeDocumentsSerializer()
    
    class Meta:
        model = Person
        fields = '__all__'