# coding:utf8
import pandas as pd
import numpy as np
from sklearn import linear_model
import matplotlib.pyplot as plt
import random
from pylab import savefig
from scipy.optimize import curve_fit
def main():
    quarry = r'D:\libwork\data\jingjinji\study_area1\cut_toa\refine\htarea-with-demmask.csv'
    sta =[ r'D:\libwork\data\jingjinji\study_area1\cut_toa\stats\beijing_GRP.csv',
           r'D:\libwork\data\jingjinji\study_area1\cut_toa\stats\langfang_GRP.csv',#此处改用廊坊的GDP
           r'D:\libwork\data\jingjinji\study_area1\cut_toa\stats\hebei_Buliding-area.csv',
           r'D:\libwork\data\jingjinji\study_area1\cut_toa\stats\hebei_Cement-production.csv',
           r'D:\libwork\data\jingjinji\study_area1\cut_toa\stats\tianjin_Buliding-area.csv',
           r'D:\libwork\data\jingjinji\study_area1\cut_toa\stats\tianjin_Cement-production.csv',
           r'D:\libwork\data\jingjinji\study_area1\cut_toa\stats\beijing_Buliding-area.csv',
           r'D:\libwork\data\jingjinji\study_area1\cut_toa\stats\GDP.csv',
           r'D:\libwork\data\jingjinji\study_area1\cut_toa\stats\population.csv'
           ]
    name = ['Beijing', 'Tianjin', 'Total', 'Heibei']
    index = range(1984, 2018)
    data_dict={}
    data_dict['location']=quarry
    data_incol(data_dict)
    # qf = pd.read_csv(quarry)
    # qf = pd.DataFrame(qf.values, index=index, columns=name)
    # qf = qf.drop(2012)

    se=['bj_GRP', 'hb_GRP',  'hb_BA', 'hb_CP', 'tj_BA', 'tj_CP', 'bj_BA', 'GDP', 'popu']
    sed={}
    qfd={}
    for i in range(len(se)-2):
        statemp=pd.read_csv(sta[i])
        statemp = pd.DataFrame(statemp.iloc[0, 1:].values, index=strl2n(statemp.iloc[0, 1:].index.tolist()), columns=[se[i]])
        statemp = statemp.dropna()
        if 2012 in statemp.index.tolist():
            statemp = statemp.drop(2012)
        sed[se[i]] = statemp
        qfd[se[i]] = data_dict['Area'][statemp.index.tolist()]
    for i in range(7,9):
        statemp = pd.read_csv(sta[i])
        statemp = pd.DataFrame(statemp.iloc[:, 1].values, index=statemp.iloc[:, 0].values.tolist(), columns=[se[i]])
        statemp = statemp.dropna()
        sed[se[i]] = statemp
        qfd[se[i]] = data_dict['Area'][strl2n(statemp.index.tolist())]

    gq = pd.merge(sed['hb_GRP'].loc[2009:],pd.DataFrame(qfd['hb_GRP'].loc[2009:]),left_index=True,right_index=True)
    print(gq)
    gdp_rate=[]
    tf_rate=[]

    for i in range(len(gq)):
        rate_temp=(gq.iloc[:,:]-gq.iloc[i,:])/gq.iloc[i,:]
        gt = rate_temp.iloc[:,0].tolist()
        gt.remove(0.0)
        gdp_rate.extend(gt)
        tt = rate_temp.iloc[:,1].tolist()
        tt.remove(0.0)
        tf_rate.extend(tt)

    gdp_rate = pd.Series(gdp_rate)
    tf_rate = pd.Series(tf_rate)
    #print(gdp_rate)

    G_rate = []
    Q_rate = []
    for i in range(500):
        rn = random.randint(0,len(gdp_rate)-1)
        G_rate.append(gdp_rate[rn])
        Q_rate.append(tf_rate[rn])

    polyfit(tf_rate,gdp_rate)
    lreg(qfd['hb_GRP'].loc[2009:], sed['hb_GRP'].loc[2009:])
    lreg(qfd['hb_GRP'].loc[:2009], sed['hb_GRP'].loc[:2009])

    fig=plt.figure()
    ax=fig.add_subplot(111)
    ax.plot(sed['hb_GRP'],'bo--',label='GRP of Langfang')
    ax.legend(loc='upper left')
    ax.set_ylabel('GRP in Langfang(100 Million Yuan)', fontsize=18)
    # ax.grid(color='k', linewidth='0.3', linestyle='--')

    ax2=ax.twinx()
    ax2.plot(qfd['hb_GRP'], 'go--',label='Quarry area')
    ax2.set_xlabel('Year')
    ax2.set_ylabel('Quarry Area(Km^2)',fontsize=18)

    ax2.legend(loc='lower right')
    for label in ax.get_xticklabels()+ax.get_yticklabels()+ax2.get_yticklabels():
        label.set_fontsize(16)
    savefig('grpcom.png',dpi=300)
    #plt.grid(color='k', linewidth='0.3', linestyle='--')
    plt.show()


def data_incol(data_dict):
    hnFarme = pd.read_csv( data_dict['location'])
    print(hnFarme)
    area_bj = [i/1000000 for i in hnFarme['0'].values.tolist()]
    area_tj = [i/1000000 for i in hnFarme['0.1'].values.tolist()]
    area_hb = [i/1000000 for i in hnFarme['0.3'].values.tolist()]
    area = [i/1000000 for i in hnFarme['0.2'].values.tolist()]
    area_bj.remove(0)
    area_tj.remove(0)
    area_hb.remove(0)
    area.remove(0)
    print(area_bj)
    data_dict['year'] = []
    data_dict['Area_BJ'] = []
    data_dict['Area_TJ'] = []
    data_dict['Area_HB'] = []
    data_dict['Area'] = []
    data_dict['dArea'] = []
    data_dict['Area_hbj'] = []
    idlist = range(1984, 2018)
    idlist.remove(2012)
    data_dict['year'].extend(idlist)
    data_dict['Area_BJ'] = pd.Series(area_bj, index=data_dict['year'])
    data_dict['Area_TJ'] = pd.Series(area_tj, index=data_dict['year'])
    data_dict['Area_HB'] = pd.Series(area_hb, index=data_dict['year'])
    data_dict['Area'] = pd.Series(area, index=data_dict['year'])
    dArea = [area[i + 1] - area[i] for i in range(len(area) - 1)]
    data_dict['dArea'] = pd.Series(dArea, index=data_dict['year'][1:])
    data_dict['Area_hbj'] = pd.Series(map(lambda x: x[0]+x[1], zip(area_bj, area_hb)), index=data_dict['year'])


    #data_dict['dArea'].to_csv('D:\libwork\data\jingjinji\study area1/84-17darea.csv')
# 线性拟合
def lreg(x,y):
    regr=linear_model.LinearRegression()
    regr.fit(x.reshape(-1,1),y)
    a,b=regr.coef_,regr.intercept_

    fig =plt.figure(1)
    ax = fig.add_subplot(111)
    ax.scatter(x,y,color='blue')
    ax.plot(x,regr.predict(x.reshape(-1,1)),color='red',linewidth =2, label = 'y = %5.3f*x%5.3f\nR^2 = %.5f'%(a,b,regr.score(x.reshape(-1,1),y)))
    #plt.text(0.,15,r'R^2 = %.5f'%regr.score(x.reshape(-1,1),y))
    #plt.text(0,13,r'y = %5.3f*x+%5.3f'%(a,b))
    #plt.title('GRP')
    ax.set_xlabel('Quarry Area(Km^2)',fontsize=18)
    ax.set_ylabel('GRP of Langfang(100 Million Yuan)',fontsize=18)
    ax.legend(loc='upper left')
    #plt.grid(color='k', linewidth='0.3', linestyle='--')
    for label in ax.get_xticklabels()+ax.get_yticklabels():
        label.set_fontsize(16)
    savefig('%f.png'%a,dpi=300)
    print(regr.score(x.reshape(-1,1),y))

    # plt.figure(2)
    # plt.plot(x, 'ko')
    # ax2 =plt.twinx()
    # ax2.plot(y,'g^')
    plt.show()


# 二次拟合
def func(x,a,b,c):
    return [a*t*t+b*t+c for t in x]

def polyfit(x,y):
    results={}
    popt,pcov = curve_fit(func,x,y)
    results['polynomial'] = popt
    results['covariance'] = pcov

    #r-squared
    yhat = func(x,popt[0],popt[1],popt[2])
    ybar = sum(y)/len(y)
    ssreg = sum((yhat-y)**2)
    sstot = sum((y-ybar)**2)
    results['determination'] = 1-ssreg/sstot

    e = abs(y-yhat)
    erange = max(e)-min(e)
    er = [a/(b**2) for (a,b) in zip(e,abs(y))]
    print(sum(e)/len(e))
    for i in range(10):
        #print([pp for pp in er if pp>=i/100.0 and pp<(i+1)/100.0])

        n = len([pp for pp in e if pp>=min(e)+erange*i/10.0 and pp<=min(e)+erange*(i+1)/10.0])
        print ('%5.3f<e<%5.3f: %d  %5.4f'%(min(e)+i*erange/10.0, min(e)+erange*(i+1)/10.0, len([pp for pp in e if pp>=min(e)+erange*i/10.0 and pp<=min(e)+erange*(i+1)/10.0]), float(n)/len(e)))

    xdata = np.linspace(-0.4,1.4)
    fig=plt.figure()
    ax=fig.add_subplot(111)
    ax.scatter(x, y, color='blue')
    ax.plot(xdata, func(xdata,*popt), color='red', linewidth=2,label='y = %5.3f*x^2+%5.3f*x%5.3f\nR^2 = %.5f' % tuple(popt.tolist()+[results['determination']]))
    #plt.text(0, 12, r'R^2 = %.5f' % results['determination'])
    #plt.text(0, 13, r'y = %5.3f*x^2+%5.3f*x+%5.3f' % popt)
    # plt.title('GRP')
    ax.set_xlim(-0.8,1.7)
    ax.set_xlabel('Quarry Area Change Rate',fontsize=18)
    ax.set_ylabel('GRP Change Rate',fontsize=18)
    ax.legend(loc='upper left')
    for label in ax.get_xticklabels()+ax.get_yticklabels():
        label.set_fontsize(16)
    savefig('plofit.png',dpi=300)
    #plt.grid(color='k', linewidth='0.3', linestyle='--')
    plt.show()


    #return results


def strl2n(t):
    o = []
    for n in t:
        o.append(int(n))
    return o

if __name__=='__main__':
  main()