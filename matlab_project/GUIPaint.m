function varargout = GUIPaint(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIPaint_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIPaint_OutputFcn, ...
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
 

% --- Executes just before GUIPaint is made visible.
function GUIPaint_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIPaint (see VARARGIN)

% Choose default command line output for GUIPaint
handles.output = hObject;
% set properties
movegui(gcf, 'north');

set(gcf, 'Name', 'GUIPaint');

set(handles.uipanel1, 'Title', []);

set(handles.axes1, 'XLimMode', 'manual');
set(handles.axes1, 'YLimMode', 'manual');
set(handles.axes1, 'NextPlot', 'add');

set(handles.axes1, 'XTick', []);
set(handles.axes1, 'YTick', []);
set(handles.axes1, 'XTickLabel', []);
set(handles.axes1, 'YTickLabel', []);
set(handles.axes1, 'XColor', [1 1 1]);
set(handles.axes1, 'YColor', [1 1 1]);

set(handles.slider1, 'Max', 2);
SliderStepX = 0.2/(2-0);
set(handles.slider1, 'SliderStep', [SliderStepX 0.1]);

set(handles.sliderR, 'SliderStep', [0.1 0.1]);
set(handles.sliderG, 'SliderStep', [0.1 0.1]);
set(handles.sliderB, 'SliderStep', [0.1 0.1]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIPaint wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIPaint_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global flag PaintFlag Eflag;
global CFlag RFlag;
global h;

h = [];

flag = 0;
PaintFlag = 0;
Eflag = 0;

CFlag = 0;
RFlag = 0;

guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag x0 y0 x y PaintFlag Eflag;

flag = 1;
cp = get(handles.axes1, 'CurrentPoint');
x = cp(1,1);
y = cp(1,2);
tempR = get(handles.sliderR, 'Value');
tempG = get(handles.sliderG, 'Value');
tempB = get(handles.sliderB, 'Value');
Color = [tempR tempG tempB];
    
if PaintFlag
    plot(handles.axes1, x, y, 'Color', Color);
end

if Eflag 
    set(gcf, 'CurrentAxes', handles.axes1);
    Eradius = 0.01;

    if x-Eradius>0 && x+Eradius<1 && y-Eradius>0 && y+Eradius<1
        rx = x-Eradius;
        ry = y-Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 左下特殊区域
    if x-Eradius<0 && y-Eradius<0
        rx = max(0, x-Eradius);
        ry = max(0, y-Eradius);
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 右上特殊区域
    if x+Eradius>1 && y+Eradius>1
        rx = min(1,x+Eradius) - 2*Eradius;
        ry = min(1,y+Eradius) - 2*Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 左上特殊区域
    if y+Eradius>1 && x-Eradius<0
        rx = 0;
        ry = min(1,y+Eradius) - 2*Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 右下特殊区域
    if x+Eradius>1 && y-Eradius<0
        rx = min(1,x+Eradius) - 2*Eradius;
        ry = 0;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 左方特殊区域
    if x-Eradius<0 && y-Eradius>0 && y+Eradius<1
        rx = 0;
        ry = y-Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 右方特殊区域
    if x+Eradius>1 && y-Eradius>0 && y+Eradius<1
        rx = min(1,x+Eradius) - 2*Eradius;
        ry = y-Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 上方特殊区域
    if y+Eradius>1 && x-Eradius>0 && x+Eradius<1
        rx = x-Eradius;
        ry = min(1,y+Eradius) - 2*Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 下方特殊区域
    if y-Eradius<0 && x-Eradius>0 && x+Eradius<1
        rx = x-Eradius;
        ry = 0;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
end
x0 = x;
y0 = y;

guidata(hObject, handles);

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag x0 y0 x y PaintFlag Eflag;
global CFlag RFlag;
global h rect;

temp = get(handles.slider1, 'Value');
LineWidth = 4*temp + 2;
tempR = get(handles.sliderR, 'Value');
tempG = get(handles.sliderG, 'Value');
tempB = get(handles.sliderB, 'Value');
Color = [tempR tempG tempB];

if flag && PaintFlag
    x0 = x;
    y0 = y;
    cp = get(handles.axes1, 'CurrentPoint');
    x = cp(1,1);
    y = cp(1,2);
    plot(handles.axes1, [x0 x], [y0 y], 'LineWidth', LineWidth, 'Color', Color);
end
if flag && CFlag
    cp = get(handles.axes1, 'CurrentPoint');
    x = cp(1,1);
    y = cp(1,2);
    if x ~= x0
        if ~isempty(h)
            set(h,'Visible','off')
        end
        rect=[min([x0,x]),min([y0,y]),abs(x-x0),abs(y-y0)];
        if rect(3)*rect(4)~=0
            h=rectangle('Position',rect,'Curvature',[1,1],'LineStyle',':',...
                'EdgeColor',Color, 'LineWidth', LineWidth);
        end
    end    
end
if flag && RFlag
    cp = get(handles.axes1, 'CurrentPoint');
    x = cp(1,1);
    y = cp(1,2);    
    if x ~= x0
        if ~isempty(h)
            set(h,'Visible','off')
        end
        rect=[min([x0,x]),min([y0,y]),abs(x-x0),abs(y-y0)];
        if rect(3)*rect(4)~=0
            h=rectangle('Position',rect,'LineStyle',':',...
                'EdgeColor',Color, 'LineWidth', LineWidth);
        end
    end      
end
if flag && Eflag
    x0 = x;
    y0 = y;
    cp = get(handles.axes1, 'CurrentPoint');
    x = cp(1,1);
    y = cp(1,2);    
    set(gcf, 'CurrentAxes', handles.axes1);
    Eradius = 0.01;

    if x-Eradius>0 && x+Eradius<1 && y-Eradius>0 && y+Eradius<1
        rx = x-Eradius;
        ry = y-Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 左下特殊区域
    if x-Eradius<0 && y-Eradius<0
        rx = max(0, x-Eradius);
        ry = max(0, y-Eradius);
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 右上特殊区域
    if x+Eradius>1 && y+Eradius>1
        rx = min(1,x+Eradius) - 2*Eradius;
        ry = min(1,y+Eradius) - 2*Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 左上特殊区域
    if y+Eradius>1 && x-Eradius<0
        rx = 0;
        ry = min(1,y+Eradius) - 2*Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 右下特殊区域
    if x+Eradius>1 && y-Eradius<0
        rx = min(1,x+Eradius) - 2*Eradius;
        ry = 0;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 左方特殊区域
    if x-Eradius<0 && y-Eradius>0 && y+Eradius<1
        rx = 0;
        ry = y-Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 右方特殊区域
    if x+Eradius>1 && y-Eradius>0 && y+Eradius<1
        rx = min(1,x+Eradius) - 2*Eradius;
        ry = y-Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 上方特殊区域
    if y+Eradius>1 && x-Eradius>0 && x+Eradius<1
        rx = x-Eradius;
        ry = min(1,y+Eradius) - 2*Eradius;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
    % 下方特殊区域
    if y-Eradius<0 && x-Eradius>0 && x+Eradius<1
        rx = x-Eradius;
        ry = 0;
        rectangle('Position',[rx,ry,2*Eradius,2*Eradius], ...
            'EdgeColor','w','FaceColor','w');
    end
end
guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag PaintFlag Eflag;
global CFlag RFlag;
global h rect;

temp = get(handles.slider1, 'Value');
LineWidth = temp + 2;
tempR = get(handles.sliderR, 'Value');
tempG = get(handles.sliderG, 'Value');
tempB = get(handles.sliderB, 'Value');
Color = [tempR tempG tempB];

flag = 0;
% PaintFlag = 0;
% Eflag = 0;

if CFlag
    set(h,'Visible','off');
    h=[];
    if rect(3)*rect(4)~=0
        rectangle('Position',rect,'Curvature',[1,1],...
            'EdgeColor',Color, 'LineWidth', LineWidth)
    end
end

if RFlag
    set(h,'Visible','off');
    h=[];
    if rect(3)*rect(4)~=0
        rectangle('Position',rect,...
            'EdgeColor',Color, 'LineWidth', LineWidth)
    end
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PaintFlag Eflag;
global CFlag RFlag;
CFlag = 0;
RFlag = 0;
PaintFlag = 1;
Eflag = 0;
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PaintFlag Eflag;
global CFlag RFlag;
CFlag = 0;
RFlag = 0;
PaintFlag = 0;
Eflag = 1;
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName, PathName, filterindex] = uiputfile({'*.jpg','JPEG(*.jpg)';...
    '*.bmp','Bitmap(*.bmp)';...
    '*.gif','GIF(*.gif)';...
    '*.*',  'All Files (*.*)'},...
    'Save Picture','Untitled');

if filterindex
    h = getframe(handles.axes1);
    imwrite(h.cdata,[PathName,FileName]);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Eflag;
cla(handles.axes1);
Eflag = 0;
guidata(hObject, handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global flag PaintFlag x0 y0 x y;
clear global CFlag RFlag;
clear global h rect;
close;

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderR_Callback(hObject, eventdata, handles)
% hObject    handle to sliderR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderG_Callback(hObject, eventdata, handles)
% hObject    handle to sliderG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderB_Callback(hObject, eventdata, handles)
% hObject    handle to sliderB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PaintFlag Eflag;
global CFlag RFlag;
CFlag = 1;
RFlag = 0;
PaintFlag = 0;
Eflag = 0;
guidata(hObject, handles);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PaintFlag Eflag;
global CFlag RFlag;
CFlag = 0;
RFlag = 1;
PaintFlag = 0;
Eflag = 0;
guidata(hObject, handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = getframe(handles.axes1);
img = h.cdata;
grayImg = rgb2gray(img);
pred = stackedAERecognition(grayImg, 2);
%save('img.mat','grayImg');
%fprintf('检测结果: %s\n', char(pred));
set(handles.text_result,'String',char(pred));
guidata(hObject, handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*','All Files' },...
    '请选择要修改的图片');
if not(isequal(filename,0))
    img = imread([pathname,filename]);
    grayImg = rgb2gray(img);
    pred = stackedAERecognition(grayImg, 2);
    fprintf('检测结果: %s\n', char(pred));
    set(handles.text_result,'String',char(pred));
    figure;
    imshow(imresize(img,[256 256]));
end
guidata(hObject, handles);
