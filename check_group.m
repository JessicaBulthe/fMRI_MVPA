function [DD] = check_group(charsubject)

group = charsubject(1);

if group == 'D'
    DD = 1;
elseif group == 'C'
    DD = 0;
else
    DD = NaN;
end
