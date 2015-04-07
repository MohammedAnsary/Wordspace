# User Model
class User < ActiveRecord::Base
  has_many :joinmagazines
  has_many :magazines, through: :joinmagazines

  # many-to-many relationship between user requests joining magazine
  has_many :requestjoiningmagazines
  has_many :magazines, through: :requestjoiningmagazines

  # to upload avatar for user
  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable,

  # making firstname and lastname required
  validates :firstname, presence: true
  validates :lastname, presence: true
  # adding relation between user and articles
  has_many :articles
  # Author: Mohammed El-Ansary
  # 5.4.2015
  # Adding relation between user and magazines
  has_and_belongs_to_many :magazines
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #:recoverable,
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # to upload avatar for user
  validates_integrity_of :avatar
  validates_processing_of :avatar
end
