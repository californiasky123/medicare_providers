# Generated by Django 2.1.4 on 2018-12-18 20:44

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Address',
            fields=[
                ('address_id', models.AutoField(primary_key=True, serialize=False)),
                ('street', models.CharField(max_length=100, unique=True)),
                ('zip_code', models.CharField(max_length=5, unique=True)),
            ],
            options={
                'verbose_name': 'address',
                'verbose_name_plural': 'addresses',
                'db_table': 'address',
                'ordering': ['street'],
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='City',
            fields=[
                ('city_id', models.AutoField(primary_key=True, serialize=False)),
                ('city_name', models.CharField(max_length=100)),
            ],
            options={
                'verbose_name': 'City',
                'verbose_name_plural': 'Cities',
                'db_table': 'city',
                'ordering': ['city_name'],
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Drg',
            fields=[
                ('drg_id', models.AutoField(primary_key=True, serialize=False)),
                ('drg_desc', models.CharField(max_length=500)),
            ],
            options={
                'verbose_name': 'Diagnosis',
                'verbose_name_plural': 'Diagnoses',
                'db_table': 'drg',
                'ordering': ['drg_desc'],
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Provider',
            fields=[
                ('provider_id', models.AutoField(primary_key=True, serialize=False)),
                ('old_provider_id', models.CharField(max_length=100, unique=True)),
                ('provider_name', models.CharField(max_length=100, unique=True)),
            ],
            options={
                'verbose_name': 'Provider',
                'verbose_name_plural': 'Providers',
                'db_table': 'provider',
                'ordering': ['provider_name'],
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='ProviderDrg',
            fields=[
                ('provider_drg_id', models.AutoField(primary_key=True, serialize=False)),
                ('avg_med_payment', models.DecimalField(blank=True, decimal_places=4, max_digits=19, null=True)),
                ('avg_cov_charges', models.DecimalField(blank=True, decimal_places=4, max_digits=19, null=True)),
                ('avg_total_payment', models.DecimalField(blank=True, decimal_places=4, max_digits=19, null=True)),
                ('total_discharges', models.DecimalField(blank=True, decimal_places=4, max_digits=19, null=True)),
            ],
            options={
                'db_table': 'provider_drg',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='ReferralRegion',
            fields=[
                ('referral_region_id', models.AutoField(primary_key=True, serialize=False)),
                ('referral_region_desc', models.CharField(max_length=100, unique=True)),
            ],
            options={
                'verbose_name': 'Referral Region Description',
                'verbose_name_plural': 'Referral Region Descriptions',
                'db_table': 'referral_region',
                'ordering': ['referral_region_desc'],
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='State',
            fields=[
                ('state_id', models.AutoField(primary_key=True, serialize=False)),
                ('state_name', models.CharField(max_length=100)),
            ],
            options={
                'verbose_name': 'State',
                'verbose_name_plural': 'States',
                'db_table': 'state',
                'ordering': ['state_name'],
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='TempMedicare',
            fields=[
                ('temp_medicare_id', models.AutoField(primary_key=True, serialize=False)),
                ('drg_desc', models.CharField(max_length=500)),
                ('old_provider_id', models.CharField(max_length=100)),
                ('provider_name', models.CharField(max_length=100)),
                ('street', models.CharField(max_length=500)),
                ('city_name', models.CharField(max_length=100)),
                ('state_name', models.CharField(max_length=100)),
                ('zip_code', models.CharField(max_length=5)),
                ('referral_region_desc', models.CharField(max_length=100)),
                ('avg_med_payment', models.DecimalField(blank=True, decimal_places=4, max_digits=19, null=True)),
                ('avg_cov_charges', models.DecimalField(blank=True, decimal_places=4, max_digits=19, null=True)),
                ('avg_total_payment', models.DecimalField(blank=True, decimal_places=4, max_digits=19, null=True)),
                ('total_discharges', models.DecimalField(blank=True, decimal_places=4, max_digits=19, null=True)),
                ('city_state_name', models.CharField(max_length=100)),
            ],
            options={
                'db_table': 'temp_medicare',
                'managed': False,
            },
        ),
    ]