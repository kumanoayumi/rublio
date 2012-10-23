# coding: utf-8
class PagesController < ApplicationController

  #-------#
  # index #
  #-------#
  def index
    @pages = Page.where( group_id: params[:group_id] ).includes( :user, :group ).all
    @group = Group.where( id: params[:group_id] ).first
  end

  #------#
  # show #
  #------#
  def show
    @page = Page.where( id: params[:id] ).includes( :group ).first

    # ブランクチェック
    redirect_to( :root, alert: "該当するページがありません。" ) and return if @page.blank?

    # 公開範囲チェック
    redirect_to( :root, alert: "閲覧権限がありません。" ) and return unless @page.permission_ok?( session[:user_id], @page.group )
  end

  #---------#
  # content #
  #---------#
  def content
    @page = Page.where( id: params[:id] ).includes( :group ).first

    # ブランクチェック
    redirect_to( :root, alert: "該当するページがありません。" ) and return if @page.blank?

    # 公開範囲チェック
    redirect_to( :root, alert: "閲覧権限がありません。" ) and return unless @page.permission_ok?( session[:user_id], @page.group )

    render layout: false
  end

  #-----#
  # new #
  #-----#
  def new
    @group = Group.where( id: params[:group_id], user_id: session[:user_id] ).first
    @group_id = @group.id
    @page = Page.new
  end

  #------#
  # edit #
  #------#
  def edit
#    @page = Page.where( id: params[:id], user_id: session[:user_id] ).first
    @page = Page.where( id: params[:id] ).includes( :group ).first
    @groups = Group.where( user_id: session[:user_id] ).order( "name ASC" ).all
  end

  #--------#
  # create #
  #--------#
  def create
    page = Page.new( params[:page] )
    page.user_id = session[:user_id]
    page.group_id = params[:group_id]

    if page.save
      message = { notice: "ページを作成しました。" }
    else
      message = { alert: "ページの作成に失敗しました。" }
    end

    redirect_to( { action: "show", id: page.id }, message )
  end

  #--------#
  # update #
  #--------#
  def update
    page = Page.where( id: params[:id] ).includes( :group ).first

    unless page.permission_ok?( session[:user_id], page.group )
      redirect_to( { action: "show", id: page.id }, "更新権限がありません。" ) and return
    end

    if page.update_attributes( params[:page] )
      message = { notice: "ページを更新しました。" }
    else
      message = { alert: "ページの更新に失敗しました。" }
    end

    redirect_to( { action: "show", id: page.id }, message )
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    page = Page.where( id: params[:id], user_id: session[:user_id] ).first
    page.destroy

    redirect_to( controller: "my", action: "library", anchor: "group_#{page.group_id}" )
  end

end
