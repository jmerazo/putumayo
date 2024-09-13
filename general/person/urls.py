from django.urls import path
from .person import PersonView

urlpatterns = [
    path('', PersonView.as_view(), name='users-list'),
    path('<int:pk>', PersonView.as_view(), name='users-list'),
]