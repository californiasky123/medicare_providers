# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Address(models.Model):
    address_id = models.AutoField(primary_key=True)
    street = models.CharField(max_length=500)
    zip = models.CharField(max_length=5)
    city_state_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'address'


class AddressTemp(models.Model):
    address_id = models.AutoField(primary_key=True)
    street = models.CharField(max_length=500)
    zip = models.CharField(max_length=5)
    city_state_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'address_temp'


class CityState(models.Model):
    city_state_id = models.AutoField(primary_key=True)
    city_state_name = models.CharField(max_length=100)
    state_name = models.CharField(max_length=100)
    city_name = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'city_state'


class CityStateTemp(models.Model):
    city_state_id = models.AutoField(primary_key=True)
    city_state_name = models.CharField(max_length=100)
    state_name = models.CharField(max_length=100)
    city_name = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'city_state_temp'


class Drg(models.Model):
    drg_id = models.AutoField(primary_key=True)
    drg_desc = models.CharField(max_length=500)

    class Meta:
        managed = False
        db_table = 'drg'


class FMedicare(models.Model):
    drg_desc = models.CharField(max_length=500)
    old_provider_id = models.CharField(max_length=100)
    provider_name = models.CharField(max_length=100)
    street = models.CharField(max_length=500)
    city_name = models.CharField(max_length=100)
    state_name = models.CharField(max_length=100)
    zip = models.CharField(max_length=5)
    referral_region_desc = models.CharField(max_length=100)
    avg_med_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_cov_charges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_total_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    total_discharges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    city_state_name = models.CharField(max_length=100)
    city_state_id = models.IntegerField()
    referral_region_id = models.IntegerField()
    drg_id = models.IntegerField()
    address_id = models.IntegerField()
    provider_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'f_medicare'


class Provider(models.Model):
    provider_id = models.AutoField(primary_key=True)
    old_provider_id = models.CharField(max_length=100)
    provider_name = models.CharField(max_length=100)
    referral_region_id = models.IntegerField()
    address_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'provider'


class ProviderDrg(models.Model):
    provider_drg_id = models.AutoField(primary_key=True)
    provider = models.ForeignKey('ProviderTemp', models.DO_NOTHING)
    drg = models.ForeignKey(Drg, models.DO_NOTHING)
    avg_med_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_cov_charges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_total_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    total_discharges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'provider_drg'


class ProviderTemp(models.Model):
    provider_id = models.AutoField(primary_key=True)
    old_provider_id = models.CharField(max_length=100)
    provider_name = models.CharField(max_length=100)
    referral_region_id = models.IntegerField()
    address_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'provider_temp'


class ReferralRegion(models.Model):
    referral_region_id = models.AutoField(primary_key=True)
    referral_region_desc = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'referral_region'


class TMedicare1(models.Model):
    drg_desc = models.CharField(max_length=500)
    old_provider_id = models.CharField(max_length=100)
    provider_name = models.CharField(max_length=100)
    street = models.CharField(max_length=500)
    city_name = models.CharField(max_length=100)
    state_name = models.CharField(max_length=100)
    zip = models.CharField(max_length=5)
    referral_region_desc = models.CharField(max_length=100)
    avg_med_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_cov_charges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    avg_total_payment = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    total_discharges = models.DecimalField(max_digits=19, decimal_places=4, blank=True, null=True)
    city_state_name = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 't_medicare_1'
