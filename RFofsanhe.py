# coding:utf8
from __future__ import division
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import roc_curve, auc
from sklearn.preprocessing import label_binarize
from sklearn.cross_validation import train_test_split,cross_val_score
from sklearn.metrics import accuracy_score,confusion_matrix,brier_score_loss
from sklearn.calibration import CalibratedClassifierCV
import pandas as pd
import numpy as np
from sklearn.externals import joblib
import os
import operator
import matplotlib.pyplot as plt
import time

def main():
    para={}
    ylist=range(1984,2018)
    ylist.remove(2012)
    #root=r'D:\libwork\data\jingjinji\study_area1\image\csv/'
    para['root']=r'D:\libwork\data\jingjinji\study_area1\cut_toa/'
    para['subroot'] = 'csvwithindex/'

    ispath = os.path.isdir( para['root'] + 'result_test')
    if ispath:
        print( para['root'] + 'result already exists!')
    else:
        os.mkdir( para['root'] + 'result_test')
    #para['class_names']=['luodi','shan','tian','cun','huangdi']
    para['class_names'] = ['not_luodi', 'loudi']
    #feature_names=['blue','green','red','NIR','SWIR1','SWIR2','class']
    para['feature_names']=['blue','green','red','NIR','SWIR1','SWIR2','NDVI','NDWI','NDBI','TCB','TCG','TCW','class']
    #os.mkdir(root+'result')
    # para['pro_ta'] = [[]]
    # para['pro_nt'] = [[]]
    # para['i']=2000
    # Classify(para)
    period_list = [2010,2013,2016]
    for i in range(len(period_list)-1):
        period=[period_list[i],period_list[i+1]]
        SamplePassing(para,period)
    # period = [2013,2017]
    # SamplePassing(para,period)
    # print(para['pro_ta'])

def stratifiedSampling(ima,para):
    para['is_train']=pd.DataFrame([])
    for i in range(len(para['class_names'])):
        imt=ima.loc[ima['class']==i]
        imt['is_train']=np.random.uniform(0,1,len(imt))<=.5
        para['is_train']=pd.concat([para['is_train'],imt])
    para['is_train']=para['is_train'].sort_index()

def Classify(para):
    date = str(para['i'])
    im = pd.read_csv(para['root'] + para['subroot']+date + '-data.csv')
    ima = pd.DataFrame(im.values, columns=para['feature_names'])
    stratifiedSampling(ima, para)
    ima['is_train'] = para['is_train']['is_train']
    im_train = ima[ima['is_train'] == True]
    feat = ima.columns[:12]
    clf = RandomForestClassifier(n_jobs=1, n_estimators=100)
    clf.fit(im_train[feat], im_train['class'])
    cla_pro = clf.predict_proba(ima[feat])
    preds = clf.predict(ima[feat])
    pd.DataFrame(cla_pro).to_csv(para['root'] + 'result_test/' + date + '-class_proba.csv')
    pd.DataFrame(preds).to_csv(para['root'] + 'result_test/' + date + '-class.csv')
    print(cla_pro[:,0])
    # para['pro_nt'] = np.hstack((para['pro_nt'], cla_pro[:, 1]))
    # para['pro_ta'] = np.hstack((para['pro_ta'],cla_pro[:,0]))

def Sampling(para,sub_p):
    date = str(para['i'])
    if not os.path.isfile(para['root'] + sub_p + date + '-class_proba.csv'):
        print('%s not exit'% date)
        return
    para['sample'] = pd.DataFrame([])
    cla_proba = pd.read_csv(para['root'] + sub_p + date + '-class_proba.csv')
    # cla=cla.values.tolist()
    # print(cla)
    cla_proba = cla_proba.iloc[:, 1:]
    c_proba = pd.DataFrame(cla_proba.values, columns=para['class_names'])
    part = [0.2, 0.5]
    # im = pd.read_csv(para['root'] + para['subroot'] + date + '-data.csv')
    # im = pd.DataFrame(im.values, columns=para['feature_names'])
    for i in range(len(para['class_names'])):
        c_mask=c_proba.loc[c_proba[para['class_names'][i]]>.8]# probability bigger than 0.8 as samples
        #c_mask = im.loc[im['class'] == i]
        c_mask['is_train'] = np.random.uniform(0, 1, len(c_mask)) <= part[i]  # take half of them
        c_mask['class_init'] = i
        para['sample'] = pd.concat([para['sample'], c_mask])
    para['sample'] = para['sample'].sort_index()
    para['sample'] = para['sample'][para['sample']['is_train'] == True]
    para['sample'] = para['sample'].loc[:, ['class_init', 'is_train']]

def SamplePassing(para,period):


    para['up']=[]
    para['down']=[]

    # deliver samples upwards
    direction = 'up'
    para['i']=period[0]
    subpath = ['result_test/'+direction+'/', 'result/']
    Sampling(para, subpath[1])
    update_sample(para, direction)
    para[direction].append(para['up_down_temp'])
    for i in range(period[0]+2,period[1]):
        para['i'] = i
        Sampling(para, subpath[0])
        update_sample(para, direction)
        para[direction].append(para['up_down_temp'])

    # deliver samples downwards
    direction = 'down'
    para['i'] = period[1]
    subpath = ['result_test/' + direction + '/', 'result/']
    Sampling(para, subpath[1])
    update_sample(para, direction)
    para[direction].append(para['up_down_temp'])
    for i in range(period[1]-1, period[0]+1,-1):
        para['i'] = i
        Sampling(para, subpath[0])
        update_sample(para, direction)
        para[direction].append(para['up_down_temp'])

    # compute a weighted mean result
    ispath = os.path.isdir(para['root'] + 'result_test/weighted_mean')
    if ispath:
        print(para['root'] + 'result_test/weighted_mean already exists!')
    else:
        os.mkdir(para['root'] + 'result_test/weighted_mean')
    period_length = period[1]-period[0]
    weight = range(1,period_length)
    for i in weight:
        date = str(i+period[0])
        temp =add(multiply(para['up'][i-1],period_length-i-1),multiply(para['down'][i-1],i))
        temp = division(temp,period_length)
        temp = normalize(temp)
        pd.DataFrame(temp).to_csv(para['root'] + 'result_test/weighted_mean' + '/' + date + '-class_proba.csv')

    #print(para['sample'])
    # c3 = para['sample'].loc[para['sample']['class_init']==0,'class_init']
    # mask = np.random.uniform(0,1,len(c3))<=.01
    # c3.loc[mask==True]=1
    # #c3.iloc[3]=4
    # para['sample'].loc[para['sample']['class_init'] == 0, 'class_init']=c3
    # #print(c3)
    # c4 = para['sample'].loc[para['sample']['class_init']==4,'class_init']
    # mask = np.random.uniform(0, 1, len(c4)) <= .8
    # c4.loc[mask==True]=3
    # para['sample'].loc[para['sample']['class_init'] == 4, 'class_init']=c4
    # c5 = para['sample'].loc[para['sample']['class_init'] == 5, 'class_init']
    # mask = np.random.uniform(0, 1, len(c5)) <= .8
    # c5.loc[mask == True] = 2
    # para['sample'].loc[para['sample']['class_init'] == 5, 'class_init'] = c5

def multiply(a,b):# 换成np
    c = list(map(lambda i: i*b,a))
    return c

def add(a,b):
    c= list(map(operator.add,a,b))
    return c

def normalize(x):
    norm_sum = np.sum(x,1)
    y = np.array(x).T/norm_sum
    return y.T

def division(a,b):
    c = list(map(lambda i: i / b, a))
    return c


def update_sample(para,dire):
    direction_value = {'up': 1, 'down': -1}
    date=str(para['i']+direction_value[dire])
    if not os.path.isfile(para['root'] + 'csvwithindex/'+date + '-data.csv'):
        date = str(para['i'] + 2*direction_value[dire])
    im = pd.read_csv(para['root'] + 'csvwithindex/'+date + '-data.csv')
    ima = pd.DataFrame(im.values, columns=para['feature_names'])
    cla = pd.read_csv(para['root'] + 'result/' + date + '-class.csv')
    cla = cla.iloc[:, 1:]
    ima['tclass']=cla
    print("quarry num in tclass: %f" % len(cla.loc[cla['0']==1]))
    print("sample num: %f" % len(para['sample']))
    t=1
    while t:
        im_train=pd.merge(ima,para['sample'],left_index=True,right_index=True)
        #print(im_train.loc[im_train['class_init'] != im_train['tclass'],['class','tclass','class_init']])
        #ima['is_train'] = para['sample']['is_train']

        posi_sl = len(im_train.loc[im_train['class_init']==1])
        true_sl = len(im_train.loc[im_train['tclass']==1])

        sample_check = (im_train['class_init'] ==1) & (im_train['tclass'] ==1)
        sample_check = sample_check.values.tolist()
        sample_error = sample_check.count(True) /posi_sl# the right rate of quarry in samples
        #print("the rate of right quarry samples in all quarry samples: %0.8f" % sample_error)  # 0.26555313

        feat = ima.columns[:3]
        classifiers = [
            KNeighborsClassifier(n_neighbors=7,weights='distance'),
            SVC(kernel="linear", C=0.025),
            # C penality factor bigger for a better generalization and smaller for a better accurate in samples test
            SVC(gamma=2, C=1),
            RandomForestClassifier(n_estimators=1000, n_jobs=-1),
            AdaBoostClassifier(),
            GaussianNB()]
        clf=classifiers[5]
        # X_train, X_test, y_train, y_test = train_test_split(im_train[feat], im_train['class_init'], test_size=.4)
        # clf.fit(X_train,y_train)
        # cla_pro = clf.predict_proba(X_test)
        # preds = clf.predict(X_test)
        # preds_sample=clf.predict(X_train)
        # preds_sample_pro = clf.predict(X_train)
        # # 10次10折交叉验证
        # s_mask = preds_sample == y_train
        # s_mask = s_mask.sort_index()
        # preds_w = y_train[s_mask == False]
        # pred_error = im_train.loc[preds_w.index,['class','tclass','class_init']]
        # scores = cross_val_score(clf,im_train[feat],im_train['class_init'],cv=10)
        # print("Accuracy of 10 * 10fold cross validation: %0.5f (+/- %0.5f)" % (scores.mean(),scores.std()*2))
        # print("the rate of right preds in samples: %0.8f" % accuracy_score(preds_sample,y_train))

        # 概率校准
        # clf_isotonic = CalibratedClassifierCV(clf,cv=5,method='isotonic')
        # clf_isotonic.fit(X_train,y_train)
        # y_pred = clf_isotonic.predict_proba(X_test)[:,1]
        # clf_isotonic_score = brier_score_loss(y_test,y_pred)
        # print("brier score of clf_isotonic: %0.8f" % clf_isotonic_score)
        # Compute ROC curve and ROC area for each class
        # fpr, tpr, _ = roc_curve(y_test, cla_pro[:, 1])
        # roc_auc = auc(fpr, tpr)

        # plt.figure()
        # lw = 1
        # plt.plot(fpr, tpr, color='darkorange',
        #          lw=lw, label='ROC curve (area = %0.2f)' % roc_auc)
        # plt.plot([0, 1], [0, 1], color='navy', lw=lw, linestyle='--')
        # plt.xlim([0.0, 1.0])
        # plt.ylim([0.0, 1.05])
        # plt.xlabel('False Positive Rate')
        # plt.ylabel('True Positive Rate')
        # plt.title('Receiver operating characteristic example')
        # plt.legend(loc="lower right")
        # plt.show()

        # #print(im_train.loc[preds != im_train['class_init'],['class','tclass','class_init']])
        # sample_check = (preds_sample ==1)&(y_train==1)
        # sample_check = sample_check.values.tolist()
        # true_ld = len(X_train.loc[y_train== 1])
        # sample_error = sample_check.count(True) / true_ld# the right rate of right predicted quarry to true quarry
        # print("the rate of right quarry preds in true class: %0.8f" % sample_error)  # 0.26555313   85 for 85: 0.1113068     84 for 85: 0.302149  Sample passing is not feasible
        #
        # # print('oob_error: ', 1 - clf.oob_score_) #0.147547  0.13826
        # # print("feature importance: ", clf.feature_importances_, '\n')
        # #para['sample'] = pd.merge(pred_error, para['sample'], left_index=True, right_index=True)
        clf.fit(im_train[feat],im_train['class_init'])
        s_pro = clf.predict_proba(im_train[feat])
        s_pred = clf.predict(im_train[feat])
        #print(confusion_matrix(im_train['class_init'], s_pred))
        # 更新样本
        s_cla = pd.DataFrame([])
        s_prob = pd.DataFrame(s_pro,columns=para['class_names'])
        for i in range(len(para['class_names'])):
            s_mask = s_prob.loc[s_prob[para['class_names'][i]] > .8]
            s_mask['class_p'] = i
            s_cla = pd.concat([s_cla, s_mask])
        mask = pd.merge(im_train[['class_init','tclass']],s_cla,left_index=True,right_index=True)
        mask=mask.sort_index()
        m = mask['class_init']==mask['class_p']
        pred_wrong = mask.loc[m==False]
        para['sample'] = para['sample'].loc[list(set(para['sample'].index)-set(pred_wrong.index))]
        #print(para['sample'])
       # 终止循环的条件
        pred_error = im_train.loc[pred_wrong.index, ['class', 'tclass', 'class_init']]
        if not pred_error.empty:
            pred_error_l = pred_error['class_init']==pred_error['tclass']
            pred_error_l = pred_error_l.values.tolist()
            pred_error_l_rate = pred_error_l.count(False)/len(pred_error)
            #print("the rate of  wrong(changed) samples in error preds: %0.8f\n" % pred_error_l_rate)#preds~=init & init ~= tclass
        else:
            t=0
    print(len(para['sample']))
    im_train = pd.merge(ima, para['sample'], left_index=True, right_index=True)
    clf2 = GaussianNB()
    clf2.fit(im_train[feat], im_train['class_init'])
    clf2_iso = CalibratedClassifierCV(clf2,cv=5,method='isotonic')
    clf2_iso.fit(im_train[feat], im_train['class_init'])
    cls_pro = clf2_iso.predict_proba(ima[feat])
    cls = clf2_iso.predict(ima[feat])
    para['up_down_temp'] = cls_pro
    ispath = os.path.isdir(para['root'] + 'result_test/'+dire)
    if ispath:
        print(para['root'] + 'result_test/'+dire+' already exists!')
    else:
        os.mkdir(para['root'] + 'result_test/'+dire)
    pd.DataFrame(cls_pro).to_csv(para['root'] + 'result_test/' +dire+'/'+ date + '-class_proba.csv')
    pd.DataFrame(cls).to_csv(para['root'] + 'result_test/' + dire+'/'+date + '-class.csv')

def test():
    para = {}
    para['root'] = r'D:\libwork\data\jingjinji\study_area1\cut_toa/'
    para['subroot'] = 'csvwithindex/'
    para['class_names'] = ['not_luodi','luodi']
    para['feature_names'] = ['blue', 'green', 'red', 'NIR', 'SWIR1', 'SWIR2', 'NDVI', 'NDWI', 'NDBI', 'TCB', 'TCG',
                             'TCW', 'class']
    para['i']=2011
    para['pro_ta']=[[]]
    para['pro_nt'] = [[]]
    #Classify(para)
    # 从上一年分类结果中选取样本，用这一年的数据实测、筛除错误样本，返回para【’sample‘】
    SamplePassing(para)

def TuningForRF():
    para = {}
    fpath = r'D:\libwork\data\jingjinji\study_area1\cut_toa/'
    para['subroot'] = 'csvwithindex/'
    para['class_names'] = ['not_luodi', 'luodi']
    para['feature_names'] = ['blue', 'green', 'red', 'NIR', 'SWIR1', 'SWIR2', 'NDVI', 'NDWI', 'NDMI', 'TCB',
                                   'TCG', 'TCW', 'class']
    para['test_feature_names'] = ['blue', 'green', 'red', 'NIR', 'SWIR1', 'SWIR2', 'NDVI', 'NDWI', 'NDMI', 'TCB', 'TCG',
                                  'TCW']
    sample_leaf_options = range(1984,2018)
    sample_leaf_options.remove(2012)
    for leaf_size in sample_leaf_options:
        filepath = fpath + para['subroot'] + '/'+str(leaf_size)+'-data.csv'
        im_tr = pd.read_csv(filepath)
        ima = pd.DataFrame(im_tr.values, columns=para['feature_names'])
        print('Train data read in!\n')
        stratifiedSampling(ima, para)
        ima['is_train'] = para['is_train']['is_train']
        im_train = ima[ima['is_train'] == True]
        feat = ima.columns[:12]
          #[1,2,3,4,5,6,7,8]

        strat = time.time()
        para['clfL8'] = RandomForestClassifier(n_jobs=-1, n_estimators=100,oob_score=True)
        para['clfL8'].fit(im_train[feat], im_train['class'])
        finish = time.time()
        print('oob_error: %f' % para['clfL8'].oob_score_)
        #print("feature importance: %f" % para['clfL8'].feature_importances_)
        print('process time: %f \n' % (finish-strat))

def save_and_load_model():
    X = [[0, 0], [1, 1]]
    y = [0, 1]
    clf = SVC()
    clf.fit(X, y)
    joblib.dump(clf, "train_model.m")
    saved_clf = joblib.load("train_model.m")


if __name__=='__main__':
	#main()
    #test()
    TuningForRF()