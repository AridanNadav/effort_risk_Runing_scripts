% TIMEstamp
function [timestamp] = TIMEstamp()

c = clock;
hr = sprintf('%02d', c(4));
minute = sprintf('%02d', c(5));
timestamp=[date,'_',hr,'h',minute,'m'];
end