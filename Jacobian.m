function J = Jacobian(fun, x)
f = fun(x);
J = zeros(numel(f), numel(x));
for i = 1:numel(x)
    xp = x;
    del = 1e-3*(abs(x(i)) + 1);
    xp(i) = xp(i) + del;
    fp = fun(xp);
    der = (fp - f)/del;
    J(:,i) = der;
end