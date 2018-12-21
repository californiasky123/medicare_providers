import django_filters
#from medicare.forms import SearchForm
from medicare.models import Provider, Drg, ProviderDrg, City, State, ReferralRegion


class ProviderFilter(django_filters.FilterSet):
	provider_name = django_filters.CharFilter(
		field_name='provider_name',
		label='Provider Name',
		lookup_expr='icontains'
	)

	referral_region = django_filters.ModelChoiceFilter(
		field_name='referral_region',
		label='Referral Region',
		queryset=ReferralRegion.objects.all().order_by('referral_region_desc'),
		lookup_expr='exact'
	)

	diagnoses = django_filters.ModelChoiceFilter(
		field_name='diagnoses',
		label='Diagnoses covered',
		queryset=Drg.objects.all().order_by('drg_desc'),
		lookup_expr='exact'
	)

	class Meta:
		model = Provider
		# form = SearchForm
		# fields [] is required, even if empty. Comment out names to prevent overriding names
		# listed above.
		fields = [
			# 'site_name',
			# 'description',
			# 'heritage_site_category',
			# 'countries__location__region__region_name',
			# 'countries__location__sub_region__sub_region_name',
			# 'countries__location__intermediate_region__intermediate_region_name',
			# 'countries',
			# 'date_inscribed'
		]