from django.urls import path
from .auth import AuthView, AuthRegisterView, UserModulesPermissionsView

urlpatterns = [
    path('', AuthView.as_view()),
    path('permissions/', UserModulesPermissionsView.as_view()),
    path('register/', AuthRegisterView.as_view()),
]