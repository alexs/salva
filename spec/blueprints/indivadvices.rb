Indivadvice.blueprint do
  indivname { Forgery(:name).full_name }
  institution_id { Institution.make!.id }
  startyear { rand(2000..2025) }
  startmonth { rand(1..12) }
  endyear { rand(2025..2030) }
  endmonth { rand(1..12) }
  hours { rand(20..480) }
  indivadvicetarget_id { rand(1..3) }
  university_id { Institución.make!.id }
  country_id { Country.make!.id }
  degree_id { Degree.make!.id }
  career_id { Career.make!.id }
  registered_by_id { User.make!.id }
  user_id { User.make!.id }
  status_id { [0, 1, 2].sample }
end
