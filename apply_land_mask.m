function [ mascon_brick_masked ] = ...
    apply_land_mask( mascon_brick, land_mask)
%apply_land_mask: Applies GRACE land mask, and converts ocean values to
%NaNs

tps = size(mascon_brick,3);

mascon_brick_masked = mascon_brick .* repmat(land_mask, 1, 1, tps);
mascon_brick_masked(mascon_brick_masked==0) = NaN;

end

