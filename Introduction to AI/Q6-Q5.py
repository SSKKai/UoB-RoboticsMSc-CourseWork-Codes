# -*- coding: utf-8 -*-
# For Python 2 / 3 compatability
from __future__ import print_function
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from math import log
import random

#%% prepare dataset
data = pd.read_csv("coursework2.csv")
cw = data[['sourceIP','destIP','classification']]
cw.insert(1,'source_cluster','')
cw.insert(3,'dest_cluster','')
cw = cw.copy()

allsourceip = cw['sourceIP'].tolist()
alldestip=cw['destIP'].tolist()

count_sourceIP = pd.value_counts(allsourceip)
num_sourceIP = np.array(count_sourceIP.values.tolist())
label_sourceIP = np.array(count_sourceIP.index.tolist())

source_cluster1 = label_sourceIP[np.where(num_sourceIP <= 20)]
source_cluster2 = label_sourceIP[np.where((num_sourceIP >20)&(num_sourceIP <= 200))]
source_cluster3 = label_sourceIP[np.where((num_sourceIP >200)&(num_sourceIP <= 400))]
source_cluster4 = label_sourceIP[np.where(num_sourceIP > 400)]

for x in range(len(source_cluster1)):
    cw.loc[cw['sourceIP']==source_cluster1[x],'source_cluster']='source_cluster1'
for x in range(len(source_cluster2)):
    cw.loc[cw['sourceIP']==source_cluster2[x],'source_cluster']='source_cluster2'
for x in range(len(source_cluster3)):
    cw.loc[cw['sourceIP']==source_cluster3[x],'source_cluster']='source_cluster3'
for x in range(len(source_cluster4)):
    cw.loc[cw['sourceIP']==source_cluster4[x],'source_cluster']='source_cluster4'
    

count_destIP = pd.value_counts(alldestip)
num_destIP = np.array(count_destIP.values.tolist())
label_destIP = np.array(count_destIP.index.tolist())

dest_cluster1 = label_destIP[np.where(num_destIP <= 40)]
dest_cluster2 = label_destIP[np.where((num_destIP >40)&(num_destIP <= 100))]
dest_cluster3 = label_destIP[np.where((num_destIP >100)&(num_destIP <= 400))]
dest_cluster4 = label_destIP[np.where(num_destIP > 400)]

for x in range(len(dest_cluster1)):
    cw.loc[cw['destIP']==dest_cluster1[x],'dest_cluster']='dest_cluster1'
for x in range(len(dest_cluster2)):
    cw.loc[cw['destIP']==dest_cluster2[x],'dest_cluster']='dest_cluster2'
for x in range(len(dest_cluster3)):
    cw.loc[cw['destIP']==dest_cluster3[x],'dest_cluster']='dest_cluster3'
for x in range(len(dest_cluster4)):
    cw.loc[cw['destIP']==dest_cluster4[x],'dest_cluster']='dest_cluster4'

cw = cw[['source_cluster','dest_cluster','classification']]
dt_data = np.array(cw).tolist() 
header = ["source_cluster", "dest_cluster", "label"]
#%%
# random split the dataset into training set and testing set
def random_split(full_list,shuffle,ratio):
    n_total = len(full_list)
    offset = int(n_total * ratio)
    if n_total==0 or offset<1:
        return [],full_list
    if shuffle:
        random.shuffle(full_list)
    sublist_1 = full_list[:offset]
    sublist_2 = full_list[offset:]
    return sublist_1,sublist_2

###############################################
#This is for buding the tree
###############################################

# calculate the information entropy
def calc_ent(dataSet):
    countDataSet = len(dataSet)
    labelCounts={}
    for featVec in dataSet:
        currentLabel=featVec[-1]
        # find unique feature value
        if currentLabel not in labelCounts.keys():
            labelCounts[currentLabel] = 0
        labelCounts[currentLabel] += 1
  
    # calculate entropy  
    info_entropy = 0.0
    for key in labelCounts:
        prob = float(labelCounts[key])/countDataSet
        info_entropy -= prob * log(prob,2)
    return info_entropy

#calculate information gain using entropy value
def info_gain(left, right, current_uncertainty):
    p = float(len(left)) / (len(left) + len(right))
    return current_uncertainty - p * calc_ent(left) - (1 - p) * calc_ent(right)


# find the best split condition at current node and calculate the corresponding gain value
def determine_node(dataSet):
    best_gain = 0
    best_question = None 
    current_uncertainty = calc_ent(dataSet)
    n_features = len(dataSet[0]) - 1  # number of columns
    for feat in range(n_features):  # for each feature
        values = set([data[feat] for data in dataSet])  # unique values in the column
        for val in values:  # for each value
            node = Node(feat, val)
            true_dataSet, false_dataSet = partition(dataSet, node)

            # Skip this split if it cannot split
            if len(true_dataSet) == 0 or len(false_dataSet) == 0:
                continue
            
            # Calculate the information gain from this split
            gain = info_gain(true_dataSet, false_dataSet, current_uncertainty)

            # update the highest gain value
            if gain >= best_gain:
                best_gain, best_question = gain, node

    return best_gain, best_question


#Counts the number of each type in a dataset
def class_counts(dataSet):
    counts = {}
    for data in dataSet:
        label = data[-1] #the last column of data is classification
        if label not in counts:
            counts[label] = 0
        counts[label] += 1
    total = sum(counts.values()) * 1.0
    for classification in counts.keys():
        counts[classification] = round((counts[classification] / total),3)
    return counts

#Test if a value is numeric
def is_numeric(value):
    return isinstance(value, int) or isinstance(value, float)


class Node:
    def __init__(self, feature, value):
        self.feature = feature
        self.value = value

    def match(self, example):
        # Compare the feature value in an example to the
        # feature value in this question.
        val = example[self.feature]
        if is_numeric(val):
            return val >= self.value
        else:
            return val == self.value

    def __repr__(self):
        # This is just a helper method to print
        # the question in a readable format.
        condition = "=="
        if is_numeric(self.value):
            condition = ">="
        return "%s %s %s?" % (header[self.feature], condition, str(self.value))

# partition the node according to the split condition
def partition(dataSet, node):
    true_dataSet, false_dataSet = [], []
    for data in dataSet:
        if node.match(data):
            true_dataSet.append(data) #true branch
        else:
            false_dataSet.append(data) #false branch
    return true_dataSet, false_dataSet

def build_tree(dataSet):
    gain, node = determine_node(dataSet)
    
    if gain == 0: # if the subdataset has only one category of data(gain=0), it is a leaf
        return Leaf(dataSet)
    else: #else, it is a node and split into two branches
        true_dataSet, false_dataSet = partition(dataSet, node)
        
        # Recursively build each brance
        true_branch = build_tree(true_dataSet)
        false_branch = build_tree(false_dataSet)
    return Decision_Node(node, true_branch, false_branch)


################################################
#The way to store and display trees is inspired by Google
################################################
class Leaf:

    def __init__(self, dataSet):
        self.predictions = class_counts(dataSet)


class Decision_Node:
    def __init__(self,node,true_branch,false_branch):
        self.node = node
        self.true_branch = true_branch
        self.false_branch = false_branch


def print_tree(tree, spacing=""):
    # Base case: we've reached a leaf
    if isinstance(tree, Leaf):
        print (spacing + "Predict", tree.predictions)
        return

    # Print the question at this node
    print (spacing + str(tree.node))

    # Call this function recursively on the true branch
    print (spacing + '--> True:')
    print_tree(tree.true_branch, spacing + "  ")

    # Call this function recursively on the false branch
    print (spacing + '--> False:')
    print_tree(tree.false_branch, spacing + "  ")



###############################################
#This is for evaluation
###############################################

# classify single data, output in dictionary format
def classify(data, tree):
    if isinstance(tree, Leaf):
        return tree.predictions
    # Decide whether is the true-branch or the false-branch.
    if tree.node.match(data):
        return classify(data, tree.true_branch)
    else:
        return classify(data, tree.false_branch)

# check the classification accuracy
def check_accuracy(test_data,my_tree):
    test_num = len(test_data)
    accurate_num = 0
    for data in test_data:
        classify_result = classify(data, my_tree)
        # compare the data's classification and the most likely classification of prediction
        if max(classify_result,key=lambda x:classify_result[x]) == data[-1]:
            accurate_num += 1
    accuracy = accurate_num / test_num
    return accuracy

# output set whose classification result can be seen as unambiguous
def output_unambiguous_ans(test_data,mytree,threshold):
    unambiguous_data = []
    for data in test_data:
        classify_result = classify(data, my_tree)
        # compare the data's max classification probability with threshold
        if max(classify_result.values()) >= threshold:
            if data not in unambiguous_data:
                unambiguous_data.append(data)
    return unambiguous_data
                

#################################################
#################################################
#################################################


if __name__ == '__main__':
    
    testing_data,training_data = random_split(dt_data,shuffle=True,ratio=0.1)

    my_tree = build_tree(dt_data)

    print_tree(my_tree)

    
    accuracy = check_accuracy(testing_data, my_tree)    
    print()
    print("Accuracy of testing set= ",accuracy)
    unambiguous_data = output_unambiguous_ans(dt_data,my_tree,1)
    #try unambiguous_data = output_unambiguous_ans(dt_data,my_tree,0.95)
    print()
    print(unambiguous_data)
