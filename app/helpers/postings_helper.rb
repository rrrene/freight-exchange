module PostingsHelper

  def posting_html_classes(ar)
    classes = []
    classes << if ar.try(:valid_until).to_i < Time.now.to_i
      :old
    else
      :new
    end
    if @highlight && @highlight.include?(ar.id.to_s)
      classes << "highlight"
    end
    if white_listed?(ar.company)
      classes << "white_listed"
    end
    classes * " "
  end
end
