do $$
begin
    call public.proc_calc_meteo_by_heights(
        row('ДМК', 100, 25.0, 765, 15, 6, 0)::public.param_list
    );
end $$;

select * from temp_meteo_out;