function [ mascon_brick_norm ] = normalize_grace_metric( mascon_brick )
%normalize_grace_metric: Normalizes grace mascon brick over location

tps = size(mascon_brick,3);

mean_brick = repmat( mean(mascon_brick,3), 1, 1, tps);
std_brick = repmat( std(mascon_brick,0,3), 1, 1, tps);
mascon_brick_norm = (mascon_brick - mean_brick) ./ std_brick;

end

