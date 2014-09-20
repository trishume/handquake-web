class HandEvent < ActiveRecord::Base
  TIMEOUT = 1.minutes
  belongs_to :user
  belongs_to :connection

  def find_other
    HandEvent.where(["(connection_id IS NULL) AND created_at < ? AND created_at > ? AND id != ?", created_at, created_at - TIMEOUT, id]).last
  end

  def try_connect
    return connection if connection
    other = find_other
    return false unless other
    conn = Connection.new(u1: user, u2: other.user)
    self.connection = conn
    other.connection = conn
    # ActiveRecord::Base.transaction do
      conn.save
      save!
      other.save!
    # end

    conn
  end

  def to_late?
    created_at < (Time.now - TIMEOUT)
  end
end
