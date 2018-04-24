from pylab import *
import matplotlib.pyplot as plt
import pandas as pd
from datetime import datetime

def data_init(data_dict):
    date = str(data_dict['id'])
    #date = str(1984)
    areaid =date[-2:]
    location = r'D:\libwork\data\jingjinji\study_area1/'+date+'/'+areaid+'_stats.csv'
    hnFrame = pd.read_csv(location)
    #print(hnFrame)
    area = hnFrame['AREA'].values.tolist()
    print(area)
    data_dict['Area'].extend(area)

def data_collect(data_dict):
    data_dict['Area'] = []
    data_dict['year'] = []
    data_dict['dArea'] = []
    idlist = range(1984, 2018)
    idlist.remove(2012)
    for id in idlist:
        data_dict['id'] = id
        data_dict['year'].append(id)
        # area_compute(data_dict)
        data_init(data_dict)


    dArea = [data_dict['Area'][i + 1] - data_dict['Area'][i] for i in range(len(data_dict['Area']) - 1)]
    #print(dArea)
    data_dict['Area'] =pd.Series(data_dict['Area'], index=data_dict['year'])
    data_dict['dArea'] = pd.Series(dArea, index=data_dict['year'][1:])
    data_dict['dArea_2'] = pd.rolling_mean(data_dict['dArea'],3)
    print(data_dict['Area'])
    print(data_dict['dArea'])

    #data_dict['Area'].to_csv(r'D:\libwork\data\jingjinji\study_area1/image\csv\result\resultimages\refine\refinedcsv/84-17area.csv')

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

def area_compute(data_dict):
    path=r'D:\libwork\data\jingjinji\study_area1\image\csv\result\resultimages\refine\refinedcsv/'
    class_names = ['luodi', 'shan', 'tian', 'cun', 'huangdi']
    date=str(data_dict['id'])
    loc=path+date+'-class_proba_refined.csv'
    prFrame=pd.read_csv(loc)
    cla=pd.DataFrame(prFrame.values,columns=class_names)
    luo=cla['luodi'].values.tolist()
    area = sum([item*900 for item in luo if item>0.7])
    print(area)
    data_dict['Area'].append(area)

def plot(data_dict,ti):
    fig = plt.figure()
    # ax1 = fig.add_subplot(2, 2, 1)
    # ax2 = fig.add_subplot(2, 2, 2)
    ax2 = fig.add_subplot(1,1,1)
    # ax4 = fig.add_subplot(2, 2, 4)
    #data_dict['Area'].plot(grid=True, style='ko--', label='Total Area')
    # ax1.plot(data_dict['Area'], 'ko--', label='Total Area')
    # #ax1.plot(data_dict['Area_BJ'], 'ro--', label='Area in Beijing')
    # ax1.plot(data_dict['Area_TJ'], 'bo--', label='Area in Tianjin')
    # ax1.plot(data_dict['Area_hbj'], 'go--', label='Area in Hebei')
    # ax1.legend(loc='best')
    # ax1.set_ylabel('Km^2',fontsize=18)
    # ax1.set_title('Area of Open Quarries',fontsize=20)
    # #ax1.grid(color='k', linewidth='0.3', linestyle='--')
    # for label in ax1.get_xticklabels()+ax1.get_yticklabels():
    #     label.set_fontsize(16)
    # savefig('area of three places.png',dpi=300)
    #
    #ax2.plot(data_dict['Area_BJ'], 'ro--', label='Area in Beijing')
    ax2.plot(data_dict['Area_TJ'], 'bo--', label='Area in Tianjin')
    ax2.legend(loc='upper left')
    ax2.set_ylabel('Area in Tianjin (Km^2)',fontsize=18)
    ax2.grid(color='k', linewidth='0.3', linestyle='--')
    ax5 = ax2.twinx()
    ax5.plot(data_dict['Area_hbj'], 'go--', label='Area in Hebei')
    ax5.legend(loc='best')
    ax5.set_ylabel('Area in Hebei (Km^2)',fontsize=18)
    ax5.set_title('Area of Open Quarries')
    for label in ax2.get_xticklabels()+ax2.get_yticklabels()+ax5.get_yticklabels():
        label.set_fontsize(16)
    savefig('areacom.png',dpi=300)

    # ax3.plot(data_dict['Area'], 'ko--', label='Total Area')
    # ax3.legend(loc='upper left')
    # ax3.set_ylabel('Km^2',fontsize=18)
    # #ax3.grid(color='k', linewidth='0.3', linestyle='--')
    # # xticks(fontsize='small')
    # #ylim(0.4e7, 2.2e7)
    # ax3.set_title('Area of Open Quarries',fontsize=20)
    # for label in ax3.get_xticklabels()+ax3.get_yticklabels():
    #     label.set_fontsize(16)
    # savefig('Area.png',dpi=300)

    # ax4.plot(data_dict['dArea'], 'ko--', label='Area Change Per-Year')
    # ax4.legend(loc='best')
    # ax4.set_ylabel('Km^2',fontsize=18)
    # # ax4.grid(color='k', linewidth='0.3', linestyle='--')
    # ax4.set_title('Area Change of Open Quarries',fontsize=20)
    # for label in ax4.get_xticklabels()+ax4.get_yticklabels():
    #     label.set_fontsize(16)
    # savefig('Area change.png', dpi=300)


def test():
    data_dict = {}
    #data_collect(data_dict)
    # plot(data_dict['Area'],'Area of Open Quarries')
    data_collect(data_dict)

    fig = plt.figure()
    ax1 = fig.add_subplot(1, 2, 1)
    ax2 = fig.add_subplot(1, 2, 2)
    ax1.set_ylim(0.4e7, 2.2e7)
    ax1.plot(data_dict['Area'], 'ko--', label='Total Area')
    ax1.legend(loc='best')
    ax1.set_ylabel('m^2')
    ax1.grid(color='k', linewidth='0.3', linestyle='--')
    # xticks(fontsize='small')

    ax1.set_title('Area of Open Quarries')

    ax2.plot(data_dict['dArea'], 'ko--', label='Area Change Per-Year')
    ax2.legend(loc='best')
    ax2.set_ylabel('m^2')
    ax2.grid(color='k', linewidth='0.3', linestyle='--')
    ax2.set_title('Area Change of Open Quarries')
    show()
    #data_dict['Area'].to_csv('D:\libwork\data\jingjinji\study_area1/84-17area.csv')

def toa_rf():
    data_dict = {}
    location = [
        r'D:\libwork\data\jingjinji\study_area1\cut_toa\refine\htarea-with-demmask.csv']
    # area_compute(data_dict)
    # data_init(data_dict)
    fig = plt.figure()
    ax1 = fig.add_subplot(2, 2, 1)
    ax2 = fig.add_subplot(2, 2, 2)
    ax3 = fig.add_subplot(2, 2, 3)
    ax4 = fig.add_subplot(2, 2, 4)
    for i in location:
        data_dict['location'] = i
        data_incol(data_dict)
        plot(data_dict, 'Area of Open Quarries')

    show()

def plot_pixel_smooth():
    ind=range(1984,2018)
    ind = ind.remove(2012)
    readin = pd.read_csv(r"D:\libwork\data\jingjinji\study_area1\cut_toa\result\proba_ta.csv")
    pixels = pd.DataFrame(readin.values,columns =ind)
    onepix = pd.Series(pixels.iloc[149,:],index=ind)
    print(onepix)
    mf = med_smooth(onepix,)
    plt.plot(onepix,'b')
    plt.grid(color='k', linewidth='0.3', linestyle='--')
    plt.show()
    plt.plot(mf,'r')

    plt.grid(color='k', linewidth='0.3', linestyle='--')
    plt.show()

def med_smooth(a):
    b=[i for i in a]
    range(33)
    for i in range(31):
        b[i+1]=median(a[i:i+3])
    return b

if __name__=='__main__':
  #test()
  data_dict = {}
  location = [#r'D:\libwork\data\jingjinji\study_area1\cut_toa\result_test\weighted_mean\refine\htarea-with-demmask.csv']
              r'D:\libwork\data\jingjinji\study_area1\cut_toa\refine\htarea-with-demmask.csv']
  # area_compute(data_dict)
  # data_init(data_dict)

  for i in location:
      data_dict['location'] = i
      data_incol(data_dict)
      plot(data_dict, 'Area of Open Quarries')

  show()
  # plot_pixel_smooth()
