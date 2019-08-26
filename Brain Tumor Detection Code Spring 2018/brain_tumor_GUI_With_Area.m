function varargout = brain_tumor_GUI_With_Area(varargin)
% BRAIN_TUMOR_GUI_WITH_AREA MATLAB code for brain_tumor_GUI_With_Area.fig
%      BRAIN_TUMOR_GUI_WITH_AREA, by itself, creates a new BRAIN_TUMOR_GUI_WITH_AREA or raises the existing
%      singleton*.
%
%      H = BRAIN_TUMOR_GUI_WITH_AREA returns the handle to a new BRAIN_TUMOR_GUI_WITH_AREA or the handle to
%      the existing singleton*.
%
%      BRAIN_TUMOR_GUI_WITH_AREA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRAIN_TUMOR_GUI_WITH_AREA.M with the given input arguments.
%
%      BRAIN_TUMOR_GUI_WITH_AREA('Property','Value',...) creates a new BRAIN_TUMOR_GUI_WITH_AREA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before brain_tumor_GUI_With_Area_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to brain_tumor_GUI_With_Area_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brain_tumor_GUI_With_Area

% Last Modified by GUIDE v2.5 23-Apr-2018 19:27:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @brain_tumor_GUI_With_Area_OpeningFcn, ...
                   'gui_OutputFcn',  @brain_tumor_GUI_With_Area_OutputFcn, ...
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


% --- Executes just before brain_tumor_GUI_With_Area is made visible.
function brain_tumor_GUI_With_Area_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to brain_tumor_GUI_With_Area (see VARARGIN)

% Choose default command line output for brain_tumor_GUI_With_Area
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes brain_tumor_GUI_With_Area wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = brain_tumor_GUI_With_Area_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
[path, user_cancel]=imgetfile();
if user_cancel
    msgbox(sprintf('Sorry Sir, Invalid Slection'));
    return
end
im=imread(path);
im=im2double(im);
axes(handles.axes1);
imshow(im)
title('Patient Brain')


% --- Executes on button press in tumor_detected.
function tumor_detected_Callback(hObject, eventdata, handles)
% hObject    handle to tumor_detected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
axes(handles.axes2);
bw=im2bw(im,0.6);
label=bwlabel(bw);

stats=regionprops(label,'Solidity','Area');

density=[stats.Solidity];
area=[stats.Area];


highDenseArea=density > 0.55;
maxArea=max(area(highDenseArea));
tumor_label=find(area==maxArea);
tumor=ismember(label,tumor_label);
 

se=strel('square',5);
tumor=imdilate(tumor,se);
imshow(tumor)
title('Only Tumor')
% 
% stats2=regionprops(tumor,'Area','Perimeter');
% Area2=stats2.Area;



% [B,L]=bwboundaries(tumor,'noholes');
% imshow(im)
% hold on
% for i=length(B)
%     plot(B{i}(:,2),B{i}(:,1),'r','linewidth',2)
% end
title('Segmented Brain Tumor')
 


% --- Executes during object creation, after setting all properties.
function tumor_with_brain_Callback(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global im
axes(handles.axes5);
bw=im2bw(im,0.7);
label=bwlabel(bw);

stats=regionprops(label,'Solidity','Area');

density=[stats.Solidity];
area=[stats.Area];


highDenseArea=density > 0.55;
maxArea=max(area(highDenseArea));
tumor_label=find(area==maxArea);
tumor=ismember(label,tumor_label);
 

se=strel('square',5);
tumor=imdilate(tumor,se);
imshow(tumor)
% 
% stats2=regionprops(tumor,'Area','Perimeter');
% Area2=stats2.Area;

[B,L]=bwboundaries(tumor,'noholes');
imshow(im)
hold on
for i=length(B)
    plot(B{i}(:,2),B{i}(:,1),'r','linewidth',2)
end
title('Tumor Detected')
% Hint: place code in OpeningFcn to populate axes5


 


% --- Executes during object creation, after setting all properties.
function Area_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Characteristics.
function Characteristics_Callback(hObject, eventdata, handles)
% hObject    handle to Characteristics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
bw=im2bw(im,0.7);
label=bwlabel(bw);

stats=regionprops(label,'Solidity','Area');

density=[stats.Solidity];
area=[stats.Area];
highDenseArea=density > 0.55;
maxArea=max(area(highDenseArea));
tumor_label=find(area==maxArea);
tumor=ismember(label,tumor_label);

se=strel('square',5);
tumor=imdilate(tumor,se);
charc=regionprops(tumor,'Area','Perimeter','Eccentricity');
Area=charc.Area;
str1=sprintf('Area=%.3f',Area);
set(handles.Area,'String',str1);
Perimeter=charc.Perimeter;
str2=sprintf('Perimeter=%.3f',Perimeter);
set(handles.Perimeter,'String',str2);
if ~(density > 0.5)
    str3=sprintf('No tumor there');
set(handles.text5,'String',str3);
end
    
    

% --- Executes during object creation, after setting all properties.
function Perimeter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Perimeter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes on button press in characteristics.

% function Characteristics_Callback(hObject, eventdata, handles)
% % hObject    handle to characteristics (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global im
% bw=im2bw(im,0.7);
% label=bwlabel(bw);
% 
% stats=regionprops(label,'Solidity','Area');
% 
% density=[stats.Solidity];
% area=[stats.Area];
% 
% highDenseArea=density > 0.50;
% maxArea=max(area(highDenseArea));
% tumor_label=find(area==maxArea);
% tumor=ismember(label,tumor_label);
% 
% se=strel('square',5);
% tumor=imdilate(tumor,se);
% charc=regionprops(tumor,'Area','Perimeter','Eccentricity');
% Perimeter=charc.Perimeter;
% str2=sprintf('Perimeter=%.3f',Perimeter);
%  set(handles.Perimeter,'String',str2);


% --- Executes during object creation, after setting all properties.
% function Characteristics_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to Characteristics (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% global im
% bw=im2bw(im,0.7);
% label=bwlabel(bw);
% 
% stats=regionprops(label,'Solidity','Area');
% 
% density=[stats.Solidity];
% area=[stats.Area];
% 
% highDenseArea=density > 0.50;
% maxArea=max(area(highDenseArea));
% tumor_label=find(area==maxArea);
% tumor=ismember(label,tumor_label);
% 
% se=strel('square',5);
% tumor=imdilate(tumor,se);
% charc=regionprops(tumor,'Area','Perimeter','Eccentricity');
% Perimeter=charc.Perimeter;
% str2=sprintf('Perimeter=%.3f',Perimeter);
%  set(handles.Perimeter,'String',str2);


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
