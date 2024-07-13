from django.urls import path, include

urlpatterns = [
    path('auth/', include('general.auth.urls')),
]