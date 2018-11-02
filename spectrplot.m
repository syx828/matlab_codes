function spectrplot(Xt,varargin)
fs=2*pi;
plottype='b';
option='dB';
switch nargin
    case 2
        if isnumeric(varargin{1})
            if length(varargin{1})==1
                fs=varargin{1};
            else
                error('sampling rate can"t be an array');
            end
        elseif ischar(varargin{1})
            if strcmpi(varargin{1},'db')||strcmpi(varargin{1},'linear')||strcpmi(varargin{1},'linearphase')
                option = varargin{1};
            else
                plottype=varargin{1};
            end
        else
            error('wrong argument type');
        end
    case 3
        if isnumeric(varargin{1})
            if length(varargin{1})==1
                fs=varargin{1};
            else
                error('sampling rate can"t be an array');
            end
            if ischar(varargin{2})
                if strcmpi(varargin{2},'db') || strcmpi(varargin{2},'linear')||strcmpi(varargin{2},'linearphase')
                    option=varargin{2};
                else
                    plottype=varargin{2};
                end
            else
                error('plot option or plot type must be a char or string');
            end
        elseif ischar(varargin{1})
            if strcmpi(varargin{1},'db')||strcmpi(varargin{1},'linear')||strcpmi(varargin{1},'linearphase')
                option=varargin{1};
                if ischar(varargin{2})
                    plottype=varargin{2};
                else
                    error('plot type must be a char or string');
                end
            elseif strcmpi(varargin{2},'db')||strcmpi(varargin{2},'linear')||strcpmi(varargin{2},'linearphase')
                plottype = varargin{1};option=varargin{2};
            else
                error('plot option must be "dB" or "linear" or "linearphase"');
            end
        else
            error('wrong argument type');
        end
    case 4
        if isnumeric(varargin{1})
            if length(varargin{1})==1
                fs = varargin{1};
            else
                error('sampling rate can"t be an array');
            end
        else
            error('sampling rate must be a num');
        end
        if ischar(varargin{2})
            if strcmpi(varargin{2},'db')||strcmpi(varargin{2},'linear')||strcpmi(varargin{2},'linearphase')
                option=varargin{2};
                if ischar(varargin{3})
                    plottype=varargin{3};
                else
                    error('plot type must be a char or string');
                end
            elseif strcmpi(varargin{3},'db')||strcmpi(varargin{3},'linear')||strcpmi(varargin{3},'linearphase')
                plottype=varargin{2};option=varargin{3};
            else
                error('plot option must be "dB" or "linear" or "linearphase"');
            end
        end
end
L=length(Xt);
f=((0:L-1)-(L-mod(L,2))/2)/L*fs;
Xf=abs(fftshift(fft(Xt)/sqrt(L)));
switch lower(option)
    case 'db'
        plot(f,20*log10(Xf),plottype);
        axis([f(1),f(end),20*log10(min(Xf))-10,20*log10(max(Xf))+10]);
        ylabel('dB');
        xlabel('Hz');
    case 'linear'
        plot(f,Xf,plottype);
        axis([f(1),f(end),min(Xf)-(max(Xf)-min(Xf))/10,max(Xf)+(max(Xf)-min(Xf))/10]);
        ylabel('Attitude');
        xlabel('Hz');
    case 'linearphase'
        Xf = fft(Xt)/sqrt(L);
        absXf = abs(Xf);
        angleXf = angle(Xf)/pi;
        delta = 0;reverseFlag = 1;temp = angleXf(1);
        for i = 2:ceil(length(angleXf)/2)
            if angleXf(i)>temp
                delta = delta - 1;
                reverseFlag = -reverseFlag;
            end
            temp = angleXf(i);
            absXf(i) = absXf(i)*reverseFlag;
            angleXf(i) = angleXf(i)+delta;
        end
        delta = 0;reverseFlag = 1;temp = angleXf(1);
        for i = length(angleXf)-1:-1:ceil(length(angleXf)/2)+1
            if angleXf(i)<temp
                delta = delta + 1;
                reverseFlag = -reverseFlag;
            end
            temp = angleXf(i);
            absXf(i) = absXf(i)*reverseFlag;
            angleXf(i) = angleXf(i)+delta;
        end
        absXf = fftshift(absXf);
        angleXf = fftshift(angleXf);
        subplot(3,1,1);plot(f,absXf,plottype);grid on;
        axis([f(1),f(end),min(absXf)-(max(absXf)-min(absXf))/10,max(absXf)+(max(absXf)-min(absXf))/10]);
        xlabel('Hz');ylabel('Attitude');
        angleXf = angleXf*pi;
        subplot(3,1,2);plot(f,angleXf,plottype);grid on;
        axis([f(1),f(end),min(angleXf)-(max(angleXf)-min(angleXf))/10,max(angleXf)+(max(angleXf)-min(angleXf))/10]);
        xlabel('Hz');ylabel('anlge(¦Ð)');
        
        GroupDelay = -(angleXf(2:end) - angleXf(1:end-1))/(2*pi*fs/L);
        GroupDelay = (GroupDelay(1:end-1)+GroupDelay(2:end))/2;
        GroupDelay = [0,GroupDelay,0];
        ax = subplot(3,1,3);
        [haxes,~,~] = plotyy(f,GroupDelay,f,round(GroupDelay*fs),'stem','stem');grid on;
        axes(haxes(1));ylabel('time(s)')
        axes(haxes(2));ylabel('point')
        xlabel('Hz');
end
grid on;
end
                
                
                