from rest_framework.response import Response
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from rest_framework import status
from django.conf import settings
import os, random, string
from django.core.files.storage import default_storage

from .models import Departments, Cities, TypeDocuments, CalendarEvents, News, NewsCategory
from .serializers import DepartmentSerializer, CitiesSerializer, TypeDocumentsSerializer, CalendarEventsSerializer, NewsSerializer, NewsCategorySerializer, NewsCreateSerializer
from ..auth.models import Role, Group, Module, Submodule, Permission
from ..auth.serializers import RoleSerializer, GroupSerializer, ModuleSerializer, SubmoduleSerializer, PermissionSerializer, SubmoduleCreateSerializer, SubmoduleGetSerializer
from ..person.models import Dependencies, Subdependencies
from ..person.serializers import DependenciesSerializer, SubdependenciesSerializer, DependenciesCreateSerializer, SubdependenciesCreateSerializer

def generate_random_filename(extension):
    """Genera un nombre de archivo aleatorio con una extensión proporcionada."""
    random_string = ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))
    return f'{random_string}{extension}'

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
        try:
            typedocs = TypeDocuments.objects.get(pk=pk)
            typedocs.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except TypeDocuments.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
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
        try:
            role = Role.objects.get(pk=pk)
            role.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Role.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
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
        try:
            group = Group.objects.get(pk=pk)
            group.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Group.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
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
        try:
            module = Module.objects.get(pk=pk)
            module.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Module.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
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
        try:
            submodule = Submodule.objects.get(pk=pk)
            submodule.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Submodule.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
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
        try:
            permission = Permission.objects.get(pk=pk)
            permission.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Permission.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
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
        try:
            dependencie = Dependencies.objects.get(pk=pk)
            dependencie.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Dependencies.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
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
        try:
            subdependencie = Subdependencies.objects.get(pk=pk)
            subdependencie.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Subdependencies.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
class CalendarEventsView(APIView):
    def get(self, request, pk=None, subdependency=False, format=None):
        # Filtrar por dependencia si es la primera ruta
        if pk and not subdependency:
            queryset = CalendarEvents.objects.filter(c_dependencie_id=pk)
        
        # Filtrar por subdependencia si es la tercera ruta
        elif pk and subdependency:
            queryset = CalendarEvents.objects.filter(c_subdependencie_id=pk)
        
        # Si no se proveen parámetros, devolver todos los eventos
        else:
            queryset = CalendarEvents.objects.all()

        serializer = CalendarEventsSerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    # POST method
    def post(self, request, format=None):
        serializer = CalendarEventsSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    # PUT method
    def put(self, request, pk=None, format=None):
        try:
            event = CalendarEvents.objects.get(pk=pk)
        except CalendarEvents.DoesNotExist:
            return Response({'error': 'Event not found'}, status=status.HTTP_404_NOT_FOUND)
        
class NewsView(APIView):
    def get(self, format=None):
        queryset = News.objects.filter(is_active=True).order_by('-publication_date')
        serializer = NewsSerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def post(self, request, format=None):
        data = request.data.copy()
        image_file = request.FILES.get('featured_image')
        document_file = request.FILES.get('document')

        # Procesar la imagen
        if image_file:
            # Generar un nombre de archivo único para la imagen
            image_filename = generate_random_filename('.jpg')
            image_path = os.path.join('img', 'news', image_filename)  # Ajusta la ruta para evitar duplicación
            full_image_path = os.path.join(settings.MEDIA_ROOT, image_path).replace("\\", "/")

            # Asegúrate de que el directorio existe
            if not os.path.exists(os.path.dirname(full_image_path)):
                os.makedirs(os.path.dirname(full_image_path))

            # Guarda la imagen en la ruta especificada
            with default_storage.open(full_image_path, 'wb+') as destination:
                for chunk in image_file.chunks():
                    destination.write(chunk)

            # Guardar la ruta relativa en el campo del modelo
            data['featured_image'] = os.path.join('/files', image_path).replace("\\", "/")

        # Procesar el documento
        if document_file:
            document_ext = os.path.splitext(document_file.name)[1]  # Obtener la extensión del archivo
            document_filename = generate_random_filename(document_ext)
            document_path = os.path.join('documents', 'news', document_filename)  # Ajusta la ruta para evitar duplicación
            full_document_path = os.path.join(settings.MEDIA_ROOT, document_path).replace("\\", "/")

            # Asegúrate de que el directorio existe
            if not os.path.exists(os.path.dirname(full_document_path)):
                os.makedirs(os.path.dirname(full_document_path))

            # Guarda el documento en la ruta especificada
            with default_storage.open(full_document_path, 'wb+') as destination:
                for chunk in document_file.chunks():
                    destination.write(chunk)

            # Guardar la ruta relativa en el campo del modelo
            data['document'] = os.path.join('/files', document_path).replace("\\", "/")

        # Serializar y guardar
        serializer = NewsCreateSerializer(data=data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            print(serializer.errors)  # Para depuración adicional
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk, format=None):
        try:
            news_item = News.objects.get(pk=pk)
        except News.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        data = request.data.copy()
        image_file = request.FILES.get('featured_image')
        document_file = request.FILES.get('document')

        if image_file:
            image_filename = generate_random_filename('.jpg')
            image_path = os.path.join('files', 'img', 'news', image_filename)
            full_image_path = os.path.join(settings.MEDIA_ROOT, image_path).replace("\\", "/")

            if not os.path.exists(os.path.dirname(full_image_path)):
                os.makedirs(os.path.dirname(full_image_path))

            with default_storage.open(full_image_path, 'wb+') as destination:
                for chunk in image_file.chunks():
                    destination.write(chunk)

            data['featured_image'] = os.path.join('/files', 'img', 'news', image_filename).replace("\\", "/")

        if document_file:
            document_ext = os.path.splitext(document_file.name)[1]
            document_filename = generate_random_filename(document_ext)
            document_path = os.path.join('files', 'documents', 'news', document_filename)
            full_document_path = os.path.join(settings.MEDIA_ROOT, document_path).replace("\\", "/")

            if not os.path.exists(os.path.dirname(full_document_path)):
                os.makedirs(os.path.dirname(full_document_path))

            with default_storage.open(full_document_path, 'wb+') as destination:
                for chunk in document_file.chunks():
                    destination.write(chunk)

            data['document'] = os.path.join('/files', 'documents', 'news', document_filename).replace("\\", "/")

        serializer = NewsCreateSerializer(news_item, data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        try:
            news_item = News.objects.get(pk=pk)
        except News.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        
        news_item.is_active = False
        news_item.save()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class NewsCategoryView(APIView):
    def get(self, format=None):
        queryset = NewsCategory.objects.all()
        serializer = NewsCategorySerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)