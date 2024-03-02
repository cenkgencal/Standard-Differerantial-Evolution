% The function finds three integer values that are different each other for
% each member of the population.
function rnd_in=df_vls(n)
rnd_in=zeros(n,3);
c=1;
while c<=n
    i1=round(rand*(n-1)+1);
    i2=round(rand*(n-1)+1);
    i3=round(rand*(n-1)+1);
    if i1~=i2 && i1~=i3 && i2~=i3
        rnd_in(c,1)=i1;
        rnd_in(c,2)=i2;
        rnd_in(c,3)=i3;
        c=c+1;
    end
end