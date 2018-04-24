% mkdir([root, 'balance\']);
rootp=[root,'result_test\weighted_mean\'];
mkdir([rootp, 'refine\']);
mkdir([rootp, 'refine\jpeg\']);
mkdir([rootp, 'unrefine\']);
mkdir([rootp, 'unrefine\jpeg\']);
%mkdir([root, 'compare\']);

eee = ccc;
[Timage, geo]=geotiffread(strcat(root,'cut\1984.tif'));
        info=geotiffinfo(strcat(root,'cut\1984.tif'));
% 
% for k = 1:t
%     for i = 1:5
%         w = mean2(eee(:,:,i,k));
%         s = std2(eee(:,:,i,k));
%         eee(:,:,i,k) = (eee(:,:,i,k) - w)/s*gs(i)+gm(i);
%     end;
%     %imwrite(double(eee(:,:,:,k)), [root, 'balance\', d(k).name]);
%     geotiffwrite([root, 'balance\', d(k).name], double(eee(:,:,:,k)), geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
% 
% end;

mmm = eee;

for k = 1:t
    disp(k);
    if (k == 1)
        mmm(:,:,:,1) = eee(:,:,:,1);
    elseif  (k == t)
        mmm(:,:,:,t) = eee(:,:,:,t);
    else
     
      if (k == 2 || k == t-1)
          r = 1;
      else
          r = 2;
      end;
      
      l1 = max(k-r, 1);
      l2 = min(k+r, t);
      u = eee(:,:,:,l1:l2);
      mmm(:,:,:,k) = median(u, 4);
    end;
    
    if (z > 2)
        mmm(:,:,:,k) = imsharpen(mmm(:,:,:,k));
    end;

    comp = [ccc(:,:,:,k), mmm(:,:,:,k)];
    %imwrite(double(mmm(:,:,:,k)), [root, 'refine\', d(k).name]);
    m= ones(size(mmm,1),size(mmm,2),1);
    mm(:,:,1)=mmm(:,:,1,k);
    mm(:,:,2)=mmm(:,:,2,k);
    mm(:,:,3)=m*128;
    ee(:,:,1)=eee(:,:,1,k);
    ee(:,:,2)=eee(:,:,2,k);
    ee(:,:,3)=m*128;
    imwrite(double(mm), [rootp, 'refine\jpeg\', d(k).name(1:4), '.jpg']);
     imwrite(double(ee), [rootp, 'unrefine\jpeg\', d(k).name(1:4), '.jpg']);
     
    %imwrite(double(mmm(:,:,1,k)), [root, 'refine\jpeg\', d(k).name(1:4), '.jpg']);
     %imwrite(double(eee(:,:,1:2,k)), [root, 'unrefine\jpeg\', d(k).name(1:4), '.jpg']);
    %imwrite(double(comp), [root, 'compare\', d(k).name]);
     geotiffwrite([rootp, 'refine\', d(k).name], double(mmm(:,:,:,k)), geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
    %geotiffwrite([root, 'refine\jpeg\', d(k).name(1:4),'.jpg'], double(mmm(:,:,:,k)), geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
    %geotiffwrite([root, 'compare\', d(k).name], double(comp), geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);

end;
