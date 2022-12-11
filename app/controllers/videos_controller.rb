# frozen_string_literal: true

class VideosController < ApplicationController
  def index
    @videos = if filter_params.present?
                VideoSearch.new(params[:q], filters: filter_params, page:).videos
              else
                Video.visible.includes(playlist: :topic).order(published_at: :desc).page(page).per(10)
              end
  end

  def show
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @video.visible?
  end

  def find_by_id
    @video = Video.find_by!(youtube_id: params[:id])
    redirect_to playlist_video_path(@video, playlist_id: @video.playlist)
  end

  def early
    @videos = Video.early_access
    respond_to do |format|
      format.json
    end
  end

  private

  def page
    params.fetch(:page, 1)
  end

  def filter_params
    params.permit(:q, :length, :tag, topic: [])
  end
end
