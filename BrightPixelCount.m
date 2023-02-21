%Calculates the percentage of bright pixels across all slices for each tumor
%Bright pixels here at defined as those above a threshold calculated on
%corresponding pre-contrast images for each animal. Threshold algorithm can
%be changed below

clear

%Read in pre-gad excel spreadsheets from a folder and store it in 'data'
%Ensure that order of files names in folders match up
%Adjust directories as needed
uiwait(msgbox(['Select Pre-contrast HistoValueTemplate.xlsx spreadsheets']));
[fn,pn]=uigetfile('*.xlsx','MultiSelect','on');
data.pn=pn; % Store in "data" the path name
data.fn=fn; % Store in "data" the file name

for i=1:length(fn)
    
%Load image in matrix and put column and row headers, and values into their own vectors
Data = readmatrix([pn,fn{i}]);
grayvalue = Data(2:end,1);
slice = Data(1,2:end);
values = Data(2:end,2:end);

%Tally up counts for each gray value in a column vector over all slices
counts = sum(values,2); 
totalpixels(i) = sum(counts);

%Calculate the mean of entire image
sumvalues = dot(counts,grayvalue);
imagemean(i) = sumvalues/totalpixels(i);
a = imagemean(i);

%Calculate the stDev of entire image
s = counts.*((grayvalue-a).^2);
imagestdev(i) = sqrt(sum(s)/totalpixels(i));
b=imagestdev(i);


%MODIFY THRESHOLDING ALGORITHM BELOW:
%Current algorithm is Mean +/- StDev
%Set threshold vector, change x to change numbers of StDevs above Mean
x = 2;
imagethreshold(i) = ceil(a + b*x);

end

%Read in post-gad excel spreadsheets from a folder and store it in 'data2'
uiwait(msgbox(['Select Post-contrast HistoValueTemplate.xlsx spreadsheets']));
[fn,pn]=uigetfile('*.xlsx','MultiSelect','on');
data2.pn=pn; % Store in "data" the path name
data2.fn=fn; % Store in "data" the file name

for j=1:length(fn)
    
%Load image in matrix and put column and row headers into their own vectors
Data2 = readmatrix([pn,fn{j}]);
grayvalue = Data2(2:end,1);
slice = Data2(1,2:end);
values = Data2(2:end,2:end);

%Tally up counts for each gray value in a column vector over all slices
counts = sum(values,2); 
totalpixelspost(j) = sum(counts);

%Count pixels above threshold (bright pixels)
brightpixels(j) = sum(counts(imagethreshold(j):end));

%Calculate percentage of all pixels that are bright pixels
percentpixels(j) = brightpixels(j)/totalpixelspost(j);

%Obtain sample name without extension and add them to a cell array. 
%Depending on file name, change "-13" below
I = fn{j}; 
J = I(1:end-13);
name{j} = J;

end

%Save data into an excel document 
%Set the directory and file name and extension
NAME = convertCharsToStrings(name)';
MEAN = imagemean';
STDEV = imagestdev';
THRESHOLD = imagethreshold';
TOTALPIXELSPOST = totalpixelspost';
BRIGHTPIXELS = brightpixels';
PERCENTPIXELS = percentpixels';
T = table(NAME,THRESHOLD,TOTALPIXELSPOST,BRIGHTPIXELS,PERCENTPIXELS);
writetable(T, '______SET DIRECTORY AND FILE NAME______');

