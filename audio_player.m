function varargout = audio_player(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @audio_player_OpeningFcn, ...
                   'gui_OutputFcn',  @audio_player_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before audio_player is made visible.
function audio_player_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to audio_player (see VARARGIN)

% Choose default command line output for audio_player
handles.output = hObject;
axes(handles.axes10);
imshow('siglaUPB.bmp')

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = audio_player_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


 % --- Executes on upload clean button press.
 function upload_Callback(hObject, eventdata, handles)
 % hObject    handle to upload (see GCBO)
 % eventdata  reserved - to be defined in a future version of MATLAB
 % handles    structure with handles and user data (see GUIDATA)
 [filename, pathname] = uigetfile({'*.wav'}, 'Select File');
     if(filename ~=0)
         cd(pathname)
         [y,fs] = audioread(filename);
         handles.pauza = 0;
         handles.stop = 0;
         handles.redare = 0;
     end    
 n = size(y,2);
 aux = get(handles.channelpnl, 'SelectedObject');
 auxstring = get(aux, 'String');
 if(n == 2)
    switch auxstring
      case 'Left Channel'
        handles.sunet = audioplayer(y(:,1),fs);
      case 'Stereo'
        handles.sunet = audioplayer(y,fs);
      case 'Right Channel'
        handles.sunet = audioplayer(y(:,2),fs);
    end
 end
 
 if(n == 1)    
     if(strcmp(auxstring,'Stereo'))
         msgbox('Fisierul nu este stereo!');
         set(handles.channelpnl,'SelectedObject',handles.leftchannel);
     elseif(strcmp(auxstring,'Left Channel')||strcmp(auxstring,'Right Channel'))
         handles.sunet = audioplayer(y(:,1),fs);      
     end
 end
 
 handles.fisier = y;
 handles.frecventa = fs;
 
 guidata(hObject,handles);

 % --- Executes on upload noisy button press.
function uploadnoisy_Callback(hObject, eventdata, handles)
% hObject    handle to uploadnoisy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  [filename, pathname] = uigetfile({'*.wav'}, 'Select File');
     if(filename ~=0)
         cd(pathname)
         [y,fs] = audioread(filename);
         handles.pauza = 0;
%        handles.stop = 0;
         handles.redare = 0;
     end    
 n = size(y,2);
 aux = get(handles.channelpnl, 'SelectedObject');
 auxstring = get(aux, 'String');
 if(n == 2)
    switch auxstring
      case 'Left Channel'
        handles.sunet1 = audioplayer(y(:,1),fs); 
      case 'Stereo'
        handles.sunet1 = audioplayer(y,fs); 
      case 'Right Channel'
        handles.sunet1 = audioplayer(y(:,2),fs); 
    end 
 end
 
 if(n == 1)   
     if(strcmp(auxstring,'Stereo'))
         msgbox('Fisierul nu e stereo!');
         set(handles.channelpnl,'SelectedObject',handles.leftchannel);
     elseif(strcmp(auxstring,'Left Channel')||strcmp(auxstring,'Right Channel'))
         handles.sunet1 = audioplayer(y(:,1),fs);     
     end
 end
 
 handles.fisier1 = y; 
 handles.frecventa1 = fs; 
 guidata(hObject,handles);
 
 
% --- Executes on slider movement.
function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.volum = get(hObject,'Value');

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on play button press.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  aux = get(handles.wavpnl, 'SelectedObject');
  v = aux; 
  v1 = aux;  
 switch get(aux, 'String') 
      case 'First File Uploaded' 
       v = handles.fisier;
       v1 = handles.sunet;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
end 
if (v == -1)
     errordlg('Incarcati sunetul!');
end         

if (handles.pauza == 1)
     handles.redare = 1;
end

if (handles.redare == 0)
    play(v1);   
    handles.redare = 1;
end

if ((handles.redare == 1) && (handles.pauza == 1))
    resume(v1); 
end

if handles.stop
     play(v1);
end

guidata(hObject,handles);

% --- Executes on pause button press.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux = get(handles.wavpnl, 'SelectedObject'); 
  v = '';
  v1 = '';
 switch get(aux, 'String')
      case 'First File Uploaded'
       v = handles.fisier;
       v1 = handles.sunet;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
 end  
if(v == -1)   
          errordlg('Incarcati sunetul!');
else  
          if (isplaying(v1))
              pause(v1); 
              handles.pauza = 1;
          end
end

guidata(hObject,handles);


% --- Executes on stop button press.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux = get(handles.wavpnl, 'SelectedObject'); 
  v = '';
  v1 = '';
 switch get(aux, 'String')
      case 'First File Uploaded'
       v = handles.fisier;
       v1 = handles.sunet;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
 end  
if(v == -1) 
          errordlg('Incarcati sunetul!');
      else 
          if(isplaying(v1)) 
              stop(v1) 
              handles.stop = 1;
          else
              errordlg('Deja oprit!');
          end
 end
guidata(hObject,handles);


% --- Executes on plotfft button press.
function plotfft_Callback(hObject, eventdata, handles)
% hObject    handle to plotfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux = get(handles.wavpnl, 'SelectedObject'); 
  v = '';
  v1 = '';
  v2 = '';
 switch get(aux, 'String')
      case 'First File Uploaded'
       v = handles.fisier;
       v1 = handles.sunet;
       v2 = handles.frecventa;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
       v2 = handles.frecventa1;
 end  
 aux = get(handles.channelpnl, 'SelectedObject');
 auxstring = get(aux, 'String'); 
 y = v; 
 fs = v2;
 n = size(y,2);
 if(n == 2)
    switch auxstring
        case 'Left Channel'
          x = y(:,1);
          axes(handles.axes7);
          n = length(x)-1;
          wavfft = abs(fft(x));
          f = 0:fs/n:fs;
          plot(f,wavfft);
          title('FFT');
          ylabel('Magnitudine');
          xlabel('Frecventa');
          grid('on');
        case 'Stereo'
          x = y;
          axes(handles.axes8);
          n = length(x)-1;
          wavfft = abs(fft(x));
          f = 0:fs/n:fs;
          plot(f,wavfft);
          title('FFT');
          ylabel('Magnitudine');
          xlabel('Frecventa');
          grid('on');
        case 'Right Channel'  
          x = y(:,2);
          axes(handles.axes9);
          n = length(x)-1;
          wavfft = abs(fft(x));
          f = 0:fs/n:fs;
          plot(f,wavfft);
          title('FFT');
          ylabel('Magnitudine');
          xlabel('Frecventa');
          grid('on');
    end
 elseif(n == 1)
     if(strcmp(auxstring,'Stereo'))
         msgbox('Fisierul nu e stereo!');
         set(handles.channelpnl,'SelectedObject',handles.leftchannel);
     elseif(strcmp(auxstring,'Left Channel')||strcmp(auxstring,'Right Channel'))
         axes(handles.axes7);
         x = y;
         n = length(x)-1;
         wavfft = abs(fft(x));
         f = 0:fs/n:fs;
         plot(f,wavfft);
         title('FFT');
         ylabel('Magnitudine');
         xlabel('Frecventa');
         grid('on');
     end
 end
  
 guidata(hObject,handles);


% --- Executes on button press in plottimedomain.
function plottimedomain_Callback(hObject, eventdata, handles)
% hObject    handle to plottimedomain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 aux = get(handles.wavpnl, 'SelectedObject'); 
  v = '';
  v1 = '';
  v2 = '';
 switch get(aux, 'String')
      case 'First File Uploaded'
       v = handles.fisier;
       v1 = handles.sunet;
       v2 = handles.frecventa;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
       v2 = handles.frecventa1;
 end 
 aux = get(handles.channelpnl, 'SelectedObject');
 auxstring = get(aux, 'String'); 
 y = v;
 fs = v2;
 n = size(y,2);
 if(n == 2)
 switch auxstring
     case 'Left Channel'
       x = y(:,1);
       axes(handles.axes7);
       n = length(x);
       t = (0:n-1)/fs;
       plot(t,x); 
       title('Time domain plot');
       xlabel('Seconds'); 
       ylabel('Amplitude');
       grid('on');
     case 'Stereo'
       x = y;
       axes(handles.axes8);
       n = length(x);
       t = (0:n-1)/fs;
       plot(t,x); 
       title('Time domain plot');
       xlabel('Seconds'); 
       ylabel('Amplitude');
       grid('on');
     case 'Right Channel'
       x = y(:,2);
       axes(handles.axes9);
       n = length(x);
       t = (0:n-1)/fs;
       plot(t,x); 
       title('Time domain plot');
       xlabel('Seconds'); 
       ylabel('Amplitude');
       grid('on');
 end
 elseif(n == 1)
     if(strcmp(auxstring,'Stereo'))
         msgbox('Fisierul nu e stereo!');
         set(handles.channelpnl,'SelectedObject',handles.leftchannel);
     elseif(strcmp(auxstring,'Left Channel')||strcmp(auxstring,'Right Channel'))
         axes(handles.axes7);
         x = y;
         n = length(x);
         t = (0:n-1)/fs;
         plot(t,x); 
         title('Time domain plot');
         xlabel('Seconds'); 
         ylabel('Amplitude');
         grid('on');
     end
 end
 
 guidata(hObject,handles);


% --- Executes on button press in closeGUI.
function closeGUI_Callback(hObject, eventdata, handles)
% hObject    handle to closeGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = questdlg('Close App?', ...
	'Closing...', ...
	'Yes', 'No');
% Handle response
switch answer
    case 'Yes'
        disp([answer '...Closing']);
        close all; 
    case 'No'
        close;

end



% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 aux = get(handles.channelpnl, 'SelectedObject');
 
 switch get(aux, 'String')
      case 'Left Channel'
        handles.sunet = audioplayer(y(:,1),fs);
        handles.sunet1 = audioplayer(y(:,1),fs); 
      case 'Stereo'
        handles.sunet = audioplayer(y,fs);
        handles.sunet1 = audioplayer(y,fs); 
      case 'Right Channel'
        handles.sunet = audioplayer(y(:,2),fs);
        handles.sunet1 = audioplayer(y(:,2),fs); 
  end




% --- Executes on button press in plotpowfrq.
function plotpowfrq_Callback(hObject, eventdata, handles)
% hObject    handle to plotpowfrq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux = get(handles.wavpnl, 'SelectedObject'); 
  v = '';
  v1 = '';
  v2 = '';
 switch get(aux, 'String')
      case 'First File Uploaded'
       v = handles.fisier;
       v1 = handles.sunet;
       v2 = handles.frecventa;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
       v2 = handles.frecventa1;
 end  
 aux = get(handles.channelpnl, 'SelectedObject');
 auxstring = get(aux, 'String'); 
 y = v;
 fs = v2;
 n = size(y,2);
 if(n == 2)
 switch auxstring
     case 'Left Channel'
       x = y(:,1);
       axes(handles.axes7);
       n = length(x);
       xdft = fft(x);
       xdft = xdft(1:n/2+1);
       psdx = (1/(fs*n)) * abs(xdft).^2;
       psdx(2:end-1) = 2*psdx(2:end-1);
       freq = 0:fs/length(x):fs/2;
       plot(freq,10*log10(psdx))
       grid on
       title('Periodogram Using FFT')
       xlabel('Frequency (Hz)')
       ylabel('Power/Frequency (dB/Hz)')
     case 'Stereo'
       x = y;
       axes(handles.axes8);
       n = length(x);
       xdft = fft(x);
       xdft = xdft(1:n/2+1);
       psdx = (1/(fs*n)) * abs(xdft).^2;
       psdx(2:end-1) = 2*psdx(2:end-1);
       freq = 0:fs/length(x):fs/2;
       plot(freq,10*log10(psdx))
       grid on
       title('Periodogram Using FFT')
       xlabel('Frequency (Hz)')
       ylabel('Power/Frequency (dB/Hz)')
     case 'Right Channel'
       x = y(:,2);
       axes(handles.axes9);
       n = length(x);
       xdft = fft(x);
       xdft = xdft(1:n/2+1);
       psdx = (1/(fs*n)) * abs(xdft).^2;
       psdx(2:end-1) = 2*psdx(2:end-1);
       freq = 0:fs/length(x):fs/2;
       plot(freq,10*log10(psdx))
       grid on
       title('Periodogram Using FFT')
       xlabel('Frequency (Hz)')
       ylabel('Power/Frequency (dB/Hz)')
 end
 elseif(n == 1)
     if(strcmp(auxstring,'Stereo'))
         msgbox('Fisierul nu e stereo!');
         set(handles.channelpnl,'SelectedObject',handles.leftchannel);
     elseif(strcmp(auxstring,'Left Channel')||strcmp(auxstring,'Right Channel'))
         axes(handles.axes7);
         x = y;
         n = length(x);
         xdft = fft(x);
         xdft = xdft(1:n/2+1);
         psdx = (1/(fs*n)) * abs(xdft).^2;
         psdx(2:end-1) = 2*psdx(2:end-1);
         freq = 0:fs/length(x):fs/2;
         plot(freq,10*log10(psdx))
         grid on
         title('Periodogram Using FFT')
         xlabel('Frequency (Hz)')
         ylabel('Power/Frequency (dB/Hz)')
     end
 end
 
 guidata(hObject,handles);


% --- Executes on button press in plotspectogram.
function plotspectogram_Callback(hObject, eventdata, handles)
% hObject    handle to plotspectogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 aux = get(handles.wavpnl, 'SelectedObject'); 
  v = '';
  v1 = '';
  v2 = '';
 switch get(aux, 'String')
      case 'First File Uploaded'
       v = handles.fisier;
       v1 = handles.sunet;
       v2 = handles.frecventa;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
       v2 = handles.frecventa1;
 end 
 aux = get(handles.channelpnl, 'SelectedObject');
 auxstring = get(aux, 'String'); 
 y = v;
 fs = v2;
 n = size(y,2);
 if(n == 2)
 switch auxstring
     case 'Left Channel'
       x = y(:,1);
       axes(handles.axes7);
       spectrogram(x,'yaxis');
       title('Spectogram');
       xlabel('S'); 
       ylabel('rad/s');
       grid('on');
     case 'Stereo'
       x = y(:,1) + y(:,2);
       axes(handles.axes8);
       spectrogram(x,'yaxis');
       title('Spectogram');
       xlabel('S'); 
       ylabel('rad/s');
       grid('on');
     case 'Right Channel'
       x = y(:,2);
       axes(handles.axes9);
       spectrogram(x,'yaxis');
       title('Spectogram');
       xlabel('S'); 
       ylabel('rad/s');
       grid('on');
 end
 elseif(n == 1)
     if(strcmp(auxstring,'Stereo'))
         msgbox('Fisierul nu e stereo!');
         set(handles.channelpnl,'SelectedObject',handles.leftchannel);
     elseif(strcmp(auxstring,'Left Channel')||strcmp(auxstring,'Right Channel'))
         axes(handles.axes7);
         x = y(:,1) + y(:,2);
         spectrogram(x,'yaxis');
         title('Spectogram');
         xlabel('S'); 
         ylabel('rad/s');
         grid('on');
     end
 end
 
 guidata(hObject,handles);
 
 function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to lowpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux = get(handles.wavpnl, 'SelectedObject');
  v = '';
  v1 = '';
  v2 = '';
  
 switch get(aux, 'String')
      case 'First File Uploaded'
       v = handles.fisier;
       v1 = handles.sunet;
       v2 = handles.frecventa;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
       v2 = handles.frecventa1;
 end
 
 aux = get(handles.channelpnl, 'SelectedObject');
 auxstring = get(aux, 'String'); 
 y = v;
 fs = v2;
 n = size(y,2);
 if(n == 2)
    switch auxstring
        case 'Left Channel'
          x = y(:,1);
          axes(handles.axes7);
          
          Fpass = 200;
          Fstop = 250;
          Rpass = 1;
          Rstop = 10;

          lpFilt = designfilt('lowpassiir', ...
          'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
          'PassbandRipple',Rpass,'StopbandAttenuation',Rstop, ...
          'DesignMethod','butter','SampleRate',fs);

          xFiltrat = filter(lpFilt,x);
          
          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds'); 
          ylabel('Amplitude');
          grid('on');
        case 'Stereo'
          x = y;
          axes(handles.axes8);
          
          Fpass = 200;
          Fstop = 250;
          Rpass = 1;
          Rstop = 10;

          lpFilt = designfilt('lowpassiir', ...
          'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
          'PassbandRipple',Rpass,'StopbandAttenuation',Rstop, ...
          'DesignMethod','butter','SampleRate',fs);

          xFiltrat = filter(lpFilt,x);
          
          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds'); 
          ylabel('Amplitude');
          grid('on');
        case 'Right Channel'  
          x = y(:,2);
          axes(handles.axes9);
          
          Fpass = 200;
          Fstop = 250;
          Rpass = 1;
          Rstop = 10;

          lpFilt = designfilt('lowpassiir', ...
          'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
          'PassbandRipple',Rpass,'StopbandAttenuation',Rstop, ...
          'DesignMethod','butter','SampleRate',fs);

          xFiltrat = filter(lpFilt,x);
          
          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds'); 
          ylabel('Amplitude');
          grid('on');
    end
 elseif(n == 1)
     if(strcmp(auxstring,'Stereo'))
         msgbox('Fisierul nu e stereo!');
         set(handles.channelpnl,'SelectedObject',handles.leftchannel);
     elseif(strcmp(auxstring,'Left Channel')||strcmp(auxstring,'Right Channel'))
         axes(handles.axes7);
         x = y;
                   
          Fpass = 200;
          Fstop = 250;
          Rpass = 1;
          Rstop = 10;

          lpFilt = designfilt('lowpassiir', ...
          'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
          'PassbandRipple',Rpass,'StopbandAttenuation',Rstop, ...
          'DesignMethod','butter','SampleRate',fs);

          xFiltrat = filter(lpFilt,x);
          
          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds'); 
          ylabel('Amplitude');
          grid('on');
     end
 end
 
 handles.xFiltrat=xFiltrat;
 
guidata(hObject,handles);


function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to highpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aux = get(handles.wavpnl, 'SelectedObject');
  v = '';
  v1 = '';
  v2 = '';
 switch get(aux, 'String')
      case 'First File Uploaded'
       v = handles.fisier;
       v1 = handles.sunet;
       v2 = handles.frecventa;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
       v2 = handles.frecventa1;
 end
 
 aux = get(handles.channelpnl, 'SelectedObject');
 auxstring = get(aux, 'String'); 
 y = v; 
 fs = v2;
 n = size(y,2);
 if(n == 2)
    switch auxstring
        case 'Left Channel'
          x = y(:,1);
          axes(handles.axes7);
          
          Fpass = 9000;
          Fstop = 8000;
          Rpass = 1;
          Astop = 30;

          hpFilt = designfilt('highpassiir', 'StopbandFrequency',Fstop, ...
                    'PassbandFrequency', Fpass, 'StopbandAttenuation', ...
                     Astop, 'PassbandRipple', Rpass, 'SampleRate', fs, ...
                    'DesignMethod', 'butter');
                
          xFiltrat = filter(hpFilt,x);
          
          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds');
          ylabel('Amplitude');
          grid('on');
        case 'Stereo'
          x = y;
          axes(handles.axes8);
          
          Fpass = 9000;
          Fstop = 8000;
          Rpass = 1;
          Astop = 30;

          hpFilt = designfilt('highpassiir', 'StopbandFrequency',Fstop, ...
                    'PassbandFrequency', Fpass, 'StopbandAttenuation', ...
                     Astop, 'PassbandRipple', Rpass, 'SampleRate', fs, ...
                    'DesignMethod', 'butter');
                
          xFiltrat = filter(hpFilt,x);
          
          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds');
          ylabel('Amplitude');
          grid('on');
        case 'Right Channel'  
          x = y(:,2);
          axes(handles.axes9);
          
          Fpass = 9000;
          Fstop = 8000;
          Rpass = 1;
          Astop = 30;

          hpFilt = designfilt('highpassiir', 'StopbandFrequency',Fstop, ...
                    'PassbandFrequency', Fpass, 'StopbandAttenuation', ...
                     Astop, 'PassbandRipple', Rpass, 'SampleRate', fs, ...
                    'DesignMethod', 'butter');
                
          xFiltrat = filter(hpFilt,x);
          
          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds');
          ylabel('Amplitude');
          grid('on');
    end
 elseif(n == 1)
     if(strcmp(auxstring,'Stereo'))
         msgbox('Fisierul nu e stereo!');
         set(handles.channelpnl,'SelectedObject',handles.leftchannel);
     elseif(strcmp(auxstring,'Left Channel')||strcmp(auxstring,'Right Channel'))
         axes(handles.axes7);
         x = y;
          Fpass = 9000;
          Fstop = 8000;
          Rpass = 1;
          Astop = 30;

          hpFilt = designfilt('highpassiir', 'StopbandFrequency',Fstop, ...
                    'PassbandFrequency', Fpass, 'StopbandAttenuation', ...
                     Astop, 'PassbandRipple', Rpass, 'SampleRate', fs, ...
                    'DesignMethod', 'butter');
                
          xFiltrat = filter(hpFilt,x);
          
          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds');
          ylabel('Amplitude');
          grid('on');
     end
 end
 
 handles.xFiltrat=xFiltrat;
 
guidata(hObject,handles);


function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to bandpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux = get(handles.wavpnl, 'SelectedObject'); 
  v = '';
  v1 = '';
  v2 = '';
  
 switch get(aux, 'String')
      case 'First File Uploaded'
       v = handles.fisier;
       v1 = handles.sunet;
       v2 = handles.frecventa;
      case 'Second File Uploaded'
       v = handles.fisier1;
       v1 = handles.sunet1;
       v2 = handles.frecventa1;
 end
 
 aux = get(handles.channelpnl, 'SelectedObject');
 auxstring = get(aux, 'String'); 
 y = v; 
 fs = v2;
 n = size(y,2);
 
 if(n==2)
    switch auxstring
        case 'Left Channel'
          x = y(:,1);
          axes(handles.axes7);
          
          Fpass1 = 1000;
          Fpass2 = 4000;
          Rpass = 1;
          bpFilt = designfilt('bandpassiir', 'FilterOrder', 20, ...
                    'PassbandFrequency1', Fpass1, 'PassbandFrequency2', ...
                    Fpass2, 'PassbandRipple', Rpass, 'SampleRate', fs);
          
          xFiltrat = filter(bpFilt,x);
          
          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds'); 
          ylabel('Amplitude');
          grid('on');
        case 'Stereo'
          x = y;
          axes(handles.axes8);
          
          Fpass1 = 1000;
          Fpass2 = 4000;
          Rpass = 1;
          
          bpFilt = designfilt('bandpassiir', 'FilterOrder', 20, ...
                    'PassbandFrequency1', Fpass1, 'PassbandFrequency2', ...
                    Fpass2, 'PassbandRipple', Rpass, 'SampleRate', fs);
                
          xFiltrat = filter(bpFilt,x);      

          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds'); 
          ylabel('Amplitude');
          grid('on');
        case 'Right Channel'  
          x = y(:,2);
          axes(handles.axes9);
          
          Fpass1 = 1000;
          Fpass2 = 4000;
          Rpass = 1;
          
          bpFilt = designfilt('bandpassiir', 'FilterOrder', 20, ...
                    'PassbandFrequency1', Fpass1, 'PassbandFrequency2', ...
                    Fpass2, 'PassbandRipple', Rpass, 'SampleRate', fs);
                
          xFiltrat = filter(bpFilt,x);      

          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds'); 
          ylabel('Amplitude');
          grid('on');
    end
 elseif(n == 1)
     if(strcmp(auxstring,'Stereo'))
         msgbox('Fisierul nu e stereo!');
         set(handles.channelpnl,'SelectedObject',handles.leftchannel);
     elseif(strcmp(auxstring,'Left Channel')||strcmp(auxstring,'Right Channel'))
         axes(handles.axes7);
         x = y;

          Fpass1 = 1000;
          Fpass2 = 4000;
          Rpass = 1;
          
          bpFilt = designfilt('bandpassiir', 'FilterOrder', 20, ...
                    'PassbandFrequency1', Fpass1, 'PassbandFrequency2', ...
                    Fpass2, 'PassbandRipple', Rpass, 'SampleRate', fs);
                
          xFiltrat = filter(bpFilt,x);      

          n = length(xFiltrat);
          t = (0:n-1)/fs;
          plot(t,xFiltrat);
          title('Filtered WAV');
          xlabel('Seconds'); 
          ylabel('Amplitude');
          grid('on');
     end
 end

 handles.xFiltrat=xFiltrat;
 
  guidata(hObject,handles);

