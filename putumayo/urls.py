from rest_framework_simplejwt.views import TokenRefreshView
from general.auth.auth import AuthView
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from . import views
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

schema_view = get_schema_view(
   openapi.Info(
        title="GOBERNACIÓN API",
        default_version='v1',
        description="Descripción de las rutas y modelos de la api",
        terms_of_service="https://www.putumayo.gov.com",
        contact=openapi.Contact(email="sistemas@putumayo.gov.co"),
        license=openapi.License(name="BSD License"),
   ),
   public=True,
   
)

urlpatterns = [
    path('', views.index, name='index'),
    path('admin/', admin.site.urls),
    path('api/auth/token/access/', AuthView.as_view()),
    path('api/auth/token/refresh/', TokenRefreshView.as_view()),
    path('api/', include('general.urls')),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
