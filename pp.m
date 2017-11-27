function varargout = PubPerish(varargin)
% PUBPERISH MATLAB code for PubPerish.fig
%      PUBPERISH, by itself, creates a new PUBPERISH or raises the existing
%      singleton*.
%
%      H = PUBPERISH returns the handle to a new PUBPERISH or the handle to
%      the existing singleton*.
%
%      PUBPERISH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUBPERISH.M with the given input arguments.
%
%      PUBPERISH('Property','Value',...) creates a new PUBPERISH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PubPerish_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PubPerish_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PubPerish

% Last Modified by GUIDE v2.5 27-Nov-2017 08:30:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PubPerish_OpeningFcn, ...
                   'gui_OutputFcn',  @PubPerish_OutputFcn, ...
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


% --- Executes just before PubPerish is made visible.
function PubPerish_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PubPerish (see VARARGIN)




% Choose default command line output for PubPerish
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PubPerish wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = PubPerish_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function FieldParameters_CellEditCallback(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function EnvParameters_CellEditCallback(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function ResParameters_CellEditCallback(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Fielddata = get(handles.FieldParameters, 'Data');
Envdata = get(handles.EnvParameters,'Data');
Resdata = get(handles.ResParameters,'Data');



%Now we assign Field specifics...  
DR = Fielddata{1,2};
J = Fielddata{2,2};
pt = Fielddata{3,2};
pf = Fielddata{4,2};

%Now Environment issues
B = Envdata{1,2};
nu = Envdata{2,2};
R = Envdata{3,2};
fd = Envdata{4,2};
fc = Envdata{5,2};
fu = Envdata{6,2};



%Now researcher issues
errc = Resdata{1,2};
dt = Resdata{2,2};
bd = Resdata{3,2};
bc = Resdata{4,2};
bu = Resdata{5,2};

%flim = DR*dt*nu;  ;
err= 0.05; 
%Calculate rates, do sanity check
sdp = DR*(pt + err*pf);
scp = DR*(pt + errc*err*pf);
sup = DR*(pt + err*pf + dt);

sdb = DR*(err*pf);
scb = DR*(errc*err*pf);
sub = DR*(err*pf + dt);

N = 1 - (pf + pt);

sdn = DR*(bd*N);
scn = DR*(bc*N);
sun = DR*(bu*N);





%Now we should so some calculation

n = 1; 

TR = 100; 
x0 = TR*fd;
y0 = TR*fc;
z0 = TR*fu;

% if (J/(x0*sdp + y0*scp + z0*sup + x0*sdn + y0*scn + z0*sun)) <= 1
%     
%     pass_sub = 1;
%     
% else do for all x y z!!!
%     
%     pass_sub = 0;
%     
% end

x = zeros(12,1);
y = x;
z = x;
A = zeros(11,1);
vp = A;
vn = A;
Ld = A;
Lc = A;
Lu = A;

x(1) = x0;
y(1) = y0;
z(1) = z0;


while n < 12;
    
  A(n) = J/(x(n) + y(n) + z(n));
  
    vp(n) = (B*J)./(x(n)*sdp + y(n)*scp + z(n)*sup);
    vn(n) = ((1-B)*J)./(x(n)*sdn + y(n)*scn + z(n)*sun);
      
 
    
    Ld(n) = vp(n).*sdp + vn(n).*sdn;
    Lc(n) = vp(n).*scp + vn(n).*scn;
    Lu(n) = vp(n).*sup + vn(n).*sun;
    
    x(n+1) = x(n).*(Ld(n)./A(n)) + R*fd;
    y(n+1) = y(n).*(Lc(n)./A(n)) + R*fc;
    z(n+1) = z(n).*(Lu(n)./A(n) - (DR*nu*dt).* vp(n)) + R*fu  ;
    
    
    
   n = n + 1;  
end

x = x(1:11,1);
y = y(1:11,1);
z = z(1:11,1); 

 

h = 0:10; 

tt = 0:0.01:10; 

xspline = spline(h,x,tt);
yspline = spline(h,y,tt);
zspline = spline(h,z,tt);

xabs = xspline./(xspline + yspline + zspline);
yabs = yspline./(xspline + yspline + zspline);
zabs = zspline./(xspline + yspline + zspline);

Q = 1 - (vp.*(x.*sdb + y.*scb + z.*sub))./J;
qspline = spline(h,Q,tt); 

axes(handles.axes1)
cla
plot(tt, xabs, 'LineWidth',2); hold on; 
plot(tt,yabs, 'm','LineWidth',2); 
plot(tt,zabs,'r','LineWidth',2); 
title('Absolute proportion of resources consumed');
xlabel('Funding cycles'); 
ylabel('Fraction of all funding');
legend('Diligent cohort','Careless cohort', 'Unethical cohort');

axes(handles.axes2)
cla
plot(tt, qspline, 'b','LineWidth',2)
title('Science Trustworthiness (B-Dependent)');
xlabel('Funding cycles'); 
ylabel('Replicable science proportion');



%sanity checks

if N <= 1 & pt <= 1 & pf <= 1 & N>= 0 & pt >=0 & pf>= 0
    
    Ratetxt = 'Check 1 - True / False positive rates appear valid   ';
    
else
    
    Ratetxt = 'WARNING - Questionable True /False positive rate detected!   ';
    
end

if max(vp) <= 1 & min(vp) >= 0 & max(vn) <= 1 &  min(vn) >= 0
    
    Rate2txt = 'Check 2 - Publishing pressure rates appear valid.   ';
    
else
    
    Rate2txt = 'WARNING - Impossible values for publication probability detected!   ';
    
end

if fd + fc + fu == 1
    
    Rate3txt = 'Check 3 - Ratios appear correct.   ';
    
else
    
    Rate3txt = 'WARNING - Sum of all cohort fractions not equal to 1!   ';
    
end



txtstring = [Ratetxt Rate2txt Rate3txt ];

set(handles.statusbx, 'String', txtstring);







% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Fielddata = get(handles.FieldParameters, 'Data');
Envdata = get(handles.EnvParameters,'Data');
Resdata = get(handles.ResParameters,'Data');



%Now we assign Field specifics...  
DR = Fielddata{1,2};
J = Fielddata{2,2};
pt = Fielddata{3,2};
pf = Fielddata{4,2};

%Now Environment issues
B = Envdata{1,2};
nu = Envdata{2,2};
R = Envdata{3,2};
fd = Envdata{4,2};
fc = Envdata{5,2};
fu = Envdata{6,2};



%Now researcher issues
errc = Resdata{1,2};
dt = Resdata{2,2};
bd = Resdata{3,2};
bc = Resdata{4,2};
bu = Resdata{5,2};

%flim = DR*dt*nu;  ;
err= 0.05; 
%Calculate rates, do sanity check
sdp = DR*(pt + err*pf);
scp = DR*(pt + errc*err*pf);
sup = DR*(pt + err*pf + dt);

sdb = DR*(err*pf);
scb = DR*(errc*err*pf);
sub = DR*(err*pf + dt);

N = 1 - (pf + pt);

sdn = DR*(bd*N);
scn = DR*(bc*N);
sun = DR*(bu*N);





%Now we should so some calculation

n = 1; 

TR = 100; 
x0 = TR*fd;
y0 = TR*fc;
z0 = TR*fu;

% if (J/(x0*sdp + y0*scp + z0*sup + x0*sdn + y0*scn + z0*sun)) <= 1
%     
%     pass_sub = 1;
%     
% else do for all x y z!!!
%     
%     pass_sub = 0;
%     
% end

x = zeros(12,1);
y = x;
z = x;
A = zeros(11,1);
vp = A;
vn = A;
Ld = A;
Lc = A;
Lu = A;

x(1) = x0;
y(1) = y0;
z(1) = z0;


while n < 12;
    
  A(n) = J/(x(n) + y(n) + z(n));
  
    vp(n) = (J)./(x(n)*(sdp + sdn) + y(n)*(scp + scn) + z(n)*(sup + sun));
      vn(n) = (J)./(x(n)*(sdp + sdn) + y(n)*(scp + scn) + z(n)*(sup + sun));
      
 
    
    Ld(n) = vp(n).*sdp + vn(n).*sdn;
    Lc(n) = vp(n).*scp + vn(n).*scn;
    Lu(n) = vp(n).*sup + vn(n).*sun;
    
    x(n+1) = x(n).*(Ld(n)./A(n)) + R*fd;
    y(n+1) = y(n).*(Lc(n)./A(n)) + R*fc;
    z(n+1) = z(n).*(Lu(n)./A(n) - (DR*nu*dt).* vp(n)) + R*fu  ;
    
    
    
   n = n + 1;  
end

x = x(1:11,1);
y = y(1:11,1);
z = z(1:11,1); 

 

h = 0:10; 

tt = 0:0.01:10; 

xspline = spline(h,x,tt);
yspline = spline(h,y,tt);
zspline = spline(h,z,tt);

xabs = xspline./(xspline + yspline + zspline);
yabs = yspline./(xspline + yspline + zspline);
zabs = zspline./(xspline + yspline + zspline);

Q = 1 - (vp.*(x.*sdb + y.*scb + z.*sub))./J;
qspline = spline(h,Q,tt); 

axes(handles.axes1)
cla
plot(tt, xabs, 'LineWidth',2); hold on; 
plot(tt,yabs, 'm','LineWidth',2); 
plot(tt,zabs,'r','LineWidth',2); 
title('Absolute proportion of resources consumed');
xlabel('Funding cycles'); 
ylabel('Fraction of all funding');
legend('Diligent cohort','Careless cohort', 'Unethical cohort');

axes(handles.axes2)
cla
plot(tt, qspline, 'b','LineWidth',2)
title('Science Trustworthiness (B-independent)');
xlabel('Funding cycles'); 
ylabel('Replicable science proportion');



%sanity checks

if N <= 1 & pt <= 1 & pf <= 1 & N>= 0 & pt >=0 & pf>= 0
    
    Ratetxt = 'Check 1 - True / False positive rates appear valid   ';
    
else
    
    Ratetxt = 'WARNING - Questionable True /False positive rate detected!   ';
    
end

if max(vp) <= 1 & min(vp) >= 0 & max(vn) <= 1 &  min(vn) >= 0
    
    Rate2txt = 'Check 2 - Publishing pressure rates appear valid.   ';
    
else
    
    Rate2txt = 'WARNING - Impossible values for publication probability detected!   ';
    
end

if fd + fc + fu == 1
    
    Rate3txt = 'Check 3 - Ratios appear correct.   ';
    
else
    
    Rate3txt = 'WARNING - Sum of all cohort fractions not equal to 1!   ';
    
end



txtstring = [Ratetxt Rate2txt Rate3txt ];

set(handles.statusbx, 'String', txtstring);





function axes1_CreateFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes during object creation, after setting all properties.
function statusbx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to statusbx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
