from django.urls import path

from . import views

from django.urls import path, re_path
from . import views

urlpatterns = [
    path('', views.HomePageView.as_view(), name='home'),
    path('about/', views.AboutPageView.as_view(), name='about'),
   # path('providers/', views.ProviderListView.as_view(), name='providers'),
    path('providers/', views.ProviderFilterView.as_view(), name='providers'),
    path('provider/<int:pk>/', views.ProviderDetailView.as_view(), name='provider_detail'),
    path('provider/new/', views.ProviderCreateView.as_view(), name='provider_new'),
	path('provider/<int:pk>/delete/', views.ProviderDeleteView.as_view(), name='provider_delete'),
	path('provider/<int:pk>/update/', views.ProviderUpdateView.as_view(), name='provider_update'),
	path('diagnoses/', views.DrgListView.as_view(), name='diagnosis'), # added during midterm 10/23  #debugging #tried changing this to country_areas during debugging 11/8/18 hw8
    path('diagnosis/<int:pk>/', views.DrgDetailView.as_view(), name='diagnosis_detail'), #added during midterm 10/23
]