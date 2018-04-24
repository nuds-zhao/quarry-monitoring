%root = 'X:\guilin\google\out2\';
%root = 'X:\beijing\out\';
%root = 'X:\sanya\out\';
%root = 'X:\kashi\out\';
%root = 'X:\fuzhou\fujian\out\';
%root = 'X:\xiongan\out\';
   %root = 'X:\xiongan\baiyangdian\out\';
%root = 'X:\xiongan\baoding\out\';
%root = 'X:\xiongan\combine\';
%root = 'X:\shantou\out\clip\';
%root = 'X:\xiongan\laiyuan\out\';
%root = 'X:\xiongan\shuiku\out\';
%root = 'X:\huashan\out\';
%root = 'X:\tianjin\out\';
%root = 'X:\yantai\out\';
%root = 'X:\daocheng\out\';
%root = 'X:\chengdu\l8\chengdu\out\';
%root = 'X:\beijing\beijing_all\out\';
%root = 'X:\shantou\river\shantou\out\';
%root = 'X:\Óª¿Ú\out\';
%root = 'D:\libwork\data\jingjinji\study_area1\class\rearranged\';
  %root = 'D:\libwork\data\jingjinji\study_area1\image\csv\result\resultimages\';
  %root='D:\libwork\data\Landsat\xionganMay\';
  %root='D:\libwork\data\jingjinji\study_area1\image\csvwithindex\';
  root='D:\libwork\data\jingjinji\study_area1\cut_toa\';


z = 1;

smooth_guided;
refine;
%margin_label([root, 'refine\']);

%make_gif([root, 'refine\label\'], '*.tif', [root, '..\animation.gif'], 0.5);
%make_video([root, 'refine\label\'], [root, '..\videomp4.mp4']);
