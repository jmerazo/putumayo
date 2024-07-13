from rest_framework import serializers
from .models import Auth, Role, Group, Permission, RolePermission, GroupRole, UserGroup, UserModule, UserModulePermission, Module
from ..person.serializers import PersonSerializer

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

class ModuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Module
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
    a_rol = RoleSerializer()
    a_group = GroupSerializer(many=True)

    class Meta:
        model = Auth
        fields = ['a_person', 'a_rol', 'a_group']
