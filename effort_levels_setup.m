% Creating difficulty levels vector.
effort_levels = 10:40:90; % Precent from mvc
effort_req = zeros(1,length(effort_levels));
for i=1:length(effort_levels)
    % The 'help' each image gets (low difficulty iamges would move up
    % easyer)
    effort_req(i) = inv(effort_levels(i)/100);
end
effort_req = repmat(effort_req,9,1); %count_effort_1

% For randomizing the fractals and difficulty order each run
RAnd_demoFRACT=randperm(length(demo_Images));

% For randomizing the fractals and difficulty order each run
RAndFRACT=randperm(27); %length(Practice_Images)); %effort_stim_num

save ([pwd '/Output/' subjectID '_pre_Grip_Practice_Demo'])
