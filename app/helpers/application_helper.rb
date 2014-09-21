require "digest/md5"

module ApplicationHelper
  def gravatar_path(email)
    hash = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar/#{hash}?s=100"
  end
end
