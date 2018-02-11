function [Levels] = nadav_createOnsetsList(Levels)

%%RISK
trialLength=2;
mean_iti= 3;
min_iti= 2;
max_iti= 10;
numOfEvants= length(Levels.risk(1).effort);
runs=4;

for RuN=1:runs
    
    ITI_vec= [];
    inD=1;
    
    
    tmp=exprnd(mean_iti); % draw random number from a exponential distribution with a mean of mean_iti
    tmp=tmp-mod(tmp,1); % round to nearest interval
    while tmp < min_iti || tmp > max_iti % draw until it is between min and
        tmp=exprnd(mean_iti);
        tmp=tmp-mod(tmp,1); % round to nearest interval
    end;
    
    ITI_vec(inD)=tmp;
    inD=inD+1;
    
    while length(ITI_vec)<numOfEvants
        
        
        tmp=exprnd(mean_iti);
        tmp=tmp-mod(tmp,1); % round to nearest interval
        
        if mean(ITI_vec)<mean_iti % balance up
            while tmp < min_iti || tmp > max_iti || tmp <mean_iti
                tmp=exprnd(mean_iti);
                tmp=tmp-mod(tmp,1); % round to nearest interval
            end;
            
            ITI_vec(inD)=tmp;
            inD=inD+1;
            
        elseif mean(ITI_vec)>mean_iti % balance down
            
            while tmp < min_iti || tmp > max_iti || tmp >mean_iti
                tmp=exprnd(mean_iti);
                tmp=tmp-mod(tmp,1); % round to nearest interval
            end;
            
            ITI_vec(inD)=tmp;
            inD=inD+1;
            
        else
            tmp=exprnd(mean_iti);
            tmp=tmp-mod(tmp,1); % round to nearest interval
            while tmp < min_iti || tmp > max_iti
                tmp=exprnd(mean_iti);
                tmp=tmp-mod(tmp,1); % round to nearest interval
            end;
            
            ITI_vec(inD)=tmp;
            inD=inD+1;
            
            
        end
        
        
    end
    
    % correct to mean
    
    
    while mean(ITI_vec)~=mean_iti
        inD= randi([1 numOfEvants],1,1) ;
        
        if mean(ITI_vec)<mean_iti && ITI_vec (inD)< max_iti% correct up
            
            ITI_vec (inD)=ITI_vec (inD)+1;
            
        elseif mean(ITI_vec)>mean_iti && ITI_vec (inD)>min_iti % correct down
            
            ITI_vec (inD)=ITI_vec (inD)-1;
        end
    end
    
    Bin_Risk_ITI_vec(RuN,:)= ITI_vec;
    
end


%% onsets

for RuN=1:runs
    Levels.risk(RuN).onsets(1)=2;

    for hu=2:length(Bin_Risk_ITI_vec)
        
        Levels.risk(RuN).onsets(hu) =  Bin_Risk_ITI_vec(RuN,hu) + Levels.risk(RuN).onsets(hu-1)+trialLength;
        
    end
end



%end

%% Effort sensitivity
trialLength=2;
mean_iti= 3;
min_iti= 2;
max_iti= 10;
numOfEvants= length(Levels.gain(1).effort);
runs=4;

for RuN=1:runs
    
    ITI_vec= [];
    inD=1;
    
    
    tmp=exprnd(mean_iti); % draw random number from a exponential distribution with a mean of mean_iti
    tmp=tmp-mod(tmp,1); % round to nearest interval
    while tmp < min_iti || tmp > max_iti % draw until it is between min and
        tmp=exprnd(mean_iti);
        tmp=tmp-mod(tmp,1); % round to nearest interval
    end;
    
    ITI_vec(inD)=tmp;
    inD=inD+1;
    
    while length(ITI_vec)<numOfEvants
        
        
        tmp=exprnd(mean_iti);
        tmp=tmp-mod(tmp,1); % round to nearest interval
        
        if mean(ITI_vec)<mean_iti % balance up
            while tmp < min_iti || tmp > max_iti || tmp <mean_iti
                tmp=exprnd(mean_iti);
                tmp=tmp-mod(tmp,1); % round to nearest interval
            end;
            
            ITI_vec(inD)=tmp;
            inD=inD+1;
            
        elseif mean(ITI_vec)>mean_iti % balance down
            
            while tmp < min_iti || tmp > max_iti || tmp >mean_iti
                tmp=exprnd(mean_iti);
                tmp=tmp-mod(tmp,1); % round to nearest interval
            end;
            
            ITI_vec(inD)=tmp;
            inD=inD+1;
            
        else
            tmp=exprnd(mean_iti);
            tmp=tmp-mod(tmp,1); % round to nearest interval
            while tmp < min_iti || tmp > max_iti
                tmp=exprnd(mean_iti);
                tmp=tmp-mod(tmp,1); % round to nearest interval
            end;
            
            ITI_vec(inD)=tmp;
            inD=inD+1;
            
            
        end
        
        
    end
    
    % correct to mean
    
    
    while mean(ITI_vec)~=mean_iti
        inD= randi([1 numOfEvants],1,1) ;
        
        if mean(ITI_vec)<mean_iti && ITI_vec (inD)< max_iti% correct up
            
            ITI_vec (inD)=ITI_vec (inD)+1;
            
        elseif mean(ITI_vec)>mean_iti && ITI_vec (inD)>min_iti % correct down
            
            ITI_vec (inD)=ITI_vec (inD)-1;
        end
    end
    
    Bin_EffSen_ITI_vec(RuN,:)= ITI_vec;
    
end


%% onsets

for RuN=1:runs
    Levels.gain(RuN).onsets(1)=2;

    for hu=2:length(Bin_EffSen_ITI_vec)
        
        Levels.gain(RuN).onsets(hu) =  Bin_EffSen_ITI_vec(RuN,hu) + Levels.gain(RuN).onsets(hu-1)+trialLength;
        
    end
end



%end