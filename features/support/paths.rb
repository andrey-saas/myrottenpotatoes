# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers

private

  def find_movie_by_title(title)
    movie = Movie.find_by_title(title)
    raise "Can't find movie \"#{title}\"" if movie.nil? 
    return movie
  end    

public
  
  def path_to(page_name)
    case page_name
    when /^the home\s?page$/
      "/movies"
    when /^the RottenPotatoes home\s?page$/
      "/movies"  
    when /^the edit page for "(.*)"$/ 
      "/movies/#{find_movie_by_title($1).id}/edit"
    when /^the details page for "(.*)"$/
      "/movies/#{find_movie_by_title($1).id}"              
    when /^the Similar Movies page for "(.*)"$/
      "/movies/#{find_movie_by_title($1).id}/show_with_same_director"
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
  
end

World(NavigationHelpers)
