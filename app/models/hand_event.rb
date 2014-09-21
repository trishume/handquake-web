class HandEvent < ActiveRecord::Base
  TIMEOUT = 20.seconds
  belongs_to :user
  belongs_to :connection

  def self.find_prox(lat, lon, time, user)
    thresh = 2.hours
    lthresh = 1.0
    q = [
      "(connection_id IS NULL) AND created_at < ? AND created_at > ? AND user_id != ? AND latitude > ? AND latitude < ? AND longitude > ? AND longitude < ?",
      time+thresh, time-thresh, user.id,lat-lthresh,lat+lthresh,lon-lthresh,lon+lthresh
    ]
    HandEvent.where(q).last
  end

  def find_other
    HandEvent.where(["(connection_id IS NULL) AND created_at < ? AND created_at > ? AND user_id != ? AND (dir != ? OR dir IS NULL)", created_at, created_at - TIMEOUT, user.id, dir]).last
  end

  def try_connect
    return connection if connection
    other = find_other
    connect_to_event(other)
  end

  def connect_to_event(other)
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

  def connect_to_user(other)
    return false unless other
    conn = Connection.new(u1: user, u2: other)
    self.connection = conn
    # ActiveRecord::Base.transaction do
      conn.save
      save!
    # end

    conn
  end

  def to_late?
    created_at < (Time.now - TIMEOUT)
  end
end
