module PartialHelper
  # Renders a partial taking into account the current user's UserRole objects.
  def partial(partial, options = {})
    subs = current_user.full? { |user| user.roles } || []
    subs << :admin if admin?
    render options.merge(:partial => search_for_partial(partial, subs))
  end
  
  def search_for_partial(partial, sub_dirs, views_dirs = [controller_name, 'partials']) # :nodoc:
    sub_dirs << '' unless sub_dirs.include?('')
    views_dirs.each do |view_dir|
      sub_dirs.each do |sub_dir|
        sub_dir = sub_dir.full? { |d| "#{d}/" }.to_s
        if template_exists?("/#{view_dir}/#{sub_dir}_#{partial}")
          return "/#{view_dir}/#{sub_dir}#{partial}"
        end
      end
    end
    raise "partial not found: #{partial} (sub_dirs: #{sub_dirs.inspect})"
  end
end