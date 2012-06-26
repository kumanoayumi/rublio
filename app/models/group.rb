class Group < ActiveRecord::Base
  attr_accessible :name, :user_id, :default_flag

  belongs_to :user
  has_many :pages

  #-----------#
  # is_owner? #
  #-----------#
  def is_owner?( user_id )
    return true if self.user_id == user_id
    return false
  end

  private

  #---------------------#
  # self.create_default #
  #---------------------#
  # デフォルトグループ作成
  def self.create_default( user )
    # 作成済みでなければ
    unless Group.where( user_id: user.id, default_flag: true ).exists?
      Group.create( user_id: user.id, name: "Default", default_flag: true )
    end
  end

end
