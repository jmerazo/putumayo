from django.urls import path, include

urlpatterns = [
    path('auth/', include('general.auth.urls')),
    path('users/', include('general.person.urls')),
]