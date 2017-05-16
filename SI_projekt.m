function varargout = SI_projekt(varargin)
% SI_PROJEKT MATLAB code for SI_projekt.fig
%      SI_PROJEKT, by itself, creates a new SI_PROJEKT or raises the existing
%      singleton*.
%
%      H = SI_PROJEKT returns the handle to a new SI_PROJEKT or the handle to
%      the existing singleton*.
%
%      SI_PROJEKT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SI_PROJEKT.M with the given input arguments.
%
%      SI_PROJEKT('Property','Value',...) creates a new SI_PROJEKT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SI_projekt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SI_projekt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SI_projekt

% Last Modified by GUIDE v2.5 26-May-2016 13:28:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SI_projekt_OpeningFcn, ...
                   'gui_OutputFcn',  @SI_projekt_OutputFcn, ...
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


% --- Executes just before SI_projekt is made visible.
function SI_projekt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SI_projekt (see VARARGIN)

% Choose default command line output for SI_projekt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SI_projekt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SI_projekt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in InputMatrixButton.
function InputMatrixButton_Callback(hObject, eventdata, handles)

[FileName,PathName] = uigetfile('*.txt','Wybierz swoja macierz');
handles.FileName = FileName;

address = [PathName FileName];

s = dir(address);

if s.bytes == 0         %file is empty
    disp('Macierz nie mo??e byÄ? pusta!')
    set(handles.scaleButton,'Enable','off');
    set(handles.numberFeatures,'Enable','off');
    set(handles.errorInputBox,'Visible','on');
    set(handles.infoInputBox, 'string','');
else
    M = dlmread(FileName);
    handles.M = M;
    [row_M col_M] = size(M);
    handles.col_M = col_M;
    handles.row_M = row_M;
    set(handles.scaleButton,'Enable','on');
    set(handles.numberFeatures,'Enable','on');
    set(handles.errorInputBox,'Visible','off');
    txt = [ 'Macierz zawiera: ' num2str(row_M) ' obiekty z ' num2str(col_M)  ' cechami'];
    set(handles.infoInputBox, 'string',txt);
end

guidata(hObject, handles);
% hObject    handle to InputMatrixButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in scaleButton.
function scaleButton_Callback(hObject, eventdata, handles)

FileName = handles.FileName;
M = handles.M;
row_M = handles.row_M;
col_M = handles.col_M;
features = get(handles.numberFeatures, 'string');
features = str2num(features);
if isempty(features)
    disp('Podana warto??Ä? cech nie jest prawid??owa!')
    set(handles.errorFeaturesBox,'Visible','on');
    set(handles.numberFeatures, 'string','');
    set(handles.differenceFeatures,'Visible','off');
elseif handles.col_M <= features
     disp('Ilo??Ä? cech musi byÄ? mniejsza ni?? poczÄ?tkowa!')
     set(handles.errorFeaturesBox,'Visible','off');
     set(handles.differenceFeatures,'Visible','on');
else
     set(handles.errorFeaturesBox,'Visible','off');
     set(handles.differenceFeatures,'Visible','off');
     
     set(handles.mistakeTXT,'Visible','on');
 
 
     %%%%%%%%%%%%    genetyczny    %%%%%%%%%%%%%%%%
     s=rng; % do randa
 
 
     ilosc_przemn = 10;
	 przemn = zeros(col_M, features, ilosc_przemn);
     nowe_przemn=zeros(col_M, features, ilosc_przemn);
	 fitness = zeros(ilosc_przemn);
	 rozmnazanie= 0.75;
	 mutacja = 0.1;
	 odleglosci_wejsciowej = zeros(row_M,row_M);
	 wyjsciowa = zeros(row_M, features, ilosc_przemn);
	 odleglosci_wyjsciowej = zeros(row_M,row_M,ilosc_przemn);
	 fitness = zeros(ilosc_przemn);%%%%fitness
	 suma_odl_wyjsc=zeros(ilosc_przemn);
     % uzupelnienie poczatkowej macierzy przemn
		for a = 1 : ilosc_przemn 
			for b = 1 : col_M
				for c = 1 : features
					przemn ( b , c , a ) = rand() ;
				end
			end
		end
 
 
	% liczenie odleglosci dla macierzy wejsciowej
	for a = 1 : row_M
		for b = 1 : row_M
		suma = 0;
			for c = 1 : col_M
				suma = suma + (M(a,c) - M(b,c))*(M(a,c) - M(b,c));	
			end
			odleglosci_wejsciowej(a,b) = sqrt(suma);
		end
	end
 
 
	% liczenie sumy odleglosci dla macierzy wejsciowej
	suma_odl_wejsc=0;
	for a =1 : row_M
		for b = a : row_M
			suma_odl_wejsc=suma_odl_wejsc+odleglosci_wejsciowej(a,b);
		end
	end
 
 
 
 
 
 
 
	obiegow = 1000;
	for x = 1 : obiegow %petla glowna%%%%%%%%%%%%%%%%%%%%%%

		for a = 1 : ilosc_przemn
			wyjsciowa(:,:,a) = M * przemn(:,:,a);	
		end
 
		%liczenie odleglosci punktow dla macierzy wyjsciowych
		for ob = 1 : ilosc_przemn
			for a = 1 : row_M
				for b = 1 : row_M
					suma = 0;
					for c = 1 : features
						suma = suma + (wyjsciowa(a,c,ob) - wyjsciowa(b,c,ob))*(wyjsciowa(a,c,ob) - wyjsciowa(b,c,ob));	
					end
					odleglosci_wyjsciowej(a,b,ob) = sqrt(suma);
				end
			end
		end
 
 
	%liczenie sumy odleglosci dla wyjsciowych
		for i = 1 : ilosc_przemn
		suma_odl_wyjsc(i)=0;
			for a =1 : row_M
				for b = a : row_M
					suma_odl_wyjsc(i) = suma_odl_wyjsc(i) + odleglosci_wyjsciowej(a,b,i);
				end
			end
			fitness(i) = abs( suma_odl_wejsc - suma_odl_wyjsc(i));
		end
 

 
 
 
		%ruletka i rozmnazanie
		suma_fitness = 0;
		for i=1:ilosc_przemn
			suma_fitness = suma_fitness + fitness(i);
		end
 
	ilosc_os = ilosc_przemn;
	aktualne_zapelnienie = 1;
 
                while(ilosc_os)
				
				% losowanie 2 organizmow ruletkÄ?
                    rodzic1 = 1;
                    rodzic2 = 1;
                    random1 = rand(1,1)*suma_fitness;
                    random2 = rand(1,1)*suma_fitness;
					
					suma_random1=0;
					for i = 1 : ilosc_przemn
						suma_random1=suma_random1 + fitness(i);
						if(suma_random1>random1)
							rodzic1 = i;
							break;
						end
					end
					
					
					suma_random2=0;
					for i = 1 : ilosc_przemn
						suma_random2=suma_random2 + fitness(i);
						if(suma_random2>random2)
							rodzic2 = i;
							break;
						end
					end
					
					
					
					
                    czy_rozmnaza = rand(1,1); %prawdopodobienstwo ze rozmnozy, else przepisz
				
                    if(czy_rozmnaza <= rozmnazanie)
						dziecko1=zeros(col_M,features);
						dziecko2=zeros(col_M,features);
						punkt_krzyzowania=randi([1 features ],1,1);
						
						for wiersz=1:col_M
							for kolumna=1: punkt_krzyzowania
								dziecko1 (wiersz,kolumna)=przemn(wiersz,kolumna,rodzic1);
								dziecko2 (wiersz,kolumna)=przemn(wiersz,kolumna,rodzic2);
							end
						end
 
						
						
						
						
								%uzupelnienie dziecka 1
						
						for wiersz=1:col_M
							licznik1=punkt_krzyzowania;
							for kolumna=1: features
								czy_wystapil=0;
								if(licznik1<features)
									for e=1:features
										if(dziecko1 (wiersz,e) == przemn(wiersz,kolumna,rodzic2)) 
											czy_wystapil=1;
											break;
										end
									end
									if(czy_wystapil==0)
										dziecko1 (wiersz,licznik1+1) = przemn(wiersz,kolumna,rodzic2);
										licznik1 = licznik1 + 1;
									
									
									end
								end
							end
						end
				
				
				
						%uzupelnienie dziecka 2
						
						for wiersz=1:col_M
							licznik2=punkt_krzyzowania;
							for kolumna=1: features
								czy_wystapil=0;
								if(licznik2<features)
									for e=1:features
										if(dziecko2 (wiersz,e) == przemn(wiersz,kolumna,rodzic1)) 
											czy_wystapil=1;
											break;
										end
									end
									if(czy_wystapil==0)
										dziecko2 (wiersz,licznik2+1) = przemn(wiersz,kolumna,rodzic1);
										licznik2 = licznik2 + 1;

									end
								end
							end
						end
						
						
						%%%przepisanie dzieci do nowe_przemn
							for t=1:col_M
								for y=1 : features
								nowe_przemn(t,y,aktualne_zapelnienie)=dziecko1(t,y);
								nowe_przemn(t,y,aktualne_zapelnienie+1)=dziecko2(t,y);
								end
							end
						
						%	punkt_krzyzowania
						%dziecko1
						%dziecko2
						%przemn(:,:,rodzic1)
						%przemn(:,:,rodzic2)
						%disp('---------------------')
                    else %nie rozmnaza -> przepisanie 
					

							for t=1:col_M
								for y=1 : features
								nowe_przemn(t,y,aktualne_zapelnienie)=przemn(t,y,rodzic1);
								nowe_przemn(t,y,aktualne_zapelnienie+1)=przemn(t,y,rodzic2);
								end
							end
						
                    
					end
						
					ilosc_os = ilosc_os-2;
					aktualne_zapelnienie=aktualne_zapelnienie+2;
					
                end 
 
 
 
		%%%mutacja 
		for i=1:ilosc_przemn
			los=rand(1,1);
			if(los<=mutacja)
				wiersz1=randi([1 col_M],1,1);
				kolumna1=randi([1 features],1,1);
				wiersz2=randi([1 col_M],1,1);
				kolumna2=randi([1 features],1,1);
				tymczasowa=nowe_przemn(wiersz1,kolumna1,i);
				nowe_przemn(wiersz1,kolumna1,i)=nowe_przemn(wiersz2,kolumna2,i);
				nowe_przemn(wiersz2,kolumna2,i)=tymczasowa;			
			end
		end
		
		
		%%%%wyszukanie najlepszego elementu w starej tablicy
		indeks_najlepszej=0;
		wartosc_najlepszej=100000;
		for i=1:ilosc_przemn
			if(fitness(i)<wartosc_najlepszej)
				wartosc_najlepszej=fitness(i);
				indeks_najlepszej=i;
		
			end
        end
        
        
		%zapis do tablicy bledow
        tab_bledow(x) = wartosc_najlepszej;
	
		
		%przepisanie do losowego miejsca w nowej najlepszego elementu ze starej
		numer_zamiany=randi([1 ilosc_przemn],1,1);
		for i=1:col_M
			for j=1:features
				nowe_przemn(i,j,numer_zamiany)=przemn(i,j,indeks_najlepszej);
 
			end
		end
 
 
 
		%przepisanie nowe_przemn do przemn
		for i=1:ilosc_przemn
			for j=1:col_M
				for t=1:features
					przemn(j,t,i)=nowe_przemn(j,t,i);
				end
			end
		end
	end %koniec petli glownej
 
     
     indeks_najlepszej=0;
		wartosc_najlepszej=100000;
		for i=1:ilosc_przemn
			if(fitness(i)<wartosc_najlepszej)
				indeks_najlepszej=i;
		
			end
		end
		M
        koncowa=M*przemn(:,:,indeks_najlepszej)
        przemn(:,:,indeks_najlepszej);
        
	
		
        x_bledu = 1:obiegow;
        plot(x_bledu, tab_bledow)
       % mesh(M)
        
        t = uitable(handles.outputTable);
        set(t,'Data',koncowa); 
		
        set(handles.mistakeVALUE, 'string',num2str(tab_bledow(obiegow)) );
		
end

% hObject    handle to scaleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function numberFeatures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to numberFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberFeatures as text
%        str2double(get(hObject,'String')) returns contents of numberFeatures as a double
