function varargout = inputdata(varargin)
%INPUTDATA MATLAB code file for inputdata.fig
%      INPUTDATA, by itself, creates a new INPUTDATA or raises the existing
%      singleton*.
%
%      H = INPUTDATA returns the handle to a new INPUTDATA or the handle to
%      the existing singleton*.
%
%      INPUTDATA('Property','Value',...) creates a new INPUTDATA using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to inputdata_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      INPUTDATA('CALLBACK') and INPUTDATA('CALLBACK',hObject,...) call the
%      local function named CALLBACK in INPUTDATA.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help inputdata

% Last Modified by GUIDE v2.5 28-May-2024 10:05:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @inputdata_OpeningFcn, ...
                   'gui_OutputFcn',  @inputdata_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before inputdata is made visible.
function inputdata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for inputdata
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes inputdata wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = inputdata_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in showdata.
function showdata_Callback(hObject, eventdata, handles)
% hObject    handle to showdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts = detectImportOptions('Data198_195.csv');
opts.SelectedVariableNames = (1:13);
data = readtable('Data198_195.csv', opts);
data = table2cell(data);
data = data(:, 1:13);
set(handles.tabeldata, 'Data', data);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.bUmur, 'string', '');
set(handles.bDurasi, 'string', '');
set(handles.bKualitas, 'string', '');
set(handles.bAktivitas, 'string', '');
set(handles.bStress, 'string', '');
set(handles.tabelHasil, 'Data', {});
set(handles.Hasil, 'string', '');

% --- Executes on button press in proses.
function proses_Callback(hObject, eventdata, handles)
% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts = detectImportOptions('Data198_195.csv');
opts.SelectedVariableNames = (1:13);

tabel = readtable('Data198_195.csv');
tabel = tabel(:, [1,3,5:8]);

%Input atribut kriteria
switch get(get(handles.aUmur,'SelectedObject'),'Tag')
    case 'umur0'
        k1 = 0;
    case 'umur1'
        k1 = 1;
end

switch get(get(handles.aDurasi,'SelectedObject'),'Tag')
    case 'durasi0'
        k2 = 0;
    case 'durasi1'
        k2 = 1;
end

switch get(get(handles.aKualitas,'SelectedObject'),'Tag')
    case 'kualitas0'
        k3 = 0;
    case 'kualitas1'
        k3 = 1;
end

switch get(get(handles.aAktivitas,'SelectedObject'),'Tag')
    case 'aktivitas0'
        k4 = 0;
    case 'aktivitas1'
        k4 = 1;
end

switch get(get(handles.aStress,'SelectedObject'),'Tag')
    case 'stress0'
        k5 = 0;
    case 'stress1'
        k5 = 1;
end


k = [k1 k2 k3 k4 k5];

%Input bobot
b1 = str2double(get(handles.bUmur, 'string'));
b2 = str2double(get(handles.bDurasi, 'string'));
b3 = str2double(get(handles.bKualitas, 'string'));
b4 = str2double(get(handles.bAktivitas, 'string'));
b5 = str2double(get(handles.bStress, 'string'));

%Tahap normalisasi bobot
total = b1 + b2 + b3 + b4 + b5;

    b1 = b1/total;
    b2 = b2/total;
    b3 = b3/total;
    b4 = b4/total;
    b5 = b5/total;

w = [b1 b2 b3 b4 b5];

data = get(handles.tabeldata, 'Data');
data = data(:, [3,5:8]);
data = cell2mat(data);

%Tahap normalisasi data
[m, n] = size(data);

R = zeros(m,n);
for j=1:n
    if k(j)==1
	R(:,j)=data(:,j)./max(data(:,j));
    else
	R(:,j)=min(data(:,j))./data(:,j);
    end
end

V = zeros(1, m);
for i=1:m
    V(i) = sum(w.*R(i,:));
end

%Menampilkan perankingingan
V = V.';
tabel.('Score') = V;
sorted = sortrows(tabel, 7, 'descend');
rank = table2cell(sorted);

set(handles.tabelHasil,'Data', rank, 'ColumnName', {'ID Orang', 'Umur', 'Durasi Tidur', 'Kualitas Tidur', 'Aktivitas Fisik', 'Tingkat Stress', 'Score'});

ID_Orang = rank{1,1};
Umur = rank{1,2};
Durasi_Tidur = rank{1,3};
Kualitas_Tidur  = rank{1,4};
Aktivitas_Fisik = rank{1,5};
Tingkat_Stress = rank{1,6};
Score = rank{1,7};

resultID = string(ID_Orang);
resultScr = string(Score);
resultUmr = string(Umur);
resultDrs = string(Durasi_Tidur);
resultKlt = string(Kualitas_Tidur);
resultAkt = string(Aktivitas_Fisik);
resultTng = string(Tingkat_Stress);

resultTextID = sprintf('ID Person terbaik : %s', resultID);
resultTextUmr = sprintf('Umur : %s', resultUmr);
resultTextDrs = sprintf('Durasi Tidur : %s', resultDrs);
resultTextKlt = sprintf('Kualitas Tidur : %s', resultKlt);
resultTextAkt = sprintf('Aktivitas Fisik : %s', resultAkt);
resultTextTng = sprintf('Tingkat Stress : %s', resultTng);
resultTextScr = sprintf('Score : %s', resultScr);

hasilSeluruh = sprintf('%s\n%s\n%s\n%s\n%s\n%s\n\n%s', resultTextID, resultTextUmr, resultTextDrs, resultTextKlt, resultTextAkt, resultTextTng, resultTextScr);

set(handles.Hasil, 'string', hasilSeluruh);



% --- Executes when selected cell(s) is changed in tabelHasil.
function tabelHasil_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tabelHasil (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in kembali.
function kembali_Callback(hObject, eventdata, handles)
% hObject    handle to kembali (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(start);


function Hasil_Callback(hObject, eventdata, handles)
% hObject    handle to Hasil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Hasil as text
%        str2double(get(hObject,'String')) returns contents of Hasil as a double


% --- Executes during object creation, after setting all properties.
function Hasil_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Hasil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bUmur_Callback(hObject, eventdata, handles)
% hObject    handle to bUmur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bUmur as text
%        str2double(get(hObject,'String')) returns contents of bUmur as a double


% --- Executes during object creation, after setting all properties.
function bUmur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bUmur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bDurasi_Callback(hObject, eventdata, handles)
% hObject    handle to bDurasi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bDurasi as text
%        str2double(get(hObject,'String')) returns contents of bDurasi as a double


% --- Executes during object creation, after setting all properties.
function bDurasi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bDurasi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bStress_Callback(hObject, eventdata, handles)
% hObject    handle to bStress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bStress as text
%        str2double(get(hObject,'String')) returns contents of bStress as a double


% --- Executes during object creation, after setting all properties.
function bStress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bStress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bAktivitas_Callback(hObject, eventdata, handles)
% hObject    handle to bAktivitas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bAktivitas as text
%        str2double(get(hObject,'String')) returns contents of bAktivitas as a double


% --- Executes during object creation, after setting all properties.
function bAktivitas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bAktivitas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bKualitas_Callback(hObject, eventdata, handles)
% hObject    handle to bKualitas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bKualitas as text
%        str2double(get(hObject,'String')) returns contents of bKualitas as a double


% --- Executes during object creation, after setting all properties.
function bKualitas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bKualitas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
