# coding: utf-8
class MyController < ApplicationController

  #---------#
  # library #
  #---------#
  def library( controller, action )
    @active = { "#{controller}_#{action}" => "active" }

    @user = User.where( id: session[:user_id] ).first
    @groups = Group.where( user_id: session[:user_id] ).includes( :pages ).order( "groups.name ASC, pages.title ASC" ).all
    @group  = Group.new
  end

  #--------------#
  # create_group #
  #--------------#
  def create_group
    group = Group.new( params[:group] )
    group.user_id = session[:user_id]

    if group.save
      GroupMember.create( group_id: group.id, user_id: group.user_id )
      message = { notice: "グループを作成しました。" }
    else
      message = { alert: "グループの作成に失敗しました。" }
    end

    redirect_to( { action: "library" }, message )
  end

  #--------------#
  # delete_group #
  #--------------#
  def delete_group
    group = Group.where( id: params[:id], user_id: session[:user_id] ).first
    group.destroy

    redirect_to( action: "library" )
  end
end
