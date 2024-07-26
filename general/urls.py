from django.urls import path, include

urlpatterns = [
    path('auth/', include('general.auth.urls')),
    path('person/', include('general.person.urls')),
    path('utils/', include('general.utils.urls')),
]