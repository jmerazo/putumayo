from rest_framework.response import Response
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from rest_framework import status
from django.conf import settings
import os
from django.core.files.storage import default_storage

from .models import Departments, Cities, TypeDocuments
from .serializers import DepartmentSerializer, CitiesSerializer, TypeDocumentsSerializer
from ..auth.models import Role, Group, Module, Submodule, Permission
from ..auth.serializers import RoleSerializer, GroupSerializer, ModuleSerializer, SubmoduleSerializer, PermissionSerializer, SubmoduleCreateSerializer, SubmoduleGetSerializer
from ..person.models import Dependencies, Subdependencies
from ..person.serializers import DependenciesSerializer, SubdependenciesSerializer, DependenciesCreateSerializer, SubdependenciesCreateSerializer

class DepartmentsView(APIView):
    def get(self, request, format=None): 
        queryset = Departments.objects.all()
        serializer = DepartmentSerializer(queryset, many=True)

        return Response(serializer.data)
    
class CitiesView(APIView):
    def get(self, request, format=None): 
        queryset = Cities.objects.all()
        serializer = CitiesSerializer(queryset, many=True)

        return Response(serializer.data)
    
class TypeDocumentsView(APIView):
    def get(self, request, format=None): 
        queryset = TypeDocuments.objects.all()
        serializer = TypeDocumentsSerializer(queryset, many=True)

        return Response(serializer.data)
    
    def post(self, request, format=None):
        serializer = TypeDocumentsSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk, format=None):
        typedocs = get_object_or_404(TypeDocuments, id=pk)
        serializer = TypeDocumentsSerializer(typedocs, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        typedocs = get_object_or_404(TypeDocuments, id=pk)
        typedocs.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class RoleView(APIView):
    def get(self, request, format=None): 
        queryset = Role.objects.all()
        serializer = RoleSerializer(queryset, many=True)

        return Response(serializer.data)
    
    def post(self, request, format=None):
        serializer = RoleSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk, format=None):
        role = get_object_or_404(Role, id=pk)
        serializer = RoleSerializer(role, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        role = get_object_or_404(Role, id=pk)
        role.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class GroupView(APIView):
    def get(self, request, format=None): 
        queryset = Group.objects.all()
        serializer = GroupSerializer(queryset, many=True)

        return Response(serializer.data)
    
    def post(self, request, format=None):
        serializer = GroupSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk, format=None):
        group = get_object_or_404(Group, id=pk)
        serializer = GroupSerializer(group, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        group = get_object_or_404(Group, id=pk)
        group.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class ModuleView(APIView):
    def get(self, request, format=None): 
        queryset = Module.objects.all()
        serializer = ModuleSerializer(queryset, many=True)

        return Response(serializer.data)
    
    def post(self, request, format=None):
        data = request.data.copy()
        file = request.FILES.get('icon')
        route = data.get('route')

        if file and route:
            base_filename = f'icon_{route}'
            file_ext = os.path.splitext(file.name)[1]  # Get the file extension
            file_path = os.path.join('icons', base_filename + file_ext)
            full_path = os.path.join(settings.MEDIA_ROOT, file_path).replace("\\", "/")
            
            # Ensure the directory exists
            if not os.path.exists(os.path.dirname(full_path)):
                try:
                    os.makedirs(os.path.dirname(full_path))
                except OSError as exc:
                    return Response({'error': str(exc)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
            # Rename the file if it already exists
            counter = 1
            while os.path.exists(full_path):
                file_path = os.path.join('icons', f'{base_filename}_{counter:03d}' + file_ext)
                full_path = os.path.join(settings.MEDIA_ROOT, file_path).replace("\\", "/")
                counter += 1
            
            # Save the file
            with default_storage.open(full_path, 'wb+') as destination:
                for chunk in file.chunks():
                    destination.write(chunk)

            # Guarda la ruta relativa del archivo en el campo icon
            data['icon'] = os.path.join('/files', file_path).replace("\\", "/")

        serializer = ModuleSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk, format=None):
        module = get_object_or_404(Module, id=pk)
        serializer = ModuleSerializer(module, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        module = get_object_or_404(Module, id=pk)
        module.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class SubmoduleView(APIView):
    def get(self, request, format=None): 
        queryset = Submodule.objects.all()
        serializer = SubmoduleGetSerializer(queryset, many=True)

        return Response(serializer.data)
    
    def post(self, request, format=None):
        data = request.data.copy()
        file = request.FILES.get('icon')
        route = data.get('route')

        if file and route:
            base_filename = f'icon_{route}'
            file_ext = os.path.splitext(file.name)[1]  # Get the file extension
            file_path = os.path.join('icons', base_filename + file_ext)
            full_path = os.path.join(settings.MEDIA_ROOT, file_path).replace("\\", "/")
            
            # Ensure the directory exists
            if not os.path.exists(os.path.dirname(full_path)):
                try:
                    os.makedirs(os.path.dirname(full_path))
                except OSError as exc:
                    return Response({'error': str(exc)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
            # Rename the file if it already exists
            counter = 1
            while os.path.exists(full_path):
                file_path = os.path.join('icons', f'{base_filename}_{counter:03d}' + file_ext)
                full_path = os.path.join(settings.MEDIA_ROOT, file_path).replace("\\", "/")
                counter += 1
            
            # Save the file
            with default_storage.open(full_path, 'wb+') as destination:
                for chunk in file.chunks():
                    destination.write(chunk)

            # Guarda la ruta relativa del archivo en el campo icon
            data['icon'] = os.path.join('/files', file_path).replace("\\", "/")

        serializer = SubmoduleCreateSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk, format=None):
        submodule = get_object_or_404(Submodule, id=pk)
        serializer = SubmoduleCreateSerializer(submodule, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        submodule = get_object_or_404(Submodule, id=pk)
        submodule.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class PermissionView(APIView):
    def get(self, request, format=None): 
        queryset = Permission.objects.all()
        serializer = PermissionSerializer(queryset, many=True)

        return Response(serializer.data)
    
    def post(self, request, format=None):
        serializer = PermissionSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk, format=None):
        permission = get_object_or_404(Permission, id=pk)
        serializer = PermissionSerializer(permission, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        permission = get_object_or_404(Permission, id=pk)
        permission.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class DependenciesView(APIView):
    def get(self, request, format=None): 
        queryset = Dependencies.objects.all()
        serializer = DependenciesSerializer(queryset, many=True)

        return Response(serializer.data)
    
    def post(self, request, format=None):
        serializer = DependenciesCreateSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk, format=None):
        dependencie = get_object_or_404(Dependencies, id=pk)
        serializer = DependenciesCreateSerializer(dependencie, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        dependencie = get_object_or_404(Dependencies, id=pk)
        dependencie.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class SubdependenciesView(APIView):
    def get(self, request, format=None): 
        queryset = Subdependencies.objects.all()
        serializer = SubdependenciesSerializer(queryset, many=True)

        return Response(serializer.data)
    
    def post(self, request, format=None):
        serializer = SubdependenciesCreateSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk, format=None):
        subdependencie = get_object_or_404(Subdependencies, id=pk)
        serializer = SubdependenciesCreateSerializer(subdependencie, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk, format=None):
        subdependencie = get_object_or_404(Subdependencies, id=pk)
        subdependencie.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)