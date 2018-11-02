stirling = @(x)(sqrt(2*pi*x).*(x/exp(1)).^x);
% use stirling number to approach factorial(gamma)
x = 1:0.1:5;
S1 = stirling(x); 
S2 = gamma(x+1); % gamma function is the extension of factorial
error = (S1-S2)./S2;
figure;hold on;
hl1 = line(x,S1);set(hl1,'color','r');
hl2 = line(x,S2);set(hl2,'color','k');
ax(1) = gca;
set(ax(1),'YColor','r');
ax(2) = axes('Position',get(ax(1),'Position'),...
           'YAxisLocation','right',...
           'Color','none',...
           'YColor','b');
hl3 = line(x,error,'Parent',ax(2));
set(hl3,'color','b');
linkaxes(ax,'x');
legend('','','error')