from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from ..auth.models import Auth
from ..auth.serializers import AuthSerializer

class PersonView(APIView):
    permission_classes = []

    def get(self, request, *args, **kwargs):
        try:
            users = Auth.objects.all()
            serializer = AuthSerializer(users, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)