from django.urls import path
from .auth import AuthView, AuthRegisterView, UserModulesPermissionsView

urlpatterns = [
    path('permissions/<int:pk>', UserModulesPermissionsView.as_view()),
    path('register/', AuthRegisterView.as_view()),
]