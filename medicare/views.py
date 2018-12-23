from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.core.paginator import EmptyPage, PageNotAnInteger, Paginator
from django.http import HttpResponse, HttpResponseRedirect
from django.db.models import F, Q
from django.shortcuts import redirect, render
from django.views import generic
from django.urls import reverse_lazy
from django.urls import reverse
from django.utils.decorators import method_decorator
from medicare.filters import ProviderFilter
from medicare.forms import ProviderForm
#from medicare.forms import SearchForm
from medicare.models import Provider, Drg, ProviderDrg, City, State, ReferralRegion

from django_filters.views import FilterView
from .models import Provider



def index(request):
	return HttpResponse("Hello, world. You're at the Medicare index page.")


class AboutPageView(generic.TemplateView):
	template_name = 'medicare/about.html'


class HomePageView(generic.TemplateView):
	template_name = 'medicare/home.html'



# 	@method_decorator(login_required, name='dispatch')
class ProviderListView(generic.ListView):
	model = Provider
	context_object_name = 'providers'
	template_name = 'medicare/providers.html'
	paginate_by = 50

	def get_queryset(self):
		return Provider.objects.all()\
			.select_related('referral_region')\
			.order_by('provider_name')
			#.select_related('address')\

class ProviderDetailView(generic.DetailView): ##chnote2 check whether these should be provider or providers (see above also)
	model = Provider
	context_object_name = 'provider'  # chnote2 might want to change this back to providers - providers on nboth worked before. 
	template_name = 'medicare/provider_detail.html'


@method_decorator(login_required, name='dispatch')
class ProviderDeleteView(generic.DeleteView):
	model = Provider
	success_message = "Provider deleted successfully"
	success_url = reverse_lazy('provider')
	context_object_name = 'provider'
	template_name = 'medicare/provider_delete.html'

	def dispatch(self, *args, **kwargs):
		return super().dispatch(*args, **kwargs)

	def delete(self, request, *args, **kwargs):
		self.object = self.get_object()

		# Delete HeritageSiteJurisdiction entries
		ProviderDrg.objects \
			.filter(provider_id=self.object.provider_id) \
			.delete()

		self.object.delete()

		return HttpResponseRedirect(self.get_success_url())


@method_decorator(login_required, name='dispatch')
class ProviderUpdateView(generic.UpdateView):
	model = Provider
	form_class = ProviderForm
	# fields = '__all__' <-- superseded by form_class
	context_object_name = 'provider'
	# pk_url_kwarg = 'site_pk'
	success_message = "Provider updated successfully"
	template_name = 'medicare/provider_update.html'

	def dispatch(self, *args, **kwargs):
		return super().dispatch(*args, **kwargs)

	def form_valid(self, form):
		provider = form.save(commit=False)
		# site.updated_by = self.request.user
		# site.date_updated = timezone.now()
		provider.save()

		# If any existing country/areas are not in updated list, delete them
		new_ids = []
		old_ids = ProviderDrg.objects\
			.values_list('drg_id', flat=True)\
			.filter(provider_id=provider.provider_id)

		# New countries list
		new_diagnoses = form.cleaned_data['diagnoses']

		# Insert new unmatched country entries
		for diagnosis in new_diagnoses:
			new_id = diagnosis.drg_id
			new_ids.append(new_id)
			if new_id in old_ids:
				continue
			else:
				ProviderDrg.objects \
					.create(provider=provider, drg=diagnosis)

		# Delete old unmatched country entries
		for old_id in old_ids:
			if old_id in new_ids:
				continue
			else:
				ProviderDrg.objects \
					.filter(provider_id=provider.provider_id, drg_id= old_id) \
					.delete()

		return HttpResponseRedirect(provider.get_absolute_url())
		# return redirect('heritagesites/site_detail', pk=site.pk)


@method_decorator(login_required, name='dispatch')
class ProviderCreateView(generic.View):
	model = Provider
	form_class = ProviderForm
	success_message = "Provider created successfully"
	template_name = 'medicare/provider_new.html'
	# fields = '__all__' <-- superseded by form_class
	# success_url = reverse_lazy('heritagesites/site_list')

	def dispatch(self, *args, **kwargs):
		return super().dispatch(*args, **kwargs)

	def post(self, request):
		form = ProviderForm(request.POST)
		if form.is_valid():
			provider = form.save(commit=False)
			print(provider.provider_name)
			provider.save() # should be saving data to provider table
			for diagnosis in form.cleaned_data['diagnoses']:
				print(diagnosis.drg_id)
				ProviderDrg.objects.create(provider=provider, drg=diagnosis)
				# ProviderDrg.objects.create(provider=provider, drg=diagnoses)
			return redirect(provider) # shortcut to object's get_absolute_url()

			# return HttpResponseRedirect(site.get_absolute_url())
		return render(request, 'medicare/provider_new.html', {'form': form})

	def get(self, request):
		form = ProviderForm()
		return render(request, 'medicare/provider_new.html', {'form': form})


	# def post(self, request):
	# 	form = HeritageSiteForm(request.POST)
	# 	if form.is_valid():
	# 		site = form.save(commit=False)
	# 		site.save()
	# 		for country in form.cleaned_data['country_area']:
	# 			HeritageSiteJurisdiction.objects.create(heritage_site=site, country_area=country)
	# 		# return redirect(site) # shortcut to object's get_absolute_url() # tried commenting this out and commenting in line below during debugging 11/12/2018 hw8
	# 		return HttpResponseRedirect(site.get_absolute_url())
	# 	return render(request, 'heritagesites/site_new.html', {'form': form})

	# def get(self, request):
	# 	form = HeritageSiteForm()
	# 	return render(request, 'heritagesites/site_new.html', {'form': form})

class ProviderFilterView(FilterView):
	filterset_class = ProviderFilter
	template_name = 'medicare/provider_filter.html'


@method_decorator(login_required, name='dispatch')
class DrgListView(generic.ListView):
	model = Drg
	context_object_name = 'diagnoses' #chnote tried changing context_object_name to country_areas 11/9/18 during debugging hw8. 
	# original (from midterm) is countries
	template_name = 'medicare/diagnosis.html'
	paginate_by = 20

	def dispatch(self, *args, **kwargs):
		return super().dispatch(*args, **kwargs)

	def get_queryset(self):
		return Drg.objects\
			.order_by('drg_desc')

@method_decorator(login_required, name='dispatch') #chnote added 11/2/18 hw7
class DrgDetailView(generic.DetailView):
	model = Drg
	context_object_name = 'diagnoses'
	template_name = 'medicare/diagnosis_detail.html'

	def dispatch(self, *args, **kwargs):
		return super().dispatch(*args, **kwargs)