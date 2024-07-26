from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken
from .models import Auth, Permission, Group, UserGroup, Module, Submodule, Role, UserModulePermission, UserModule
from ..person.models import Person, Dependencies, Subdependencies
from .serializers import AuthSerializer, PermissionSerializer, ModuleSerializer, SubmoduleSerializer
from ..utils.models import TypeDocuments, Departments, Cities
import bcrypt

def generate_tokens_for_user(user_id):
    refresh = RefreshToken()
    refresh['user_id'] = user_id
    access = refresh.access_token
    return {
        'refresh': str(refresh),
        'access': str(access),
    }

class AuthView(TokenObtainPairView):
    permission_classes = []

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
        #print('data save user: ', p_doc_type, doc_number, first_name, last_name, email, password, cellphone, address, p_department, p_city, picture, is_active, a_dependencie, a_subdependencie, a_rol, a_group, ump_modules, module_permissions)

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
                
                # Obtener permisos para este módulo
                permissions = module_permissions.get(str(module_id), [])
                for permission_id in permissions:
                    try:
                        permission_instance = Permission.objects.get(id=permission_id)
                        UserModulePermission.objects.create(ump_auth=auth_instance, ump_module=module_instance, ump_permission=permission_instance)
                    except Permission.DoesNotExist:
                        return Response({'error': 'Invalid permission ID: ' + str(permission_id)}, status=status.HTTP_400_BAD_REQUEST)
            except Module.DoesNotExist:
                return Response({'error': 'Invalid module ID: ' + str(module_id)}, status=status.HTTP_400_BAD_REQUEST)

        return Response({'message': 'User registered successfully'}, status=status.HTTP_201_CREATED)

class UserModulesPermissionsView(APIView):
    def get(self, request, pk, *args, **kwargs):
        try:
            user = Auth.objects.get(a_person__id=pk)
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