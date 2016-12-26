%% Written by Lien Peters

clear all;

Counter = 1;

% voxelsize aanpassen
voxelsize = 2;

% names scans
name_scans = [3 4 5 6 9 10 11 12 15 16 17 18 19];

% bij het kiezen van je onder- en bovengrens van i moet je gewoon zien
% dat je al je runs inleest (dus i moet al je runnummers omvatten)
for i = 1:size(name_scans,2)
    num = num2str(name_scans(1,i));
    % filenaam
    MP = load(['rp_aD14_' num '_1.txt']);

    Tr1 = MP(:,1);
    Tr2 = MP(:,2);
    Tr3 = MP(:,3);

    % j gaat van 1 tot het aantal dynamische scans - 1
    % ik heb 85 dynamische scans, dus mijn j gaat tot 84
    for j = 1:84
        v1(j) = Tr1(j+1) - Tr1(j);
        v2(j) = Tr2(j+1) - Tr2(j);
        v3(j) = Tr3(j+1) - Tr3(j);
        GM(j) = sqrt((Tr1(j+1) - Tr1(j))^2 + (Tr2(j+1) - Tr2(j))^2 + (Tr3(j+1) - Tr3(j))^2);
    end

    max_v1(Counter) = max(abs(v1));
    max_v2(Counter) = max(abs(v2));
    max_v3(Counter) = max(abs(v3));
    max_geomtr(Counter) = max(GM);
    Counter = Counter+1;
end

max_geomtr
max_v1
max_v2
max_v3

figure(1)
title('Motion parameters');
% geometr mean
subplot(2,2,1);
hold on;
bar(max_geomtr);
a = 0:.001:5;
b = voxelsize;
plot(a,b,'r');
xlabel('Runnummer')
title('Geometrical mean');
hold off;

% translatie 1
subplot(2,2,2);
hold on;
bar(max_v1);
a = 0:.001:5;
b = voxelsize;
plot(a,b,'r');
xlabel('Runnummer')
title('Maximum verschil translatie 1');
hold off;

% translatie 2
subplot(2,2,3);
hold on;
bar(max_v2);
a = 0:.001:5;
b = voxelsize;
plot(a,b,'r');
xlabel('Runnummer')
title('Maximum verschil translatie 2');
hold off;

% translatie 3
subplot(2,2,4);
hold on;
bar(max_v3);
a = 0:.001:5;
b = voxelsize;
plot(a,b,'r');
xlabel('Runnummer')
title('Maximum verschil translatie 3');
hold off;

