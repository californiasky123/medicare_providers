from medicare.models import Provider, ProviderDrg
from api.serializers import ProviderSerializer
from rest_framework import generics, permissions, status, viewsets
from rest_framework.response import Response


class ProviderViewSet(viewsets.ModelViewSet):
	"""
	This ViewSet provides both 'list' and 'detail' views.
	"""
	queryset = Provider.objects.select_related('referral_region').order_by('provider_name')
	serializer_class = ProviderSerializer
	permission_classes = (permissions.IsAuthenticatedOrReadOnly,)

	def delete(self, request, pk, format=None):
		provider = self.get_object(pk)
		self.perform_destroy(self, provider)

		return Response(status=status.HTTP_204_NO_CONTENT)

	def perform_destroy(self, instance):
		instance.delete()


'''
class SiteListAPIView(generics.ListCreateAPIView):
	queryset = HeritageSite.objects.select_related('heritage_site_category').order_by('site_name')
	serializer_class = HeritageSiteSerializer
	permission_classes = (permissions.DjangoModelPermissionsOrAnonReadOnly,)
'''

'''
class SiteDetailAPIView(generics.RetrieveUpdateDestroyAPIView):
	queryset = HeritageSite.objects.select_related('heritage_site_category').order_by('site_name')
	serializer_class = HeritageSiteSerializer
	permission_classes = (permissions.DjangoModelPermissionsOrAnonReadOnly,)
'''