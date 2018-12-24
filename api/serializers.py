from medicare.models import Provider, State, City, ReferralRegion
#from medicare.models import Provider, Drg, ProviderDrg, State, City, ReferralRegion
from rest_framework import response, serializers, status



# class DrgSerializer(serializers.ModelSerializer):
# 	class Meta:
# 		model = Drg
# 		fields = (
# 			'drg_id',
# 			'drg_desc')



# class AddressSerializer(serializers.ModelSerializer):
# 	class Meta:
# 		model = Address
# 		fields = (
# 			'address_id',
# 			'street')


# class ProviderDrgSerializer(serializers.ModelSerializer):
# 	provider_id = serializers.ReadOnlyField(source='provider.provider_id')
# 	drg_id = serializers.ReadOnlyField(source='drg.drg_id')

# 	class Meta:
# 		model = ProviderDrg
# 		fields = ('provider_id', 'provider_drg')


class ReferralRegionSerializer(serializers.ModelSerializer):
	class Meta:
		model = ReferralRegion
		fields = ('referral_region_id', 'referral_region_desc')

class StateSerializer(serializers.ModelSerializer):
	class Meta:
		model = State
		fields = ('state_id', 'state_name')

class CitySerializer(serializers.ModelSerializer):
	class Meta:
		model = City
		fields = ('city_id', 'city_name')


class ProviderSerializer(serializers.ModelSerializer):
	provider_name = serializers.CharField(
		allow_blank=False,
		max_length=255
	)

	old_provider_id = serializers.CharField(
		allow_blank=False,
		max_length=10
	)

	street = serializers.CharField(
		allow_blank=False,
		max_length=255
	)

	zip_code = serializers.CharField(
		allow_blank=False,
		max_length=10
	)

	referral_region = ReferralRegionSerializer(
		many=False,
		read_only=True
	)

	referral_region_id = serializers.PrimaryKeyRelatedField(
		allow_null=False,
		many=False,
		write_only=True,
		queryset=ReferralRegion.objects.all(),
		source='referral_region'
	)

	city = CitySerializer(
		many=False,
		read_only=True
	)

	city_id = serializers.PrimaryKeyRelatedField(
		allow_null=False,
		many=False,
		write_only=True,
		queryset=City.objects.all(),
		source='city'
	)

	state = StateSerializer(
		many=False,
		read_only=True
	)

	state_id = serializers.PrimaryKeyRelatedField(
		allow_null=False,
		many=False,
		write_only=True,
		queryset=State.objects.all(),
		source='state'
	)


	# address = AddressSerializer(
	# 	many=False,
	# 	read_only=True
	# )

	# address_id = serializers.PrimaryKeyRelatedField(
	# 	allow_null=False,
	# 	many=False,
	# 	write_only=True,
	# 	queryset=Address.objects.all(),
	# 	source='address'
	# )

	# provider_drg = ProviderDrgSerializer(
	# 	source='provider_drg_set', # Note use of _set
	# 	many=True,
	# 	read_only=True
	# )
	# diagnosis_ids = serializers.PrimaryKeyRelatedField(
	# 	many=True,
	# 	write_only=True,
	# 	queryset=Drg.objects.all(),
	# 	source='provider_drg'
	# )


	class Meta:
		model = Provider
		fields = (
			'provider_id',
			'provider_name',
			#'referral_region_desc',
			'referral_region',
			'referral_region_id',
			'old_provider_id',
			'street',
			'zip_code',
			'city_id',
			'city',
			'state_id',
			'state',
			#'provider_drg',
			#'diagnosis_ids', 
			#'street',
		)

	def create(self, validated_data):
		"""
		This method persists a new HeritageSite instance as well as adds all related
		countries/areas to the heritage_site_jurisdiction table.  It does so by first
		removing (validated_data.pop('heritage_site_jurisdiction')) from the validated
		data before the new HeritageSite instance is saved to the database. It then loops
		over the heritage_site_jurisdiction array in order to extract each country_area_id
		element and add entries to junction/associative heritage_site_jurisdiction table.
		:param validated_data:
		:return: site
		"""

		# print(validated_data)

		#diagnoses = validated_data.pop('provider_drg')
		provider = Provider.objects.create(**validated_data)

		# if diagnoses is not None:
		# 	for diagnosis in diagnoses:
		# 		ProviderDrg.objects.create(
		# 			provider_id=provider.provider_id,
		# 			#diagnosis_id=drg.drg_id #chnote deleted this and include below instead. 
		# 			diagnosis_id=diagnosis.drg_id #chnote deleted this and include below instead. 
		# 			#drg_id=drg.drg_id
		# 		)
		return provider

	def update(self, instance, validated_data):
		# site_id = validated_data.pop('heritage_site_id')
		provider_id = instance.provider_id
		#new_diagnoses = validated_data.pop('provider_drg')

		instance.provider_name = validated_data.get(
			'provider_name',
			instance.provider_name
		)

		instance.old_provider_id = validated_data.get(
			'old_provider_id',
			instance.old_provider_id
		)

		instance.referral_region_id = validated_data.get(
			'referral_region_id',
			instance.referral_region_id
		)

		instance.street = validated_data.get(
			'street',
			instance.street
		)

		instance.city_id = validated_data.get(
			'city_id',
			instance.city_id
		)

		instance.state_id = validated_data.get(
			'state_id',
			instance.state_id
		)

		instance.zip_code = validated_data.get(
			'zip_ccode',
			instance.zip_code
		)

		instance.save()

		return instance

		# # If any existing country/areas are not in updated list, delete them
		# new_ids = []
		# old_ids = ProviderDrg.objects \
		# 	.values_list('drg_id', flat=True) \
		# 	.filter(provider_id__exact=provider_id)
		# 	#.values_list('diagnosis_id', flat=True) \

		# # TODO Insert may not be required (Just return instance)

		# # Insert new unmatched diagnosis entries
		# for diagnosis in new_diagnoses:
		# 	new_id = drg.drg_id
		# 	new_ids.append(new_id)
		# 	if new_id in old_ids:
		# 		continue
		# 	else:
		# 		ProviderDrg.objects \
		# 			.create(provider_id=provider_id, drg_id=new_id)

		# # Delete old unmatched diagnosis entries
		# for old_id in old_ids:
		# 	if old_id in new_ids:
		# 		continue
		# 	else:
		# 		ProviderDrg.objects \
		# 			.filter(provider_id=provider_id, drg_id=old_id) \
		# 			.delete()
