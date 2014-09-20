class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :hand_events
  acts_as_network :connections, :join_table => :connections,
                                :foreign_key => :u1_id,
                                :association_foreign_key => :u2_id

  serialize :info, JSON
end
