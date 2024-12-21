%% Programmed By Bhoj Raj Thapa 
% For Final Year Project of Biomedical Signal Processing

%% Reading EEG Data and declaring global variables
clear; close all;
rawData = load('A01T.mat').data;
channelWeFocus = [4,8,10,12,]; % 4--> Fcz;8-->c3;10-->cz;12-->c4 based on 10-20 system
channelNames = ["FCz";"C3";"Cz";"C4"];
fs = 250;
%% Extracting EEG for focused channels
for runi = 4:size(rawData,2)
    varEEG4D = ['EEG4DRun',num2str(runi)];
    eegPerRunTemp = rawData{1,runi}.X;
    eegPerRun= eegPerRunTemp(:,channelWeFocus)';
    trialIndex = rawData{1,runi}.trial;
    classID = rawData{1,runi}.y;
    uniqueClassID = unique(classID);
    for classi = 1:size(uniqueClassID,1)
        classIndex(classi,:) = find(classID==uniqueClassID(classi));
    end
    classes = (rawData{1,runi}.classes)';
    for tri = 1:size(trialIndex,1)
        EEG4DTemp = eegPerRun(:,trialIndex(tri,1)+2*fs:trialIndex(tri,1)+6*fs-1);
        classIDtemp = classID(tri,1);
        classIDfor4D = find(classIndex(classIDtemp,:) == tri);
        for chi = 1:size(EEG4DTemp,1)
            % EEG4D (classes,Channels,EEGData,Trials)
            EEG4D(classIDtemp,chi,:,classIDfor4D)= EEG4DTemp(chi,:);
        end
        
    end
    
end

%% Preprocessing the EEG Data for First run
%% EEG Plot
for classi = 1:size(EEG4D,1)
    for trli = 1%:size(EEG4D,4)
        ColorCode = ['r','g','b','c'];
        taxis = 2+1/fs*(0:999);
        fig1 = figure()
        for chi = 1:size(EEG4D,2)
            EEGtoPlot(1,:) = EEG4D(classi,chi,:,trli);
            subplot(4,1,chi);plot(taxis,EEGtoPlot(1,:),'Color','b');
            title(['Channel: ' convertStringsToChars(channelNames(chi))])
        end
        han1=axes(fig1,'visible','off');
        han1.Title.Visible='on';
        han1.XLabel.Visible='on';
        han1.YLabel.Visible='on';
        ylabel(han1,'Amplitude (uV)','FontSize',15);
        xlabel(han1,'Time(seconds','FontSize',15);
        sgtitle(['EEG Plot of ' classes{classi,1} ' Movement Imagery | Trial No.: ' num2str(classIndex(classi,trli)) '(of 48)']);
%         legend(channelNames);
    end
end

%% Average Event Related Potential
for classi = 1:size(EEG4D,1)
    for chi = 1:size(EEG4D,2)
        averageERPTemp = zeros(1,1000);
        for trli = 1:size(EEG4D,4)
            EEGToAverage(1,:) = EEG4D(classi,chi,:,trli);
            averageERPTemp = averageERPTemp + EEGToAverage;
        end
        averageERP(classi,:,chi) = averageERPTemp/size(EEG4D,4);
    end
end
%% EEG Plots of Average ERPP
for chi = 1%: size(AverageERP,3)
    fig2 = figure()
    for classi = 1:size(averageERP,1)
        subplot(4,1,classi);
        plot(taxis,averageERP(classi,:,chi)); hold on;
        title(['For ',classes{classi,1} ' movement']);
    end
    han2=axes(fig2,'visible','off');
    han2.Title.Visible='on';
    han2.XLabel.Visible='on';
    han2.YLabel.Visible='on';
    ylabel(han2,'Amplitude (uV)','FontSize',15);
    xlabel(han2,'Time(seconds','FontSize',15);
    sgtitle(['Average ERP(EEG) before filtering for channel:',convertStringsToChars(channelNames(chi))]);
end
%% FFT Plots of Average ERP
for chi =1%
    fig3 = figure();
    for classi = 1:size(averageERP,1)
        
        %         for chi = 1%:size(AverageERP,3)
        %             EEGtoFFTPlot(1,:) = AverageERP(classi,:,chi);            %FFTPlot
        [onesided,fonesided,shifted,fshifted] = get_fft_for_even(averageERP(classi,:,chi),fs);
        
        %             figure();
        subplot(4,1, classi);
        plot(fonesided,onesided,'Color','b'); hold on;
%         xlim([-1 130]);
%         ylim([-0.1 max(onesided)+ 1]);
        title(['For ',classes{classi,1} ' movement']);
        
        
        %             figure();
        %             plot(fshifted,shifted,'Color','b');
        %             xlabel('Frequency(Hz)');
        %             ylabel('Magnitude');
        %             xlim([-130 130]);
        %             ylim([-0.1 1.7]);
        %             title(['Shifted FFT of ' classes{classi,1} ' Movement Imagery | Channel: ' convertStringsToChars(channelNames(chi,1))  ' | Trial No.: ' num2str(classIndex(classi,trli))],'FontSize',15);
        
    end
    han3=axes(fig3,'visible','off');
    han3.Title.Visible='on';
    han3.XLabel.Visible='on';
    han3.YLabel.Visible='on';
    ylabel(han3,'FFT Magnitude','FontSize',15);
    xlabel(han3,'Frequency (Hz)','FontSize',15);
    axis tight
            sgtitle(['Positive Half of FFT of average ERP before filtering for Channel: ' convertStringsToChars(channelNames(chi,1))],'FontSize',15);
end
%% Low Pass Filtering of Average ERP 
bpFilt = designfilt('bandpassiir','FilterOrder',12, ...
    'HalfPowerFrequency1',0.1,'HalfPowerFrequency2',10, ...
    'SampleRate',fs);

lpFilt = designfilt('lowpassiir','FilterOrder',8, ...
    'PassbandFrequency',12,'PassbandRipple',0.2, ...
    'SampleRate',fs);
% fvtool(lpFilt)
for chi = 1: size(averageERP,3)
%     figure()
    for classi = 1:size(averageERP,1)
        averageERPFiltered(classi,:,chi) = filtfilt(lpFilt,averageERP(classi,:,chi));
    end
end

%% Plotting before and after filtering together
% for chi = 1%: size(averageERP,3)
% %     figure()
%     for classi = 1:size(averageERP,1)
%         figure();
%         subplot(2,1,1);plot(taxis,averageERP(classi,:,chi)); 
%         title('average ERP(EEG) before Filtering');
%         subplot(2,1,2);plot(taxis,averageERPFiltered(classi,:,chi));
%         ylim([-20 20]);
%         title('average ERP(EEG) after Filtering');
%         sgtitle(['Class:' classes{classi,1}]);
%     end
% end
for chi = 1%: size(AverageERP,3)
    fig4 = figure()
    for classi = 1:size(averageERP,1)
        subplot(4,1,classi);
        plot(taxis,averageERPFiltered(classi,:,chi),'Color','b'); hold on;
        ylim([-20 20]);
        title(['For ',classes{classi,1} ' movement']);
    end
    han4=axes(fig4,'visible','off');
    han4.Title.Visible='on';
    han4.XLabel.Visible='on';
    han4.YLabel.Visible='on';
    ylabel(han4,'Amplitude (uV)','FontSize',15);
    xlabel(han4,'Time(seconds','FontSize',15);
    sgtitle(['Average ERP after filtering for channel:',convertStringsToChars(channelNames(chi))]);
end
%% FFT Value Calculated of Average ERP
for classi = 1:size(averageERPFiltered,1)
        for chi = 1:size(averageERPFiltered,3)
            [onesided,fonesided,shifted,fshifted] = get_fft_for_even(averageERPFiltered(classi,:,chi),fs);
            fftOfERPafterFiltering(classi,:,chi) = onesided;
        end
end
%% FFT Plots
for classi = 1:size(averageERPFiltered,1)
        for chi = 1%:size(averageERPFiltered,3)
%             EEGtoFFTPlot(1,:) = AverageERP(classi,:,chi);            %FFTPlot
            [onesided,fonesided,shifted,fshifted] = get_fft_for_even(averageERPFiltered(classi,:,chi),fs);
            figure();
            plot(fonesided,onesided,'Color','b');
            xlabel('Frequency(Hz)');
            ylabel('Magnitude');
            xlim([-1 15]);
            ylim([-0.1 max(onesided)+ 1]);
            title(['Positive Half of FFT of ' classes{classi,1} ' Movement Imagery | Channel: ' convertStringsToChars(channelNames(chi,1))  ' | Trial No.: ' num2str(classIndex(classi,trli)) '(of 48)'],'FontSize',10);
            
            
%             figure();
%             plot(fshifted,shifted,'Color','b');
%             xlabel('Frequency(Hz)');
%             ylabel('Magnitude');
%             xlim([-130 130]);
%             ylim([-0.1 1.7]);
%             title(['Shifted FFT of ' classes{classi,1} ' Movement Imagery | Channel: ' convertStringsToChars(channelNames(chi,1))  ' | Trial No.: ' num2str(classIndex(classi,trli))],'FontSize',15);
   
        end
end
%% Spectrogram Plots Of ERP
for chi = 1%: size(AverageERP,3)
    figure()
    for classi = 1:size(averageERP,1)
        [s, f, t, psd] = spectrogram(averageERPFiltered(classi,:,chi),125,100,250,fs, 'psd');
        t = t+2;
        psdlimited = psd(1:50,:);
        flimited = f(1:50,:);
        
        subplot(2,2,classi);surf(t, flimited, psdlimited, 'EdgeColor', 'none');
        axis xy;
        axis tight;
        colormap(jet); view(0,90);
        xlabel('Time(s)','FontSize',15);
        colorbar;
        ylabel('Frequency(HZ)','FontSize',15);
        title(['For ' classes{classi,1} ' movement imagery'   ],'FontSize',15);
        %         figure()
        %         subplot(2,1,1);spectrogram(averageERP(classi,:,chi),125,100,250,fs,'yaxis');
        %         subplot(2,1,2);spectrogram(averageERPFiltered(classi,:,chi),125,100,250,fs,'yaxis');
%         sgtitle(classes(classi));
    end
    sgtitle(['Spectrogram for Channel: ' convertStringsToChars(channelNames(chi,1))]);
end
%% FFT Value Integration around 3,4,5,6,7,8
deltaf = fs/size(averageERPFiltered,2);
fcomp = [1;3;4;7;8;12];
for i = 1:size(fcomp,1)
pointsToIntegrate(i,1) = find(fonesided==fcomp(i));
end

for chi=1:size(fftOfERPafterFiltering,3)
    for classi = 1:size(fftOfERPafterFiltering,1)
        for pi = 1:2:size(fcomp,1)
        powerSpectralTemp = sum(((fftOfERPafterFiltering(classi,pointsToIntegrate(pi):pointsToIntegrate(pi+1),chi))).^2);
        powerSpectral(classi,(pi+1)/2,chi) = powerSpectralTemp;
        end
    end
end

%% Plotting the power
for chi=1:size(fftOfERPafterFiltering,3)
    colorCode = ['r','g','b','c'];
    figure();
    for classi = 1:size(fftOfERPafterFiltering,1)
        forBarPlot = powerSpectral(classi,:,chi);
        plot(forBarPlot,'Color',colorCode(classi),'LineStyle','--','MarkerSize',12,'Marker','s','MarkerFaceColor',colorCode(classi));hold on;
    end
    title(['Power in Three Frequency Bands for Channel:',convertStringsToChars(channelNames(chi,1))],'FontSize',15);
    xlim([0.8 3.2])
    legend([convertStringsToChars(classes)],'FontSize',15)
    ylabel('Power','FontSize',20);
    xticks([1 2 3])
    xticklabels({'Delta Band (1-3 Hz)','Theta Band (4-7 Hz)','Alpha Band (8-12 Hz)'})
    
end
