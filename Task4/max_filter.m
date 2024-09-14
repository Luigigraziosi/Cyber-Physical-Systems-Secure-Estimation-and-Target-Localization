function out = max_filter(in, times, flag)
    out = in;

    for i=1:length(in)
        count = 0;
        for j=1:length(in)
            if flag == 1
                if (abs(in(i))<abs(in(j)))
                  count = count+1;
                end
            else
                if (in(i)<in(j))
                  count = count+1;
                end
            end
        end
        if (count>=times)
            out(i) = 0;
        end
    end
end