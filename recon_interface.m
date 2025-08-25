%{
msh-MOLED parallel reconstruction
qzyang, Xiamen University
%}

clear;

pathfile = '';    % input your file path
dataname = ''; % input your data name
pathsave = '';  % input your save path

id_recon  = ;   % the slices need to be reconstructed
tot_slice = ; % the total slice

flag_save = true;
snav      = 2; % 1 or 2, the direction of  three-line navigator

Necho     = 1; % for single-train

% data loading
[ksp, ksp_PC, Nread, Nphase, Nslice, Ncoil, NETL, Nseg, FOVread, FOVphase] = mshMOLED_reader(fullfile(pathfile, dataname));

if ~le(Nslice, tot_slice)
    aa      = sprintf("Total slice number is %d!!!", Nslice);
    warndlg(char(aa));
end

for id_slice = id_recon
    ksp_cor      = run_mshMOLED_recon_func(ksp(:,:,:,id_slice), ksp_PC(:,:,:,id_slice), Nread, Ncoil, NETL, Nseg, Necho, snav);
    [maxt,maxid] = max(mean(ksp_cor,[1,2])); % self-navigator
    sen          = adaptive_sens_acs(ksp_cor, [FOVread/Nread, FOVphase/Nphase], maxid, 5, Nread, Nphase, Ncoil);
    complex_k2   = fft2c(adaptive_combination(ifft2c(ksp_cor),sen));
    if eq(flag_save, true)
        save(fullfile(pathsave, [dataname(6:14), 'Layer', num2str(1000+id_slice), '.mat']),'complex_k2');
        disp(['layer ', num2str(id_slice), ' saved.'])
    end
end

fclose all;