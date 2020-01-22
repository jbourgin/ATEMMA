% From names containing numbers, this function returns only the numbers in a list.
function [ListToReturn] = getNumInStr(List)
% ListToReturn -> List (of doubles).
% List -> Cell (of chars).

ListToReturn = [];

for elt = 1:length(List)
	name = List{elt};
    name(regexp(name,'[.png]'))=[];
    numName = regexp(name,'\d*','Match');
	ListToReturn = [ListToReturn,str2double(numName)];
end
end