from django.urls import path
from .auth import AuthView, AuthRegisterView, UserModulesPermissionsView, UsersView, UpdatePasswordView

urlpatterns = [
    path('permissions/<int:pk>', UserModulesPermissionsView.as_view()),
    path('register/', AuthRegisterView.as_view()),
    path('users/', UsersView.as_view()),
    path('users/<int:pk>', UsersView.as_view()),
    path('password/<int:pk>', UpdatePasswordView.as_view()),
]