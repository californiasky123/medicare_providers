#!/usr/bin/env python
# coding: utf-8

# In[16]:


import pandas as pd
fname = "Inpatient_Prospective_Payment_System__IPPS__Provider_Summary_for_the_Top_100_Diagnosis-Related_Groups__DRG__-_FY2011.csv"

df = pd.read_csv(fname)


# In[17]:


df.head()


# In[18]:


print(df.columns)


# In[19]:


new_cols = ['drg_desc', 'old_provider_id', 'provider_name', 'street', 'city_name', 'state_name', 'zip', 'referral_region_desc', 'total_discharges', 'avg_cov_charges', 'avg_total_payment', 'avg_med_payment']


# In[24]:


df.columns = new_cols



df['city_state_name'] = df.city_name.astype(str).str.cat(df.state_name.astype(str), sep='-')


# In[25]:


print(df.head())


# In[26]:


df.to_csv('medicare_data_1212.csv', index=False)


# In[27]:


df2 = pd.read_csv('medicare_data_1212.csv')


# In[28]:

print("Below should have the new column added")
print(df2.head())

