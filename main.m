targetSize=[128,128];
location = fullfile('lfw');

imds = imageDatastore(location,'IncludeSubfolders',true,'LabelSource','foldernames',...
                      'ReadFcn', @(filename)imresize(im2gray(imread(filename)),targetSize));
%montage(preview(imds));
A=readall(imds);

% Play faces
if false
    for j=1:length(A)
        imshow(A{j}),title(imds.Labels(j),'Interpreter','none');
        pause(1);
    end
end

B=cat(3,A{:});
imshow(B(:,:,1))
D=prod(targetSize);
B=reshape(B,D,[]);

disp('Normalizing data...');
B=single(B)./256;
[N,C,SD] = normalize(B);

disp('Finding SVD...');
tic;
[U,S,V]=svd(N,'econ');
toc;

for j=1:size(U,2)
    imagesc(reshape(U(:,j),targetSize));
    title([num2str(j),': ',num2str(S(j,j))]);
    pause(1);
end

% N = U*S*V';
k=80;Z=U(:,1:k)*S(1:k,1:k)*V(:,1:k)';

for j=1:size(Z,2)
    imagesc(reshape(Z(:,j),targetSize));
    title(imds.Labels(j),'Interpreter','none');
    pause(0.4);
end
