%%%load_instructions_images
function [Instructions_struct]=load_instruction_images(Instructions_path)
i=1;
Instructions_struct = struct('name','image');
Instructions_filesNames=dir(Instructions_path);
for current_instruct=1:length(Instructions_filesNames)
    s = Instructions_filesNames(current_instruct).name;
    is_jpg=  strfind(s, 'jpg');
    if ~isempty(is_jpg)
        Instructions_struct(i).name =s;
        Instructions_struct(i).image= imread([Instructions_path '/' s ]);
        i=i+1;
    end
end
end
