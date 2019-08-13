function [ Mx,My, Radii] = Find_coord(n_begin,n_end)
%Uses function Find_coordinate. The input n_begin and
%n_end means the frame number from which to begin tracking and the frame number until which to track. 
%Makes a loop over all frames. When you run a function it will show the first frame. You should
%click at the center of the bead and somewhere on the outer side of it's border, then press enter. The function crops the
%frame series around the bead, so that the tracking would not jump to
%another bead near by. The cropping works as changing the color of
%everything around the bead to the color of background and it neads to
%imput the color of the background in the comand "image(~idx) = 74" It is
%usually done by hand but the procedure can be improved. Function is not
%always working still. Sometimes it happens that function jumps to tracking another
%bead.
%Below the function in the commented section it is shown how to save the
%result in the .dat file to use in the further calculations. For the file
%given there are some parts where the function failed and jumped to another
%bead. The values of that part in the file is changed to 'NA'
n=n_end-n_begin+1;
Mx=zeros(1,n);
My=zeros(1,n);
Radii=zeros(1,n);
for n_frame = n_begin:n_end
    image = imread(['..\Track\','6','.tif'],n_frame);
    k=n_frame-n_begin+1;
    %vis�da mud��an�s
    %rect = [0,11,279,238];
    %image=imcrop(image, rect);
    % Keep only points lying inside circle
    th = linspace(0,2*pi) ;
    [nx,ny,~] = size(image) ;
    [X,Y] = meshgrid(1:ny,1:nx) ;
    if k==1
        imshow(image) ;
        hold on
        [px,py] = getpts ;   % click at the center and approximate Radius
        hold off
        Radii(k) = sqrt(diff(px(1:2)).^2+diff(py(1:2)).^2) ;
        Mx(k)=px(1) ;
        My(k)=py(1) ;
        xc = Mx(k)+(Radii(k)+5)*cos(th) ; 
        yc = My(k)+(Radii(k)+5)*sin(th) ; 
    else
        xc = Mx(k-1)+(Radii(k)+15)*cos(th) ; 
        imshow(image)
        yc = My(k-1)+(Radii(k)+15)*sin(th) ; 
        
    end
    idx = inpolygon(X(:),Y(:),xc',yc) ;
    %plot(xc,yc,'r') ;
    image(~idx) = 74 ;
    
    %Possible to add that with the third and fourth click can ignore the
    %circle of a bead near by.
%     RadiiDel = sqrt(diff(px(3:4)).^2+diff(py(3:4)).^2) ;
%     xcDel = px(3)+(RadiiDel)*cos(th) ; 
%     ycDel = py(3)+(RadiiDel)*sin(th) ; 
%     iDel = inpolygon(X(:),Y(:),xcDel',ycDel) ;
%     image(iDel) = 105 ;
    %figure('visible', 'on')
    %imshow(image)
    [Mx(k),My(k),Radii(k),]=Find_coordinate(image);
end

%%%Example of saving data to .dat file to use in the further calculations
Rez=zeros(length(Mx),3);
Rez(:,1)=Mx;
Rez(:,2)=My;
Rez(:,3)=Radii;
csvwrite('..\Track\Data_1.dat',Rez)

% % % n_begin=6000;
% % % np=100;
% % % n=np+n_begin-1;
% % % image = imread(['..\Track\','4','.tif'],n);
% % % imshow(image);
% % % hold on
% % % plot(Mx(np),My(np), 'b*')
% My(My<26.6)=0;
% Mx(My<26.6)=0;
end
