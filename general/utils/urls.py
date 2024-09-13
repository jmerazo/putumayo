from django.urls import path
from .views import DepartmentsView, CitiesView, TypeDocumentsView, RoleView, GroupView, ModuleView, SubmoduleView, PermissionView, DependenciesView, SubdependenciesView, CalendarEventsView, NewsView, NewsCategoryView

urlpatterns = [
    path('departments/', DepartmentsView.as_view()),
    path('cities/', CitiesView.as_view()),
    path('typedocs/', TypeDocumentsView.as_view()),
    path('typedocs/<int:pk>', TypeDocumentsView.as_view()),
    path('roles/', RoleView.as_view()),
    path('roles/<int:pk>', RoleView.as_view()),
    path('groups/', GroupView.as_view()),
    path('groups/<int:pk>', GroupView.as_view()),
    path('modules/', ModuleView.as_view()),
    path('modules/<int:pk>', ModuleView.as_view()),
    path('submodules/', SubmoduleView.as_view()),
    path('submodules/<int:pk>', SubmoduleView.as_view()),
    path('permissions/', PermissionView.as_view()),
    path('permissions/<int:pk>', PermissionView.as_view()),
    path('dependencies/', DependenciesView.as_view()),
    path('dependencies/<int:pk>', DependenciesView.as_view()),
    path('subdependencies/', SubdependenciesView.as_view()),
    path('subdependencies/<int:pk>', SubdependenciesView.as_view()),
    path('calendar/events/', CalendarEventsView.as_view()),
    path('calendar/events/dependencies/<int:pk>', CalendarEventsView.as_view()),
    path('calendar/events/subdependencies/<int:pk>', CalendarEventsView.as_view(), {'subdependency': True}),
    path('news/', NewsView.as_view()),
    path('news/<int:pk>/', NewsView.as_view()),
    path('news/category/', NewsCategoryView.as_view()),
]