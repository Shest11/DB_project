do $$
declare
	p1 four_points;
	p2 four_points;
	y1 numeric(6, 2);
	y2 numeric(6, 2);
begin
	p1 := get_my_points(23);
	p2 := get_my_points(25);

	y1 := calc_interpolation(23, p1);
	y2 := calc_interpolation(25, p2);

	raise notice 'T=23 => y=%', y1;
	raise notice 'T=25 => y=%', y2;

end $$;