module MicropostsHelper
  def wrap(micropost)
    micropost.content = micropost.content.split.map do |s|
                          wrap_long_string(s)
                        end.join(" ")

    if micropost.in_reply_to.present?
      reply_to_user = micropost.in_reply_to_micropost.user
      in_reply_to_name = "@#{reply_to_user.name}:"
      micropost.content.sub!(in_reply_to_name,
                             link_to(in_reply_to_name,
                                     reply_to_user))
    end
    sanitize(raw(micropost.content))
  end

  private
    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text :
                                  text.scan(regex).join(zero_width_space)
    end
end