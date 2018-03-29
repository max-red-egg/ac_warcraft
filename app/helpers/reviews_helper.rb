module ReviewsHelper
  def print_rating_stars(rating)
    print_star = ""
    for i in 0..5
      if i < rating
        print_star += "<i class='fa fa-star  text-gold'></i>"
      else
        print_star += "<i class='fa fa-star-o text-gold'></i>"
      end
    end
    print_star.html_safe
  end
end
