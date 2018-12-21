from django.contrib import admin

# Register your models here.


from django.contrib import admin

import medicare.models as models


# @admin.register(models.Address)
# class AddressAdmin(admin.ModelAdmin):
# 	fields = [
# 		'address_id',
# 		'street',
# 		'zip_code',
# 		'city',
# 		'state'
# 	]

# 	list_display = [
# 		'address_id',
# 		'street',
# 		'zip_code',
# 		'city',
# 		'state'
# 	]

# 	list_filter = ['street'] #

# admin.site.register(models.CountryArea)


@admin.register(models.City)
class CityAdmin(admin.ModelAdmin):
	fields = ['city_id', 'city_name']
	list_display = ['city_id', 'city_name']
	ordering = ['city_name']

# admin.site.register(models.DevStatus)


@admin.register(models.Drg)
class DrgAdmin(admin.ModelAdmin):
	fields = ['drg_id', 'drg_desc']
	list_display = ['drg_id', 'drg_desc']
	ordering = ['drg_desc']


@admin.register(models.Provider)
class ProviderAdmin(admin.ModelAdmin):
	fields = ['provider_id', 'old_provider_id', 'provider_name', 'referral_region', 'city']
	list_display = ['provider_id', 'old_provider_id', 'provider_name', 'referral_region', 'city']
	ordering = ['provider_name']


@admin.register(models.ReferralRegion)
class ReferralRegionAdmin(admin.ModelAdmin):
	fields = ['referral_region_id', 'referral_region_desc']
	list_display = ['referral_region_id', 'referral_region_desc']
	ordering = ['referral_region_desc']


@admin.register(models.State)
class StateAdmin(admin.ModelAdmin):
	fields = ['state_id', 'state_name']
	list_display = ['state_id', 'state_name']
	ordering = ['state_name']
