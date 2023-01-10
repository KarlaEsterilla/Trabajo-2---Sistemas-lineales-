

clc
clear all
close all

[fs,t,a_m,A_m,f,filtro,A_lpf,a_lpf] = procesamiento_audio("podcast_audio2",0.2,2,[200,1700]);

figure
plot(t,a_m);
title('sonido original en el tiempo');
xlabel('time');




figure
plot(f,abs(A_m)/max(abs(A_m)));
legend('Audio');
title('sonido original en frecuencia');
xlabel('hz');


hold on
plot(f,filtro,'r');

legend('filtro');


figure
plot(f,abs(A_lpf)/max(abs(A_lpf)));
title('Audio filtrado dominio frecuencia');

figure
plot(t,a_lpf)

sound(a_lpf*2,fs);

%audiowrite('señal filtrada.wav',a_m,fs);