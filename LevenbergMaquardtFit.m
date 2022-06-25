function [x, k] = LevenbergMaquardtFit(model, x0, t, Exp, tol, plthandle)
f = model(x0, t) - Exp;
F = 0.5*(f'*f);
kmax = 1000; 
k = 1; x = x0; v = 2; tau = 1;
J = Jacobian(@(x)model(x,t), x);  
A = J'*J;
I = eye(numel(x0));
mu = tau*max(abs(diag(A)));
g = J'*f;
found = norm(g) < tol;
 while(~found && k < kmax)
     k = k + 1;
     hlm = -(A + mu*I)\g;
     if(norm(hlm) < tol*(norm(x) + tol))
         found = true;
     else
         xnew = x + hlm;
         Jnew = Jacobian(@(x)model(x,t), xnew);
         fnew = model(xnew, t) - Exp;
         Anew = Jnew'*Jnew; gnew = Jnew'*fnew;
         Fnew = 0.5*(fnew'*fnew);
         L0mLhm = 0.5*hlm'*(mu*hlm - gnew);
         rho = (F - Fnew)/L0mLhm;
         if(rho > 0)
             x = xnew; F = Fnew;
             A = Anew; g = gnew;
             found = norm(g) < tol;
             mu = mu*max(1/3, 1-(2*rho - 1)^3);
         else
             mu = mu*v; v = 2*v;
         end
     end
%      disp(['iter = ',num2str(k)]);
%      disp(x)
     if(~isempty(plthandle))
         plthandle(x);
     end
 end