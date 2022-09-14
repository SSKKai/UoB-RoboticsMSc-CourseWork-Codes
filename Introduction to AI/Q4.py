# -*- coding: utf-8 -*-
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

data = pd.read_csv("coursework1.csv")

cw = data[['sourceIP','destIP']]
cw.insert(1,'source_cluster','')
cw.insert(3,'dest_cluster','')
cw = cw.copy()


allsourceip = cw['sourceIP'].tolist()
alldestip=cw['destIP'].tolist()

#%% creat sourceIP cluster and mark in the cw dataframe
count_sourceIP = pd.value_counts(allsourceip)
num_sourceIP = np.array(count_sourceIP.values.tolist())
label_sourceIP = np.array(count_sourceIP.index.tolist())

source_cluster1 = label_sourceIP[np.where(num_sourceIP <= 20)]
source_cluster2 = label_sourceIP[np.where((num_sourceIP >20)&(num_sourceIP <= 200))]
source_cluster3 = label_sourceIP[np.where((num_sourceIP >200)&(num_sourceIP <= 400))]
source_cluster4 = label_sourceIP[np.where(num_sourceIP > 400)]

for x in range(len(source_cluster1)):
    cw.loc[cw['sourceIP']==source_cluster1[x],'source_cluster']=1
for x in range(len(source_cluster2)):
    cw.loc[cw['sourceIP']==source_cluster2[x],'source_cluster']=2
for x in range(len(source_cluster3)):
    cw.loc[cw['sourceIP']==source_cluster3[x],'source_cluster']=3
for x in range(len(source_cluster4)):
    cw.loc[cw['sourceIP']==source_cluster4[x],'source_cluster']=4
    

#%% creat destIP cluster and mark in the cw dataframe
count_destIP = pd.value_counts(alldestip)
num_destIP = np.array(count_destIP.values.tolist())
label_destIP = np.array(count_destIP.index.tolist())

dest_cluster1 = label_destIP[np.where(num_destIP <= 40)]
dest_cluster2 = label_destIP[np.where((num_destIP >40)&(num_destIP <= 100))]
dest_cluster3 = label_destIP[np.where((num_destIP >100)&(num_destIP <= 400))]
dest_cluster4 = label_destIP[np.where(num_destIP > 400)]

for x in range(len(dest_cluster1)):
    cw.loc[cw['destIP']==dest_cluster1[x],'dest_cluster']=1
for x in range(len(dest_cluster2)):
    cw.loc[cw['destIP']==dest_cluster2[x],'dest_cluster']=2
for x in range(len(dest_cluster3)):
    cw.loc[cw['destIP']==dest_cluster3[x],'dest_cluster']=3
for x in range(len(dest_cluster4)):
    cw.loc[cw['destIP']==dest_cluster4[x],'dest_cluster']=4
    

#%% Count the number of each cluster
Q3_num = pd.DataFrame(columns=['d1','d2','d3','d4'],index=['s1','s2','s3','s4'])

for i in range(4):
    for j in range(4):
        Q3_num.iloc[i,j] = len(np.where((cw['dest_cluster']==(j+1))&(cw['source_cluster']==(i+1)))[0])

Q3_num['source_sum'] = Q3_num.apply(lambda x: x.sum(), axis=1)
Q3_num.loc['dest_sum'] = Q3_num.apply(lambda x: x.sum())

#%% caculate the proportional probabilities
prop_DinS = pd.DataFrame(index=['s1','s2','s3','s4'],columns=['d1','d2','d3','d4'])
prop_SinD = pd.DataFrame(index=['d1','d2','d3','d4'],columns=['s1','s2','s3','s4'])

for i in range(4):
    for j in range(4):
        prop_DinS.iloc[i,j] = Q3_num.iloc[i,j]/Q3_num.iloc[i,4]
        prop_SinD.iloc[j,i] = Q3_num.iloc[i,j]/Q3_num.iloc[4,j]
        
#%% plot Probability of destIP in sourceIP
x = [1, 2, 3, 4]
y1 = np.array(prop_DinS['d1'].tolist())
y2 = np.array(prop_DinS['d2'].tolist())
y3 = np.array(prop_DinS['d3'].tolist())
y4 = np.array(prop_DinS['d4'].tolist())
name = ['Cluster 1','Cluster 2','Cluster 3','Cluster 4']

plt.figure(figsize=(18,10))
plt.bar(x, y1, color='green', label='destIP cluster1')
plt.bar(x, y2, bottom=y1, color='red', label='destIP cluster2')
plt.bar(x, y3, bottom=y1+y2, color='blue', label='destIP cluster3')
plt.bar(x, y4, bottom=y1+y2+y3, color='yellow', label='destIP cluster4')
plt.legend(loc=[1, 0],fontsize=10)
plt.title("P(dest cluster|source cluster)",fontsize=20)
plt.xticks(x,name,fontsize=15)
plt.yticks(fontsize=15)
plt.xlabel("The cluster of source IP address",fontsize=20)
plt.ylabel("Proportion",fontsize=20)
plt.show()

#%% plot Probability of destIP in sourceIP
x = [1, 2, 3, 4]
y1 = np.array(prop_SinD['s1'].tolist())
y2 = np.array(prop_SinD['s2'].tolist())
y3 = np.array(prop_SinD['s3'].tolist())
y4 = np.array(prop_SinD['s4'].tolist())
name = ['Cluster 1','Cluster 2','Cluster 3','Cluster 4']

plt.figure(figsize=(18,10))
plt.bar(x, y1, color='green', label='sourceIP cluster1')
plt.bar(x, y2, bottom=y1, color='red', label='sourceIP cluster2')
plt.bar(x, y3, bottom=y1+y2, color='blue', label='sourceIP cluster3')
plt.bar(x, y4, bottom=y1+y2+y3, color='yellow', label='sourceIP cluster4')
plt.legend(loc=[1, 0],fontsize=10)
plt.title("P(source cluster|dest cluster)",fontsize=20)
plt.xticks(x,name,fontsize=15)
plt.yticks(fontsize=15)
plt.xlabel("The cluster of destination IP address",fontsize=20)
plt.ylabel("Proportion",fontsize=20)
plt.show()
#%%
























