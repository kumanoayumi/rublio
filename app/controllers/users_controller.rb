# coding: utf-8
class UsersController < ApplicationController

  #-------#
  # index #
  #-------#
  def index
    @active = { "#{params[:controller]}_#{params[:action]}" => "active" }

    @users = User.order( "id DESC" ).page( params[:page] ).per( 500 ).all
  end

  #---------#
  # library #
  #---------#
  def library
    user_id = params[:id].presence || session[:user_id]
    @active = { "#{params[:controller]}_#{params[:action]}" => "active" }

    @user = User.where( id: user_id ).first
    @groups = Group.where( user_id: user_id ).where( "groups.permission = 'group' OR groups.permission = 'public'" ).includes( :pages ).order( "groups.name ASC, pages.title ASC" ).all
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

    redirect_to( { action: "library", id: session[:user_id] }, message )
  end

  #--------------#
  # delete_group #
  #--------------#
  def delete_group
    group = Group.where( id: params[:id], user_id: session[:user_id] ).first
    group.destroy

    redirect_to( action: "library", id: session[:user_id] )
  end
end
