function inorm = img_norm(img)
s = size(img, 3);
if (s == 1)
    inorm = norm(img, "fro");
else
    % s == 3 - color image
    e1 = norm(img(:,:,1), "fro");
    e2 = norm(img(:,:,2), "fro");
    e3 = norm(img(:,:,3), "fro");
    inorm = 1.0/3.0 * (e1 + e2 + e3);
end

end
