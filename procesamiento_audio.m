%Filtra una señal de audio usando la transformada ràpida de fourier

%   function [fs,t,a_m,A_m,f,filtro,A_lpf,a_lpf]=procesamiento_audio(name_audio,coef_ruido,tipo_filtro,fc)
%
%   Entradas:
%               name_audio   nombre del audio
%               coef_ruido   coeficiente de ruido (numero del 0 al 1 que
%                            representa la cantidad de ruido introducida en la señal)
%               tipo_filtro  tipo de filtro que se quiere aplicar en la
%                            señal: pasa bajo, pasa alto, pasa banda
%                            filtro pasa bajo = 1
%                            filtro pasa banda = 2
%                            filtro pasa alto = 3
%               fc           frecuencia de corte del filtro, ejemplo:
%                            frecuencia de corte pasabanda = [300,500]
%                            frecuencia de corte pasabajo = 300
%                            frecuencia de corte pasabajo = 300
%   Salidas:
%               fs           frecuencia de muestreo
%               t            Vector de tiempo de la señal de audio
%               a_m          Señal con ruido
%               A_m          Transformada rapida de fourier de la señal de
%                            sonido centrada en 0 
%               f            vector de frecuencias de A_m
%               filtro       Valores del filtro a aplicar en la señal de
%                            audio
%               A_lpf        Valores de la señal filtrada dominio de la frecuencia
%               a_lpf        Valores de la señal filtrada en el dominio del
%                            tiempo


function [fs,t,a_m,A_m,f,filtro,A_lpf,a_lpf]=procesamiento_audio(name_audio,coef_ruido,tipo_filtro,fc)

[a,fs]=audioread(name_audio+".wav");
info = audioinfo(name_audio+".wav");


%% canales de audio
a_m = a(:,1); % canal izquierdo

ruido = (rand(1,length(a_m))*coef_ruido)';
a_m = a_m + ruido;

%% Características del audio
d=info.Duration;
Fs =info.SampleRate;  % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length(a);        % Length of signal
t = (0:L-1)*T;        % Time vector
a_m=a_m.';

%% Trasformada rápida de fourier Dominio Frecuencia
A_m =fftshift( fft(a_m));
f = linspace(-fs/2,fs/2,length(A_m));

%% Filtro
    switch tipo_filtro
        case 1
            disp('pasabajo')
            filtro=1.*((abs(f)<=fc)&((abs(f)>=0)));
        case 2
            disp('pasabanda')
            fc2=max(fc);
            fc1=min(fc);
            filtro=1.*((abs(f)<=fc2)&((abs(f)>=fc1)));
        case 3
            disp('pasoalto')
            filtro=1.*((abs(f)>=fc));
        otherwise
            disp('pasabajo')
            filtro=1.*((abs(f)<=300)&((abs(f)>=0)));
    end 


%% Señal filtrada dominio de la frecuencia
A_lpf=A_m.*filtro;


%% Regresar al dominio de la frecuencia
a_lpf = real(ifft(fftshift(A_lpf)));

end