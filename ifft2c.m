function opt = ifft2c(x)

% there is another ifft2c in 'function_ccb\utils'

S = size(x);
fctr = S(1)*S(2);

x = reshape(x,S(1),S(2),prod(S(3:end)));
opt = zeros(size(x));

for n=1:size(x,3)
opt(:,:,n) = sqrt(fctr)*fftshift(ifft2(ifftshift(x(:,:,n))));
end

opt = reshape(opt,S);

