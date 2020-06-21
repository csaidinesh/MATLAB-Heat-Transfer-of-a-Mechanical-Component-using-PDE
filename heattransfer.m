function varargout = heattransfer(varargin)
% HEATTRANSFER MATLAB code for heattransfer.fig
%      HEATTRANSFER, by itself, creates a new HEATTRANSFER or raises the existing
%      singleton*.
%
%      H = HEATTRANSFER returns the handle to a new HEATTRANSFER or the handle to
%      the existing singleton*.
%
%      HEATTRANSFER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HEATTRANSFER.M with the given input arguments.
%
%      HEATTRANSFER('Property','Value',...) creates a new HEATTRANSFER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before heattransfer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to heattransfer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help heattransfer

% Last Modified by GUIDE v2.5 20-Jun-2020 23:32:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @heattransfer_OpeningFcn, ...
                   'gui_OutputFcn',  @heattransfer_OutputFcn, ...
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


% --- Executes just before heattransfer is made visible.
function heattransfer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to heattransfer (see VARARGIN)

% Choose default command line output for heattransfer
handles.output = hObject;
handles.shape = 1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes heattransfer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = heattransfer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in generate.
function generate_Callback(hObject, eventdata, handles)
% hObject    handle to generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% creating pde
model = createpde('thermal','steadystate');
radius = handles.radius;
height = handles.height;
width = handles.width;
% for void matrix
if length(radius) == 1
    void = false;
else
for i = 1 : length(radius)
    if(i == 1)
        void(i) = true;
    else
        void(i) = false;
    end
end
end
% for making geometry
if(handles.shape == 1)
    gm = multicylinder(radius,height,'void',void);
end
if(handles.shape == 2)
    gm = multicuboid(radius,height,width,'void',void);
end 
model.Geometry = gm;
% for generating mesh 
generateMesh(model);
% thermal properties
cellnum = handles.cellnum;
thermalprop = handles.thermalprop;
for i = 1 : length(cellnum)
    thermalProperties(model,'Cell',cellnum(i),'ThermalConductivity',thermalprop(i));
end
%boundary conditions
facenum = handles.facenum;
temp = handles.temp;
for i = 1 : length(cellnum)
    thermalBC(model,'Face',facenum(i),'Temperature',temp(i));
end
%solve
results = solve(model);
handles.model = model;
guidata(hObject,handles);
figure;
subplot(1,3,1); pdegplot(model);
subplot(1,3,2); pdeplot3D(model);
subplot(1,3,3); pdeplot3D(model,'ColorMapData',results.Temperature);

function facenum_Callback(hObject, eventdata, handles)
% hObject    handle to facenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.facenum = str2num(get(hObject,'string'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of facenum as text
%        str2double(get(hObject,'String')) returns contents of facenum as a double


% --- Executes during object creation, after setting all properties.
function facenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to facenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function temperature_Callback(hObject, eventdata, handles)
% hObject    handle to temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.temp = str2num(get(hObject,'string'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of temperature as text
%        str2double(get(hObject,'String')) returns contents of temperature as a double


% --- Executes during object creation, after setting all properties.
function temperature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cellnum_Callback(hObject, eventdata, handles)
% hObject    handle to cellnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cellnum = str2num(get(hObject,'string'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of cellnum as text
%        str2double(get(hObject,'String')) returns contents of cellnum as a double


% --- Executes during object creation, after setting all properties.
function cellnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thermalprop_Callback(hObject, eventdata, handles)
% hObject    handle to thermalprop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.thermalprop = str2num(get(hObject,'string'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of thermalprop as text
%        str2double(get(hObject,'String')) returns contents of thermalprop as a double


% --- Executes during object creation, after setting all properties.
function thermalprop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thermalprop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.radius = str2num(get(hObject,'string'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in shape.
function shape_Callback(hObject, eventdata, handles)
% hObject    handle to shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.shape = get(hObject,'value');
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns shape contents as cell array
%        contents{get(hObject,'Value')} returns selected item from shape


% --- Executes during object creation, after setting all properties.
function shape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.height = str2num(get(hObject,'string'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.width = str2num(get(hObject,'string'));
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
