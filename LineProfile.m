%Create Intensity Profile Plots which maps pixel gray values across a line
%throughout all slices for each tumor. 

clear

%Read in excel spreadsheets from a folder and store it in 'data'
%Adjust directories as needed
uiwait(msgbox(['Select LineValueTemplate.xlsx spreadsheets']));
[fn,pn]=uigetfile('*.xlsx','MultiSelect','on'); %need to pick more than 1
data.pn=pn; % Store in "data" the path name
data.fn=fn; % Store in "data" the file name

for i=1:length(fn)
    
%Put column and row headers, and pixel values into their own matrix
Data = readmatrix([pn,fn{i}]);
position = Data(2:end,1);
slice = Data(1,2:end);
values = Data(2:end,2:end);
A = length(position);
B = length(slice);

%Create surface plot, adjust style as desired
surf(slice, position, values, 'MeshStyle','column','FaceColor','interp');

%Uncomment below to add colourbar
%colorbar; 

%Add axis labels
zlabel('Gray Value','FontWeight','bold','FontSize',18);
ylabel('Position','FontWeight','bold','FontSize',18);
xlabel('Slice','FontWeight','bold','FontSize',18);

%Set axis limits
zlim([0 255]);
ylim([0 A]);
xlim([0 B]);

%Modify axis directions
ax = gca;
ax.XDir = 'reverse';
ax.YDir = 'reverse';
%axis(ax,'ij');

%Set limit of colourmap
set(ax,'CLim',[0 255]);

%Modify viewpoint of plot
view(-129.971777143055,25.730344668031);

%Obtain sample name without extension and add them to a cell array
%Depending on file name, change "-5" below
I = fn{i};
J = I(1:end-5);

%Save figure and matlab figure and a PNG
%Set the directory and file name and extension
saveas(gcf,['______SET DIRECTORY AND FILE NAME______',J,'.fig']);
saveas(gcf,['______SET DIRECTORY AND FILE NAME______',J,'.png']);

end 


