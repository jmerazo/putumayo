import bcrypt
from rest_framework import serializers
from .models import Auth, Role, Group, Permission, RolePermission, GroupRole, UserGroup, UserModule, UserModulePermission, Module, Submodule
from ..person.serializers import PersonSerializer, DependenciesSerializer, SubdependenciesSerializer

class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = '__all__'

class GroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = '__all__'

class PermissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Permission
        fields = '__all__'

class RolePermissionSerializer(serializers.ModelSerializer):
    rp_role = RoleSerializer()
    rp_permission = PermissionSerializer()

    class Meta:
        model = RolePermission
        fields = '__all__'

class GroupRoleSerializer(serializers.ModelSerializer):
    gr_group = GroupSerializer()
    gr_role = RoleSerializer()

    class Meta:
        model = GroupRole
        fields = '__all__'

class UserGroupSerializer(serializers.ModelSerializer):
    ug_auth = serializers.PrimaryKeyRelatedField(queryset=Auth.objects.all())
    ug_group = GroupSerializer()

    class Meta:
        model = UserGroup
        fields = '__all__'

class SubmoduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Submodule
        fields = '__all__'

class ModuleSerializer(serializers.ModelSerializer):
    submodules = SubmoduleSerializer(many=True, read_only=True)
    permissions = serializers.SerializerMethodField()

    class Meta:
        model = Module
        fields = ['id', 'name', 'route', 'icon', 'submodules', 'permissions']
    
    def get_permissions(self, obj):
        user_id = self.context.get('user_id')
        permissions = Permission.objects.filter(usermodulepermission__ump_auth=user_id, usermodulepermission__ump_module=obj)
        return PermissionSerializer(permissions, many=True).data

class SubmoduleGetSerializer(serializers.ModelSerializer):
    sm_module = ModuleSerializer()

    class Meta:
        model = Submodule
        fields = '__all__'
    
class SubmoduleCreateSerializer(serializers.ModelSerializer):
    sm_module = serializers.PrimaryKeyRelatedField(queryset=Module.objects.all())

    class Meta:
        model = Submodule
        fields = '__all__'

class UserModuleSerializer(serializers.ModelSerializer):
    um_auth = serializers.PrimaryKeyRelatedField(queryset=Auth.objects.all())
    um_module = ModuleSerializer()

    class Meta:
        model = UserModule
        fields = '__all__'

class UserModulePermissionSerializer(serializers.ModelSerializer):
    ump_auth = serializers.PrimaryKeyRelatedField(queryset=Auth.objects.all())
    ump_module = ModuleSerializer()
    ump_permission = PermissionSerializer()

    class Meta:
        model = UserModulePermission
        fields = '__all__'

class AuthSerializer(serializers.ModelSerializer):
    a_person = PersonSerializer()
    a_dependencie = DependenciesSerializer()
    a_subdependencie = SubdependenciesSerializer()
    a_rol = RoleSerializer()
    a_group = GroupSerializer(many=True)
    modules = serializers.SerializerMethodField()

    class Meta:
        model = Auth
        fields = ['id', 'a_person', 'a_dependencie', 'a_subdependencie', 'a_rol', 'a_group', 'modules']
    
    def get_modules(self, obj):
        user_modules = UserModule.objects.filter(um_auth=obj)
        modules = [user_module.um_module for user_module in user_modules]
        return ModuleSerializer(modules, many=True, context={'user_id': obj.id}).data
    
class PasswordUpdateSerializer(serializers.Serializer):
    password = serializers.CharField(write_only=True)
    confirm_password = serializers.CharField(write_only=True)

    def validate(self, data):
        if data['password'] != data['confirm_password']:
            raise serializers.ValidationError("Passwords do not match.")
        return data

    def update(self, instance, validated_data):
        password = validated_data['password']
        hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        instance.password = hashed_password
        instance.save()
        return instance