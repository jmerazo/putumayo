import bcrypt
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db import transaction
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken

from .models import Auth, Permission, Group, UserGroup, Module, Submodule, Role, UserModulePermission, UserModule, UserSubmodule, UserSubmodulePermission
from ..person.models import Person, Dependencies, Subdependencies
from .serializers import AuthSerializer, PermissionSerializer, ModuleSerializer, SubmoduleSerializer, PasswordUpdateSerializer
from ..utils.models import TypeDocuments, Departments, Cities

def generate_tokens_for_user(user_id):
    refresh = RefreshToken()
    refresh['user_id'] = user_id
    access = refresh.access_token
    return {
        'refresh': str(refresh),
        'access': str(access),
    }

class AuthView(TokenObtainPairView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        password = request.data.get('password')

        try:
            # Buscar el registro de autenticación que corresponda al email
            auth_record = Auth.objects.select_related('a_person').get(a_person__email=email)

            if bcrypt.checkpw(password.encode('utf-8'), auth_record.password.encode('utf-8')):
                person = auth_record.a_person

                # Generar los tokens JWT
                tokens = generate_tokens_for_user(auth_record.id)

                return Response({
                    'refresh': tokens['refresh'],
                    'access': tokens['access'],
                    'authId': auth_record.id,
                    'email': person.email,
                    'first_name': person.first_name,
                    'last_name': person.last_name,
                    'cellphone': person.cellphone,
                    'address': person.address
                }, status=status.HTTP_200_OK)
            else:
                return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        except Auth.DoesNotExist:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        except Exception as e:
            return Response({'error': 'Something went wrong'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
class AuthRegisterView(APIView):
    permission_classes = []

    def post(self, request, *args, **kwargs):
        # Obtener datos del request
        p_doc_type = request.data.get('p_doc_type')
        doc_number = request.data.get('doc_number')
        first_name = request.data.get('first_name')
        last_name = request.data.get('last_name')
        email = request.data.get('email')
        password = request.data.get('password')
        cellphone = request.data.get('cellphone')
        address = request.data.get('address')
        p_department = request.data.get('p_department')
        p_city = request.data.get('p_city')
        picture = request.data.get('picture')
        is_active = request.data.get('is_active')
        a_dependencie = request.data.get('dependencie')
        a_subdependencie = request.data.get('subdependencie')
        a_rol = request.data.get('a_rol')
        a_group = request.data.get('a_group')
        ump_modules = request.data.get('ump_module', [])
        module_permissions = request.data.get('module_permissions', {})
        selected_submodules = request.data.get('selected_submodules', {})
        submodule_permissions = request.data.get('submodule_permissions', {})

        if not all([first_name, last_name, email, password, p_doc_type, doc_number, cellphone, address, p_department, p_city, is_active, a_dependencie, a_rol, a_group]):
            return Response({'error': 'All fields are required'}, status=status.HTTP_400_BAD_REQUEST)

        if Auth.objects.filter(a_person__email=email).exists():
            return Response({'error': 'User with this email already exists in Auth'}, status=status.HTTP_400_BAD_REQUEST)

        if Auth.objects.filter(a_person__doc_number=doc_number).exists():
            return Response({'error': 'User with this document number already exists in Auth'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            doc_type = TypeDocuments.objects.get(id=p_doc_type)
            department_instance = Departments.objects.get(id=p_department)
            city_instance = Cities.objects.get(id=p_city)
            arole = Role.objects.get(id=a_rol)
            agroup_instance = Group.objects.get(id=a_group)
            adependencie_instance = Dependencies.objects.get(id=a_dependencie)
            asubdependencie_instance = Subdependencies.objects.get(id=a_subdependencie)
        except (TypeDocuments.DoesNotExist, Departments.DoesNotExist, Cities.DoesNotExist, Role.DoesNotExist, Group.DoesNotExist, Dependencies.DoesNotExist, Subdependencies.DoesNotExist) as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

        try:
            person = Person.objects.get(email=email, doc_number=doc_number)
        except Person.DoesNotExist:
            person = Person.objects.create(
                p_doc_type=doc_type,
                doc_number=doc_number,
                first_name=first_name,
                last_name=last_name,
                email=email,
                cellphone=cellphone,
                address=address,
                p_department=department_instance,
                p_city=city_instance
            )

        hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

        auth_instance = Auth.objects.create(
            a_person=person,
            password=hashed_password,
            a_dependencie=adependencie_instance,
            a_subdependencie=asubdependencie_instance,
            a_rol=arole,
            picture=picture,
            is_active=is_active
        )

        auth_instance.a_group.add(agroup_instance)

        # Inserción en UserModule y UserModulePermission
        for module_id in ump_modules:
            try:
                module_instance = Module.objects.get(id=module_id)
                UserModule.objects.create(um_auth=auth_instance, um_module=module_instance)
                
                permissions = module_permissions.get(str(module_id), [])
                for permission_id in permissions:
                    try:
                        permission_instance = Permission.objects.get(id=permission_id)
                        UserModulePermission.objects.create(ump_auth=auth_instance, ump_module=module_instance, ump_permission=permission_instance)
                    except Permission.DoesNotExist:
                        return Response({'error': 'Invalid permission ID: ' + str(permission_id)}, status=status.HTTP_400_BAD_REQUEST)
            except Module.DoesNotExist:
                return Response({'error': 'Invalid module ID: ' + str(module_id)}, status=status.HTTP_400_BAD_REQUEST)

        # Inserción en UserSubmodulePermission
        for module_id, submodules in selected_submodules.items():
            for submodule in submodules:
                submodule_id = submodule if isinstance(submodule, int) else submodule.get('id', None)
                if submodule_id is None:
                    return Response({'error': f'Invalid submodule data: {submodule}'}, status=status.HTTP_400_BAD_REQUEST)
                try:
                    submodule_instance = Submodule.objects.get(id=submodule_id)
                    user_submodule, created = UserSubmodule.objects.get_or_create(
                        usm_auth=auth_instance,
                        usm_submodule=submodule_instance
                    )

                    sub_permissions = submodule_permissions.get(str(module_id), {}).get(str(submodule_id), [])
                    for permission_id in sub_permissions:
                        if isinstance(permission_id, str):
                            permission_id = int(permission_id)

                        if permission_id is None:
                            return Response({'error': f'Invalid permission data: {permission_id}'}, status=status.HTTP_400_BAD_REQUEST)

                        try:
                            permission_instance = Permission.objects.get(id=permission_id)
                            UserSubmodulePermission.objects.get_or_create(
                                usp_auth=auth_instance,
                                usp_submodule=submodule_instance,
                                usp_permission=permission_instance
                            )
                        except Permission.DoesNotExist:
                            return Response({'error': 'Invalid submodule permission ID: ' + str(permission_id)}, status=status.HTTP_400_BAD_REQUEST)
                except Submodule.DoesNotExist:
                    return Response({'error': 'Invalid submodule ID: ' + str(submodule_id)}, status=status.HTTP_400_BAD_REQUEST)

        return Response({'message': 'User registered successfully'}, status=status.HTTP_201_CREATED)

class UserModulesPermissionsView(APIView):
    authentication_classes = []  # Desactivar la autenticación
    permission_classes = []  # Desactivar los permisos
    def get(self, request, pk, *args, **kwargs):
        try:
            user = Auth.objects.get(id=pk)
            modules = Module.objects.filter(usermodule__um_auth=user)
            module_permissions = []

            for module in modules:
                submodules = Submodule.objects.filter(sm_module=module)
                permissions = Permission.objects.filter(usermodulepermission__ump_auth=user, usermodulepermission__ump_module=module)
                module_permissions.append({
                    'module': ModuleSerializer(module).data,
                    'submodules': SubmoduleSerializer(submodules, many=True).data,
                    'permissions': PermissionSerializer(permissions, many=True).data
                })

            return Response(module_permissions, status=status.HTTP_200_OK)
        except Auth.DoesNotExist:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            print(f"Unexpected error: {str(e)}")  # Depuración
            return Response({'error': 'Something went wrong', 'details': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
    def put(self, request, pk, *args, **kwargs):
        try:
            print('id: ', pk)
            print('data user: ', request.data)
            user = Auth.objects.get(id=pk)
            
            # Obtener los datos del request
            new_module_permissions = request.data.get('module_permissions', {})
            new_submodule_permissions = request.data.get('submodule_permissions', {})
            a_rol = request.data.get('a_rol')
            is_active = request.data.get('is_active')
            a_dependencie = request.data.get('a_dependencie')
            a_subdependencie = request.data.get('a_subdependencie')

            with transaction.atomic():
                # Actualizar los campos básicos del usuario
                user.a_rol_id = a_rol
                user.is_active = is_active
                user.a_dependencie_id = a_dependencie
                user.a_subdependencie_id = a_subdependencie
                user.save()

                # Actualizar módulos
                current_modules = set(UserModule.objects.filter(um_auth=user).values_list('um_module_id', flat=True))
                new_modules = set(map(int, new_module_permissions.keys()))
                modules_to_remove = current_modules - new_modules
                modules_to_add = new_modules - current_modules

                # Eliminar módulos y permisos asociados que ya no están presentes
                for module_id in modules_to_remove:
                    UserModule.objects.filter(um_auth=user, um_module_id=module_id).delete()
                    UserModulePermission.objects.filter(ump_auth=user, ump_module_id=module_id).delete()

                # Agregar nuevos módulos y permisos asociados
                for module_id in modules_to_add:
                    module_instance = Module.objects.get(id=module_id)
                    UserModule.objects.create(um_auth=user, um_module=module_instance)

                # Actualizar permisos de los módulos presentes
                for module_id, permissions in new_module_permissions.items():
                    module_instance = Module.objects.get(id=int(module_id))
                    current_permissions = UserModulePermission.objects.filter(ump_auth=user, ump_module=module_instance)
                    current_permission_ids = current_permissions.values_list('ump_permission_id', flat=True)

                    # Eliminar permisos que ya no están presentes
                    for current_permission in current_permissions:
                        if current_permission.ump_permission_id not in permissions:
                            current_permission.delete()

                    # Agregar nuevos permisos
                    for permission_id in permissions:
                        if permission_id not in current_permission_ids:
                            permission_instance = Permission.objects.get(id=permission_id)
                            UserModulePermission.objects.create(
                                ump_auth=user,
                                ump_module=module_instance,
                                ump_permission=permission_instance
                            )

                # Actualizar submódulos y sus permisos
                current_submodules = set(UserSubmodule.objects.filter(usm_auth=user).values_list('usm_submodule_id', flat=True))
                new_submodules = set(map(int, new_submodule_permissions.keys()))
                submodules_to_remove = current_submodules - new_submodules
                submodules_to_add = new_submodules - current_submodules

                # Eliminar submódulos y permisos asociados que ya no están presentes
                for submodule_id in submodules_to_remove:
                    UserSubmodule.objects.filter(usm_auth=user, usm_submodule_id=submodule_id).delete()
                    UserSubmodulePermission.objects.filter(usp_auth=user, usp_submodule_id=submodule_id).delete()

                # Agregar nuevos submódulos y permisos asociados
                for submodule_id in submodules_to_add:
                    submodule_instance = Submodule.objects.get(id=submodule_id)
                    UserSubmodule.objects.create(usm_auth=user, usm_submodule=submodule_instance)

                # Actualizar permisos de los submódulos presentes
                for submodule_id, permissions in new_submodule_permissions.items():
                    submodule_instance = Submodule.objects.get(id=int(submodule_id))
                    current_permissions = UserSubmodulePermission.objects.filter(usp_auth=user, usp_submodule=submodule_instance)
                    current_permission_ids = current_permissions.values_list('usp_permission_id', flat=True)

                    # Eliminar permisos que ya no están presentes
                    for current_permission in current_permissions:
                        if current_permission.usp_permission_id not in permissions:
                            current_permission.delete()

                    # Agregar nuevos permisos
                    for permission_id in permissions:
                        if permission_id not in current_permission_ids:
                            permission_instance = Permission.objects.get(id=permission_id)
                            UserSubmodulePermission.objects.create(
                                usp_auth=user,
                                usp_submodule=submodule_instance,
                                usp_permission=permission_instance
                            )

            return Response({'msg': 'Permissions updated successfully'}, status=status.HTTP_200_OK)
        except Auth.DoesNotExist:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            print(f"Unexpected error: {str(e)}")  # Depuración
            return Response({'error': 'Something went wrong', 'details': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class UsersGroupView(APIView):
    def get(self, request, *args, **kwargs):
        group_name = request.query_params.get('idgroup')
        group = Group.objects.get(name=group_name)
        user_groups = UserGroup.objects.filter(ug_group=group)
        users = [ug.ug_auth for ug in user_groups]

        serializer = AuthSerializer(users, many=True)
        return Response(serializer.data)
    
class UsersView(APIView):
    def get(self, request, *args, **kwargs):
        try:
            users = Auth.objects.all()
            serializer = AuthSerializer(users, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def delete(self, request, pk, format=None):
        try:
            auth = Auth.objects.get(pk=pk)
            auth.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Auth.DoesNotExist:
            print(f'User with pk {pk} does not exist.')
            return Response(status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            print(f'Error deleting user: {e}')
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
class UpdatePasswordView(APIView):
    def put(self, request, pk, *args, **kwargs):
        try:
            user = Auth.objects.get(id=pk)
        except Auth.DoesNotExist:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = PasswordUpdateSerializer(data=request.data)
        if serializer.is_valid():
            serializer.update(user, serializer.validated_data)
            return Response({'msg': 'Password updated successfully'}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    