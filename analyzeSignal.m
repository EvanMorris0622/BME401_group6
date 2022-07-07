function analyzeSignal(src,evt)
%     global scans_acquired
%     global samplingR
%     global threshold
%     global raw_data
%     global sampled_data
%     global alreadyQueued
%     global sampling_count
%     global sample_start
%     global task_completion
% %     global plotgraph
% %     global x 
% %     global y
%     global th 
% 
%     r = sqrt((((evt.Data(1,1))-2.5).^2 + ((evt.Data(1,2))-2.5).^2));
%     disp('Radius: ' + string(r))
% %     avg_ext = mean(r)- sqrt(2.6^2 + 2.8^2);
% 
%     if(sampling_count == src.Rate/samplingR)
%         sampling_count = 0; 
%         alreadyQueued = false; 
%     end 
% 
% %     disp(avg_ext)
%     disp(['Sampling Counter: ' num2str(sampling_count)])
%     
%     
% %     if(avg_ext<=threshold || avg_ext>=2.6-threshold)
%     if(r>=threshold)
%         task_completion = true;
%     else
%         task_completion = false;
%     end
% 
%     temp_trigger = zeros(samplingR,1);
% 
%     switch(task_completion)
%         case true
%             disp('Successful Scan')
%             switch(alreadyQueued)
%                 case true
%                     disp('Already Queued')
%                     %do nothing
% 
%                 case false
%                     disp('Not Already Queued')
%                     alreadyQueued = true;    
%             end
% 
%         case false
%             %do nothing    
%             disp('Unsuccessful Scan')
%             temp_trigger(1:samplingR) = 0;
%     end
%             
%             
%     
%         sampling_count = sampling_count + 1; 
%         
%         raw_data = cat(1,raw_data, cat(2,evt.TimeStamps, evt.Data(:,1),evt.Data(:,2),temp_trigger,temp_trigger, evt.Data(:,3)));
%         
%         if(~sample_start)
% %             sampled_data = cat(2,evt.TimeStamps(1),mean(evt.Data(:,1)),mean(evt.Data(:,2)),r,task_completion);
%             sampled_data = cat(2,evt.TimeStamps(1),evt.Data(1,1),evt.Data(1,2),r,task_completion,evt.Data(1,3));
% 
%             sample_start = true;
%         else
%             sampled_data = cat(1,sampled_data, cat(2,evt.TimeStamps(1),evt.Data(1,1),evt.Data(1,2),r,temp_trigger(1),task_completion));
%         end
% 
%         %%%Update Plot 
% %         set(acqGui.LivePlot, 'XData', evt.Data(end,1), ...
% %                              'YData', evt.Data(end,2)); refresh 
% %         
% %         set(plotgraph, 'XData', evt.Data(1,1), ...
% %                      'YData', evt.Data(1,2)); 
% %         x = evt.Data(1,1); 
% %         y = evt.Data(1,2); 
%         
% %         refreshdata(plotgraph)
% %         drawnow 
%         
%         plot(evt.Data(1,1),evt.Data(1,2),'b.','MarkerSize', 16);
%         hold on 
%         plot(threshold*cos(th)+2.5, threshold*sin(th)+2.5)
%         title(plotTitle, 'FontSize', 15); 
%         xlabel(xLabel, 'FontSize', 15);
%         ylabel(yLabel, 'FontSize', 15);
%         axis([0 5 0 5]);
%         hold off
% 
%         user = memory; 
%         
%         disp('Scans Acquired: ' + string(scans_acquired));
%         
%         disp('Memory Used: ' + string((user.MemUsedMATLAB/user.MaxPossibleArrayBytes)*100)); 
%         disp('------------')
%         scans_acquired = scans_acquired + 1; 
%         
        %% Rewriting
        global raw_data
        global page 
        r = sqrt((((evt.Data(1,1))-2.5).^2 + ((evt.Data(1,2))-2.5).^2));
        
        raw_data(:,:,page) = [evt.Timestamps evt.Data(:,1:2) r evt.Data(:,3)]; %timestamps, X, Y, calculated radii, imaging stimulus pulse train 
        page = page+1; 
        
%         
end