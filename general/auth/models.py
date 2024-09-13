from django.db import models
from ..person.models import Person, Dependencies, Subdependencies

class Role(models.Model):
    name = models.CharField(max_length=50, blank=False, null=False)

    class Meta:
        managed = True
        db_table = 'roles'

class Group(models.Model):
    name = models.CharField(max_length=50, blank=False, null=False)

    class Meta:
        managed = True
        db_table = 'groups'

class Auth(models.Model):
    a_person = models.ForeignKey(Person, on_delete=models.RESTRICT)
    password = models.CharField(max_length=250, null=False, blank=False)
    a_rol = models.ForeignKey(Role, on_delete=models.RESTRICT)
    a_dependencie = models.ForeignKey(Dependencies, on_delete=models.RESTRICT)
    a_subdependencie = models.ForeignKey(Subdependencies, on_delete=models.RESTRICT)
    a_group = models.ManyToManyField(Group, through='UserGroup')
    picture = models.CharField(max_length=250, null=True, blank=True)
    is_active = models.SmallIntegerField(null=False, blank=False)

    class Meta:
        managed = True
        db_table = 'auth'

class Permission(models.Model):
    name = models.CharField(max_length=50, blank=False, null=False)

    class Meta:
        managed = True
        db_table = 'permissions'

class RolePermission(models.Model):
    rp_role = models.ForeignKey(Role, on_delete=models.RESTRICT)
    rp_permission = models.ForeignKey(Permission, on_delete=models.RESTRICT)

    class Meta:
        managed = True
        db_table = 'role_permissions'
        unique_together = ('rp_role', 'rp_permission')

class GroupRole(models.Model):
    gr_group = models.ForeignKey(Group, on_delete=models.RESTRICT)
    gr_role = models.ForeignKey(Role, on_delete=models.RESTRICT)

    class Meta:
        managed = True
        db_table = 'group_roles'
        unique_together = ('gr_group', 'gr_role')

class UserGroup(models.Model):
    ug_auth = models.ForeignKey(Auth, on_delete=models.CASCADE)
    ug_group = models.ForeignKey(Group, on_delete=models.CASCADE)

    class Meta:
        managed = True
        db_table = 'user_groups'
        unique_together = ('ug_auth', 'ug_group')

class Module(models.Model):
    name = models.CharField(max_length=50, blank=False, null=False)
    route = models.CharField(max_length=50, blank=False, null=False)
    icon = models.CharField(max_length=100, blank=False, null=False)

    class Meta:
        managed = True
        db_table = 'modules'

class Submodule(models.Model):
    name = models.CharField(max_length=50, blank=False, null=False)
    route = models.CharField(max_length=50, blank=False, null=False)
    icon = models.CharField(max_length=100, blank=False, null=False)
    sm_module = models.ForeignKey(Module, on_delete=models.RESTRICT, related_name='submodules')

    class Meta:
        managed = True
        db_table = 'submodules'

class UserModule(models.Model):
    um_auth = models.ForeignKey(Auth, on_delete=models.CASCADE)
    um_module = models.ForeignKey(Module, on_delete=models.CASCADE)

    class Meta:
        managed = True
        db_table = 'user_modules'
        unique_together = ('um_auth', 'um_module')

class UserSubmodule(models.Model):
    usm_auth = models.ForeignKey(Auth, on_delete=models.CASCADE)
    usm_submodule = models.ForeignKey(Submodule, on_delete=models.CASCADE)

    class Meta:
        managed = True
        db_table = 'user_submodules'
        unique_together = ('usm_auth', 'usm_submodule')

class UserModulePermission(models.Model):
    ump_auth = models.ForeignKey(Auth, on_delete=models.CASCADE)
    ump_module = models.ForeignKey(Module, on_delete=models.CASCADE)
    ump_permission = models.ForeignKey(Permission, on_delete=models.CASCADE)

    class Meta:
        managed = True
        db_table = 'user_module_permission'
        unique_together = ('ump_auth', 'ump_module', 'ump_permission')     

class UserSubmodulePermission(models.Model):
    usp_auth = models.ForeignKey(Auth, on_delete=models.CASCADE)
    usp_submodule = models.ForeignKey(Submodule, on_delete=models.CASCADE)
    usp_permission = models.ForeignKey(Permission, on_delete=models.CASCADE)

    class Meta:
        managed = True
        db_table = 'user_submodule_permission'
        unique_together = ('usp_auth', 'usp_submodule', 'usp_permission')