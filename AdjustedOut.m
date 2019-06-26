function[AO, AO_AO,Cutoff,Outliers,X] = AdjustedOut(X,winsorize)
%x must be a single column of data with any number of rows.
%make winsorize = 1 if you want to winsorize.

%Compute AO Values:
MC = Medcouple(X);
AO = zeros(length(X),1);
IQR = iqr(X);
Q1 = prctile(X,25);
Q3 = prctile(X,75);
Med = median(X);
if MC > 0
    LowWhisker = Q1-1.5*exp(-4*MC)*IQR;
    HighWhisker = Q3+1.5*exp(3*MC)*IQR;
elseif MC < 0
    LowWhisker = Q1-1.5*exp(-3*MC)*IQR;
    HighWhisker = Q3+1.5*exp(4*MC)*IQR;
else
    disp('Error: MC = 0; Data are not skewed. Use 3SD method instead? Check your data.')
end
for i = 1:length(X)
    if X(i,1) > Med
        AO(i,1) = (X(i,1) - Med)/(HighWhisker - Med);
    else
        AO(i,1) = (Med - X(i,1))/(Med - LowWhisker);
    end
end

%Now identify outliers:
MC = Medcouple(AO);
AO_AO = zeros(length(AO),1);
IQR = iqr(AO);
Q1 = prctile(AO,25);
Q3 = prctile(AO,75);
Med = median(AO);

if MC > 0
    LowWhisker = Q1-1.5*exp(-4*MC)*IQR;
    HighWhisker = Q3+1.5*exp(3*MC)*IQR;
    Cutoff = Q3 + 1.5*exp(3*MC)*IQR;
elseif MC < 0
    LowWhisker = Q1-1.5*exp(-3*MC)*IQR;
    HighWhisker = Q3+1.5*exp(4*MC)*IQR;
    Cutoff = Q3 + 1.5*exp(4*MC)*IQR;
else
    disp('Error: MC = 0; Data are not skewed. Use 3SD method instead? Check your data.')
end
for i = 1:length(AO)
    if AO(i,1) > Med
        AO_AO(i,1) = (AO(i,1) - Med)/(HighWhisker - Med);
    else
        AO_AO(i,1) = (Med - AO(i,1))/(Med - LowWhisker);
    end
end
display(AO > Cutoff)
Outliers = X(AO > Cutoff);
if winsorize == 1
    NewData = X;
    NewData(AO > Cutoff) = NaN;
    X(X > max(NewData)) = max(NewData);
    X(X < min(NewData)) = min(NewData);
end