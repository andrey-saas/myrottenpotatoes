
Given /the following movies exist/ do |movies_table|  
  movies_table.hashes.each do |movie|
    Movie.create!(movie) 
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert_match(/#{e1}.*#{e2}/m, page.body)
end

Then /the director of "(.*)" should be "(.*)"$/ do |movie, director|
  step %Q{I should see "Details about #{movie}" before "#{director}"}
end

When /I (un)?check the following ratings?: (.*)/ do |uncheck, rating_list|
  rating_list.scan(/[a-z0-9\-]+/i).each do |rating|
    if uncheck then
      step %Q{I uncheck "ratings[#{rating}]"}
    else
      step %Q{I check "ratings[#{rating}]"}
    end    
  end  
end

Then /I should see all of the movies/ do
  Movie.all.each do |movie|
    step %Q{I should see "#{movie.title}"}
  end  
end

Then /I should see neither of the movies/ do
  Movie.all.each do |movie|
    step %Q{I should not see "#{movie.title}"}
  end  
end
