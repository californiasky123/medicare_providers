# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.urls import reverse
from django.urls import reverse_lazy


# class Address(models.Model):
#     address_id = models.AutoField(primary_key=True)
#     street = models.CharField(unique=True, max_length=100)
#     zip_code = models.CharField(unique=True, max_length=5)
#     city = models.ForeignKey('City', models.PROTECT)
#     state = models.ForeignKey('State', models.PROTECT)
#     #provider = models.ForeignKey('Provider', models.PROTECT) #chnote2 this is new --> may want to comment out later 

#     class Meta:
#         managed = False
#         db_table = 'address'
#         ordering = ['street']
#         verbose_name = 'address'
#         verbose_name_plural = 'addresses'

#     def __str__ (self):
#         return self.street

class City(models.Model):
    city_id = models.AutoField(primary_key=True)
    city_name = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'city'
        ordering = ['city_name']
        verbose_name = 'City'
        verbose_name_plural = 'Cities'

    def __str__ (self):
        return self.city_name

class Drg(models.Model):
    drg_id = models.AutoField(primary_key=True)
    drg_desc = models.CharField(max_length=500)

    class Meta:
        managed = False
        db_table = 'drg'
        ordering = ['drg_desc']
        verbose_name = 'Diagnosis'
        verbose_name_plural = 'Diagnoses'

    def __str__ (self):
        return self.drg_desc

    def get_absolute_url(self):
        # return reverse('site_detail', args=[str(self.id)])
        return reverse('diagnosis_detail', kwargs={'pk': self.pk})



class Provider(models.Model):
    provider_id = models.AutoField(primary_key=True)
    old_provider_id = models.CharField(unique=True, max_length=100)
    provider_name = models.CharField(unique=True, max_length=100)
    street = models.CharField(unique=True, max_length=100) 
    zip_code = models.CharField(unique=True, max_length=10)
    referral_region = models.ForeignKey('ReferralRegion', models.PROTECT)
    state = models.ForeignKey('State', models.PROTECT)
    city = models.ForeignKey('City', models.PROTECT)

    diagnoses = models.ManyToManyField(Drg, through='ProviderDrg', blank=True, related_name='providers') #fixed per Anthony's suggestion 12/19/18

    class Meta:
        managed = False
        db_table = 'provider'
        ordering = ['provider_name']
        verbose_name = 'Provider'
        verbose_name_plural = 'Providers'

    def get_absolute_url(self):
        # return reverse('site_detail', args=[str(self.id)])
        return reverse('provider_detail', kwargs={'pk': self.pk})

    def __str__ (self):
        return self.provider_name


        # Intermediate model (country_area -> heritage_site_jurisdiction <- heritage_site)

    @property
    def diagnosis_names(self, sort_order='drg_desc'):
        """
        Returns a list of UNSD countries/areas (names only) associated with a Heritage Site.
        Note that not all Heritage Sites are associated with a country/area (e.g., Old City
        Walls of Jerusalem). In such cases the Queryset will return as <QuerySet [None]> and the
        list will need to be checked for None or a TypeError (sequence item 0: expected str
        instance, NoneType found) runtime error will be thrown.
        :return: string
        """
        sort_order = ['drg_desc']

        diagnoses = self.diagnoses.all()

        names = []
        for diagnosis in diagnoses:
            name = diagnosis.drg_desc
            if name is None:
                continue

            names.append(name)

        return ', '.join(names)

    def diagnosis_display(self):
        """Create a string for country_area. This is required to display in the Admin view."""
        return ', '.join(
            diagnosis.drg_desc for diagnosis in self.diagnosis.all()[:25])
    diagnosis_display.short_description = 'Diagnosis'
 

    #cities = models.ManyToManyField(City, through='Address', related_name = 'providers')

    @property
    def city_names(self):

        cities = self.country_area.select_related('city').order_by('city__city_name')

        names = []

        for city in cities:
            # try: 
            name = city.city_name # relationship between tables is dots, relationship between variable and a table is also dots
            #name = region.region_name
            if name is None:
                continue
            if name not in names:
                names.append(name)
            # except: 
            #     continue 
        return ', '.join(names)

class ProviderDrg(models.Model):
    provider_drg_id = models.AutoField(primary_key=True)
    provider = models.ForeignKey('Provider', on_delete=models.CASCADE)
    drg = models.ForeignKey('Drg', on_delete=models.CASCADE)
    avg_med_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_cov_charges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_total_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    total_discharges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'provider_drg'


class ReferralRegion(models.Model):
    referral_region_id = models.AutoField(primary_key=True)
    referral_region_desc = models.CharField(max_length=100, unique=True)

    class Meta:
        managed = False
        db_table = 'referral_region'
        ordering = ['referral_region_desc']
        verbose_name = 'Referral Region Description'
        verbose_name_plural = 'Referral Region Descriptions'

    def __str__ (self):
        return self.referral_region_desc


class State(models.Model):
    state_id = models.AutoField(primary_key=True)
    state_name = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'state'
        ordering = ['state_name']
        verbose_name = 'State'
        verbose_name_plural = 'States'

    def __str__ (self):
        return self.state_name


class TempMedicare(models.Model):
    temp_medicare_id = models.AutoField(primary_key=True)
    drg_desc = models.CharField(max_length=500)
    old_provider_id = models.CharField(max_length=100)
    provider_name = models.CharField(max_length=100)
    street = models.CharField(max_length=500)
    city_name = models.CharField(max_length=100)
    state_name = models.CharField(max_length=100)
    zip_code = models.CharField(max_length=5)
    referral_region_desc = models.CharField(max_length=100)
    avg_med_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_cov_charges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_total_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    total_discharges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    city_state_name = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'temp_medicare'
