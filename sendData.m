function sendData(src,evt,data, on, off, stop, threshold)
% %     global on_state_pulse
% %     global off_state_pulse
% %     global stop_state_pulse
%     global alreadyQueued
%     global reward_counter
%     global running
%     global reward_length
%     global trial_time
%     global stop_bool
%     global time
%     global refractory_period
%     global rperiod_count
%     global refractory_periodL
%     
%     
%     disp('Time Elapsed: ' + string(time))
% 
%     if(reward_counter == reward_length)
%         disp('Enter reward = reward length')
%         running = false; 
%         reward_counter = 0; 
%         refractory_period = true; 
%     end
% 
%     disp(['Reward Counter: ' num2str(reward_counter)])
% 
%     switch(refractory_period) 
%         case true 
%             rperiod_count = rperiod_count+1;
%             if (rperiod_count == refractory_periodL)
%                 refractory_period = false;
%                 rperiod_count = 0;
%             end
%         case false 
%             switch(running)
%                 case true
%                     disp('On')
%                     if(time == trial_time)
%                         src.queueOutputData(stop_state_pulse);
%                         disp('Stop Trigger Sent')
%         %                 flush(s)
%                         stop_bool = true;
%                     else
%                         src.queueOutputData(on_state_pulse);
%                         reward_counter = reward_counter + 1;
%                     end
% 
% 
%                 case false
%                     switch(alreadyQueued)
%                         case true
%                         if(time == trial_time)
%                             src.queueOutputData(stop_state_pulse);
%                             disp('Stop Trigger Sent')
%         %                     flush(s)
%                             stop_bool = true;
%                         else
%                             disp('On')
%                             running = true;
%                             src.queueOutputData(on_state_pulse);  
%                             reward_counter = reward_counter + 1;
%                         end
% 
%                         case false
%                             disp('Off')
%                             src.queueOutputData(off_state_pulse)
%                     end
%             end
%     end
%     disp('________________________');
%     time = time+1;

%% Rewriting 
    global page 
    
    buffer = data(:,:,page-3:page); 
    ave = mean(buffer(:,3,:));
    
    switch(ave) 
        case ave>threshold
            src.queueOutputData(on)
            disp('Above')
        case ave<threshold
            src.queueOutputData(off)
            disp('Below')
    end

end
