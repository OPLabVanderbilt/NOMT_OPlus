
function center_text(ptr,ctext,tcolor,yoffset,xoffset)

if nargin<2; error('%%Usage: center_text(ptr,text,[color],[yoffset],[xoffset])')
elseif nargin<3; xoffset = 0; yoffset=0; tcolor=255;
elseif nargin<4; xoffset = 0; yoffset=0; 
elseif nargin<5; xoffset = 0;
end

rect=Screen('Rect',ptr); %%size of window
sx = RectWidth(rect); %width
sy = RectHeight(rect); %height

tw=Screen('TextBounds',ptr,ctext);
Screen('DrawText',ptr,ctext,round(sx/2)-round(tw(3)/2)+xoffset,...
    round(sy/2)-round(tw(4)/2)+yoffset,tcolor);