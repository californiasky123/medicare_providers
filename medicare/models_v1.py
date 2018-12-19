# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.urls import reverse


class Address(models.Model):
    address_id = models.AutoField(primary_key=True)
    street = models.CharField(unique=True, max_length=100)
    zip_code = models.CharField(unique=True, max_length=5)
    city = models.ForeignKey('City', models.DO_NOTHING)
    state = models.ForeignKey('State', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'address'
        ordering = ['street']
        verbose_name = 'address'
        verbose_name_plural = 'addresses'

    def __str__ (self):
        return self.street

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


class Provider(models.Model):
    provider_id = models.AutoField(primary_key=True)
    old_provider_id = models.CharField(unique=True, max_length=100)
    provider_name = models.CharField(unique=True, max_length=100)
    referral_region = models.ForeignKey('ReferralRegion', models.DO_NOTHING)
    address = models.ForeignKey('Address', models.DO_NOTHING)

    drg = models.ManyToManyField(Drg, through='ProviderDrg')

    
 
    class Meta:
        managed = False
        db_table = 'provider'
        ordering = ['provider_name']
        verbose_name = 'Provider'
        verbose_name_plural = 'Providers'

    def __str__ (self):
        return self.provider_name

    def get_absolute_url(self):
        # return reverse('site_detail', args=[str(self.id)])
        return reverse('provider_detail', kwargs={'pk': self.pk})


class ProviderDrg(models.Model):
    provider_drg_id = models.AutoField(primary_key=True)
    provider = models.ForeignKey('Provider', models.DO_NOTHING)
    drg = models.ForeignKey('Drg', models.DO_NOTHING)
    avg_med_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_cov_charges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_total_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    total_discharges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'provider_drg'


class ReferralRegion(models.Model):
    referral_region_id = models.AutoField(primary_key=True)
    referral_region_desc = models.CharField(max_length=100)

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
