# -*- coding: utf-8 -*-
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

data = pd.read_csv("coursework1.csv")

allsourceip = data['sourceIP'].tolist()
alldestip=data['destIP'].tolist()
allclass=data['classification'].tolist()

#%% Q1
dist_sourceip = set(allsourceip)
dist_destip = set(alldestip)
print("The number of distinct source IP =",len(dist_sourceip))
print("The number of distinct destination IP =",len(dist_destip))
print("The number of distinct classigications =",len(set(allclass)))
#%%

#%% Q2
from collections import Counter
count_sourceip = Counter(allsourceip).most_common()
label_sourceip = []
num_sourceip = []
for i_sourceip in range(len(count_sourceip)):
    label_sourceip.append(count_sourceip[i_sourceip][0])
    num_sourceip.append(count_sourceip[i_sourceip][1]) 

count_destip = Counter(alldestip).most_common()
label_destip = []
num_destip = []
for i_destip in range(len(count_destip)):
    label_destip.append(count_destip[i_destip][0])
    num_destip.append(count_destip[i_destip][1]) 



plt.figure(figsize=(20,8))
plt.bar(range(len(num_sourceip)), num_sourceip,tick_label=label_sourceip)  
plt.xticks(rotation=90)
plt.yticks(fontsize=18)
plt.show() 

plt.figure(figsize=(20,8))
plt.bar(range(len(num_destip)), num_destip,tick_label=label_destip)  
plt.xticks(rotation=90,fontsize=5)
plt.yticks(fontsize=18)
plt.show() 
#%%

#%% Q3
X_source = np.array(num_sourceip,dtype = int).reshape(-1,1) #transfer list to array
X_dest = np.array(num_destip,dtype = int).reshape(-1,1)
#plt.figure()
#plt.scatter(range(len(X_source)),X_source)

#%% kmeans
from sklearn.cluster import KMeans
from scipy.spatial.distance import cdist
#sourceIP
# elbow plot determine k value
distortions = []
K = range(1,10)
for k in K:
  kmeanModel = KMeans(n_clusters=k)
  kmeanModel.fit(X_source)
  distortions.append(sum(np.min(cdist(X_source,kmeanModel.cluster_centers_,"euclidean")**2, axis=1)) / X_source.shape[0])

plt.figure(figsize=(10,8))
plt.plot(K, distortions, "bx-")
plt.xlabel("k",fontsize=15)
plt.ylabel("Distortion",fontsize=15)

#apply kmeans with k = 2
kmeans = KMeans(n_clusters=3)
kmeans.fit(X_source)

plt.figure(figsize=(20,8))
plt.scatter(range(len(X_source)),X_source, c=kmeans.labels_, cmap="rainbow")
plt.xticks(range(len(label_sourceip)),label_sourceip,rotation=90)
plt.ylabel("The number of appearances",fontsize=15)

#destIP
# elbow plot determine k value
distortions = []
K = range(1,10)
for k in K:
  kmeanModel = KMeans(n_clusters=k)
  kmeanModel.fit(X_dest)
  distortions.append(sum(np.min(cdist(X_dest,kmeanModel.cluster_centers_,"euclidean")**2, axis=1)) / X_dest.shape[0])

plt.figure(figsize=(10,8))
plt.plot(K, distortions, "bx-")
plt.xlabel("k",fontsize=15)
plt.ylabel("Distortion",fontsize=15)

#apply kmeans with k = 2
kmeans = KMeans(n_clusters=2)
kmeans.fit(X_dest)

plt.figure(figsize=(20,8))
plt.scatter(range(len(X_dest)),X_dest, c=kmeans.labels_, cmap="rainbow")
plt.ylabel("The number of appearances",fontsize=15)

#%% Hierarchical
from scipy.cluster.hierarchy import dendrogram, linkage,fcluster
#source
linked_source = linkage(X_source, "average")
labelList_source = range(0, len(X_source))

plt.figure(figsize=(10, 8))
dendrogram(linked_source,labels=labelList_source,leaf_font_size=8)
plt.show()

Hie_source_labels = fcluster(linked_source,2,criterion="maxclust")

plt.figure(figsize=(20,8))
plt.scatter(range(len(X_source)),X_source, c=Hie_source_labels, cmap="rainbow")
plt.xticks(range(len(label_sourceip)),label_sourceip,rotation=90)
plt.ylabel("The number of appearances",fontsize=15)

#dest
linked_dest = linkage(X_dest, "average")
labelList_dest = range(0, len(X_dest))

plt.figure(figsize=(10, 8))
dendrogram(linked_dest,labels=labelList_dest,leaf_font_size=5)
plt.show()

Hie_dest_labels = fcluster(linked_dest,2,criterion="maxclust")

plt.figure(figsize=(20,8))
plt.scatter(range(len(X_dest)),X_dest, c=Hie_dest_labels, cmap="rainbow")
plt.ylabel("The number of appearances",fontsize=15)

#%% GMM
from sklearn.mixture import GaussianMixture as GMM
# source
gmm_source = GMM(n_components=2).fit(X_source)

gmm_source_labels = gmm_source.predict(X_source)
plt.figure(figsize=(20,8))
plt.scatter(range(len(X_source)),X_source, c=gmm_source_labels, s=40, cmap="viridis")

# dest
gmm_dest = GMM(n_components=2).fit(X_dest)

gmm_dest_labels = gmm_dest.predict(X_dest)
plt.figure(figsize=(20,8))
plt.scatter(range(len(X_dest)),X_dest, c=gmm_dest_labels, s=40, cmap="viridis")


#%%