from django.http import HttpResponse

def index(request):
    message = 'Conectado a la API Gobernación del Putumayo'
    return HttpResponse(message)