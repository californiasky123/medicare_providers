from django.urls import include, path
from rest_framework.documentation import include_docs_urls
from rest_framework.routers import SimpleRouter
from rest_framework_swagger.views import get_swagger_view
from api.views import ProviderViewSet

API_TITLE = 'medicare API'
API_DESC = 'A web API for creating, modifying and deleting Medicare providers.'

docs_view = include_docs_urls(
	title=API_TITLE,
	description=API_DESC
)

# Swagger view
schema_view = get_swagger_view(title=API_TITLE)

# Default view
'''
schema_view = get_schema_view(
	title=API_TITLE,
	# renderer_classes=[OpenAPIRenderer]
)
'''

router = SimpleRouter()
router.register(r'providers', ProviderViewSet, base_name='providers')
# urlpatterns = router.urls

# The API URLs are now determined automatically by the router.
urlpatterns = [
	path('', include(router.urls)),
	path('docs/', docs_view),
	path('swagger-docs/', schema_view)
	# path('schema/', schema_view)
]

'''
urlpatterns = [
	path('schema/', schema_view),
	path('providers/', views.ProviderListAPIView.as_view(), name='provider_api'),
	path('providers/<int:pk>/', views.ProviderDetailAPIView.as_view(), name='provider_detail_api'),
]
'''