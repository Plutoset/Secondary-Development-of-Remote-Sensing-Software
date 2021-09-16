%function allmode=eemd(Y,Nstd,NE)
%
% This is an EMD/EEMD program
%
% INPUT:
%       Y: Inputted data;1-d data only
%       Nstd: ratio of the standard deviation of the added noise and that of Y;
%       NE: Ensemble number for the EEMD
% OUTPUT:
%       A matrix of N*(m+1) matrix, where N is the length of the input
%       data Y, and m=fix(log2(N))-1. Column 1 is the original data, columns 2, 3, ...
%       m are the IMFs from high to low frequency, and comlumn (m+1) is the
%       residual (over all trend).
%
% NOTE:
%       It should be noted that when Nstd is set to zero and NE is set to 1, the
%       program degenerates to a EMD program.(for EMD Nstd=0,NE=1)
%       This code limited sift number=10 ,the stoppage criteria can't change.
%
% References:
%  Wu, Z., and N. E Huang (2008),
%  Ensemble Empirical Mode Decomposition: a noise-assisted data analysis method.
%   Advances in Adaptive Data Analysis. Vol.1, No.1. 1-41.
%
% code writer: Zhaohua Wu.
% footnote:S.C.Su 2009/03/04
%
% There are three loops in this code coupled together.
%  1.read data, find out standard deviation ,devide all data by std
%  2.evaluate TNM as total IMF number--eq1.
%    TNM2=TNM+2,original data and residual included in TNM2
%    assign 0 to TNM2 matrix
%  3.Do EEMD NE times-------------------------------------------------------------loop EEMD start
%     4.add noise
%     5.give initial values before sift
%     6.start to find an IMF------------------------------------------------IMF loop start
%     7.sift 10 times to get IMF--------------------------sift loop  start  and end
%     8.after 10 times sift --we got IMF
%     9.subtract IMF from data ,and let the residual to find next IMF by loop
%     6.after having all the IMFs---------------------------------------------IMF loop end
%     9.after TNM IMFs ,the residual xend is over all trend
%  3.Sum up NE decomposition result-------------------------------------------------loop EEMD end
% 10.Devide EEMD summation by NE,std be multiply back to data
%
% Association: no
% this function ususally used for doing 1-D EEMD with fixed
% stoppage criteria independently.
%
% Concerned function: extrema.m
%                     above mentioned m file must be put together

function allmode=eemd(Y,Nstd,NE)

%part1.read data, find out standard deviation ,devide all data by std
xsize=length(Y);
dd=1:1:xsize;
Ystd=std(Y);
Y=Y/Ystd;

%part2.evaluate TNM as total IMF number,ssign 0 to TNM2 matrix
TNM=fix(log2(xsize))-1;
TNM2=TNM+2;
allmode = zeros(xsize,TNM2);
% for kk=1:1:TNM2,
%     for ii=1:1:xsize,
%         allmode(ii,kk)=0.0;
%     end
% end

%part3 Do EEMD  -----EEMD loop start
for iii=1:NE,   %EEMD loop -NE times EMD sum together
    
    %part4 --Add noise to original data,we have X1
    %     for i=1:xsize,
    %         temp=randn(1,1)*Nstd;
    %         X1(i)=Y(i)+temp;
    %     end
    X1 = Y'+randn(1,xsize)*Nstd;
    
    %part4 --assign original data in the first column
    %     for jj=1:1:xsize,
    %         mode(jj,1) = Y(jj);
    %     end
    mode(:,1) = Y;
    
    %part5--give initial 0 to xorigin and xend
    xorigin = X1;
    xend = xorigin;
    
    %part6--start to find an IMF-----IMF loop start
    nmode = 1;
    while nmode <= TNM,
        xstart = xend; %last loop value assign to new iteration loop
        %xstart -loop start data
        iter = 1;      %loop index initial value
        
        %part7--sift 10 times to get IMF---sift loop  start
        while iter<=10,
            [spmax, spmin, flag]=extrema(xstart);  %call function extrema
            %the usage of  spline ,please see part11.
            upper= spline(spmax(:,1),spmax(:,2),dd); %upper spline bound of this sift
            lower= spline(spmin(:,1),spmin(:,2),dd); %lower spline bound of this sift
            mean_ul = (upper + lower)/2;%spline mean of upper and lower
            xstart = xstart - mean_ul;%extract spline mean from Xstart
            iter = iter +1;
        end
        %part7--sift 10 times to get IMF---sift loop  end
        
        %part8--subtract IMF from data ,then let the residual xend to start to find next IMF
        xend = xend - xstart;
        
        nmode = nmode+1;
        
        %part9--after sift 10 times,that xstart is this time IMF
        %         for jj=1:1:xsize,
        %             mode(jj,nmode) = xstart(jj);
        %         end
        mode(:,nmode) = xstart;
    end
    %part6--start to find an IMF-----IMF loop end
    
    %part 10--after gotten  all(TNM) IMFs ,the residual xend is over all trend
    %                        put them in the last column
    %     for jj=1:1:xsize,
    %         mode(jj,nmode+1)=xend(jj);
    %     end
    mode(:,nmode+1) = xend;
    %after part 10 ,original +TNM-IMF+overall trend  ---those are all in mode
    allmode=allmode+mode;
    
end
%part3 Do EEMD  -----EEMD loop end

%part10--devide EEMD summation by NE,std be multiply back to data
allmode=allmode/NE;
allmode=allmode*Ystd;

%part11--the syntax of the matlab function spline
%yy= spline(x,y,xx); this means
%x and y are matrixs of n1 points ,use n1 set (x,y) to form the cubic spline
%xx and yy are matrixs of n2 points,we want know the spline value yy(y-axis) in the xx (x-axis)position
%after the spline is formed by n1 points ,find coordinate value on the spline for [xx,yy] --n2 position.

%  function [spmax, spmin, flag]= extrema(in_data)
%
% This is a utility program for cubic spline envelope,
%   the code is to  find out max values and max positions
%                            min values and min positions
%    (then use matlab function spline to form the spline)
%
%   function [spmax, spmin, flag]= extrema(in_data)
%
% INPUT:
%       in_data: Inputted data, a time series to be sifted;
% OUTPUT:
%       spmax: The locations (col 1) of the maxima and its corresponding
%              values (col 2)
%       spmin: The locations (col 1) of the minima and its corresponding
%              values (col 2)
%
% NOTE:
%      EMD uses Cubic Spline to be the Maximun and Minimum Envelope for
%        the data.Besides finding spline,end points should be noticed. 
%
%References:  ? which paper?
% 
%
%
% code writer: Zhaohua Wu. 
% footnote:S.C.Su
%
% There are two seperste loops in this code .
% part1.-- find out max values and max positions 
%          process the start point and end point  
% part2.-- find out min values and max positions 
%          process the start point and end point  
% Those parts are similar.
%
% Association:eemd.m
% this function ususally used for finding spline envelope
%
% Concerned function: no
%                     (all matlab internal function)

function [spmax, spmin, flag]= extrema(in_data)

flag=1;
dsize=length(in_data);

%part1.--find local max value and do end process

%start point 
%spmax(1,1)-the first 1 means first point max value,the second 1 means first index
%spmax(1,2)-the first 1 means first point max value,the second 2 means first index
%spmax(1,1)-for position of max 
%spmax(1,2)-for value    of max

spmax(1,1) = 1;
spmax(1,2) = in_data(1);

%Loop --start find max by compare the values 
%when [ (the jj th value > than the jj-1 th value ) AND (the jj th value > than the jj+1 th value )
%the value jj is the position of the max
%the value in_data (jj) is the value of the max
%do the loop by index-jj
%after the max value is found,use index -kk to store in the matrix
%kk=1,the start point
%the last value of kk ,the end point 

jj=2;
kk=2;
while jj<dsize,
    if ( in_data(jj-1)<=in_data(jj) & in_data(jj)>=in_data(jj+1) )
        spmax(kk,1) = jj;
        spmax(kk,2) = in_data (jj);
        kk = kk+1;
    end
    jj=jj+1;
end

%end point
spmax(kk,1)=dsize;
spmax(kk,2)=in_data(dsize);

%End point process-please see reference about spline end effect
%extend the slpoe of neighbor 2 max value ---as extend value
%original value of end point -----as original value
%compare extend and original value 

if kk>=4
    slope1=(spmax(2,2)-spmax(3,2))/(spmax(2,1)-spmax(3,1));
    tmp1=slope1*(spmax(1,1)-spmax(2,1))+spmax(2,2);
    if tmp1>spmax(1,2)
        spmax(1,2)=tmp1;
    end

    slope2=(spmax(kk-1,2)-spmax(kk-2,2))/(spmax(kk-1,1)-spmax(kk-2,1));
    tmp2=slope2*(spmax(kk,1)-spmax(kk-1,1))+spmax(kk-1,2);
    if tmp2>spmax(kk,2)
        spmax(kk,2)=tmp2;
    end
else
    flag=-1;
end

%these 4 sentence seems useless.
msize=size(in_data);
dsize=max(msize);
xsize=dsize/3;
xsize2=2*xsize;


%part2.--find local min value and do end process
%the syntax are all similar with part1.
%here-explan with beginning local max-find upper starting envelope
%the end process procedure-find out the neighbor 2 local extrema value
%connect those 2 local extrema and extend the line to the end
%make judgement with 1).line extend value  2).original data value
%the bigger value is chosen for upper envelope end control point

%local max 
spmin(1,1) = 1;
spmin(1,2) = in_data(1);
jj=2;
kk=2;
while jj<dsize,
    if ( in_data(jj-1)>=in_data(jj) & in_data(jj)<=in_data(jj+1))
        spmin(kk,1) = jj;
        spmin(kk,2) = in_data (jj);
        kk = kk+1;
    end
    jj=jj+1;
end


%local min
spmin(kk,1)=dsize;
spmin(kk,2)=in_data(dsize);

if kk>=4
    slope1=(spmin(2,2)-spmin(3,2))/(spmin(2,1)-spmin(3,1));
    tmp1=slope1*(spmin(1,1)-spmin(2,1))+spmin(2,2);
    if tmp1<spmin(1,2)
        spmin(1,2)=tmp1;
    end

    slope2=(spmin(kk-1,2)-spmin(kk-2,2))/(spmin(kk-1,1)-spmin(kk-2,1));
    tmp2=slope2*(spmin(kk,1)-spmin(kk-1,1))+spmin(kk-1,2);
    if tmp2<spmin(kk,2)
        spmin(kk,2)=tmp2;
    end
else
    flag=-1;
end

flag=1;