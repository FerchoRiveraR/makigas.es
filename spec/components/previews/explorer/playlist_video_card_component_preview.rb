# frozen_string_literal: true

module Explorer
  # @label Playlist video card
  class PlaylistVideoCardComponentPreview < ViewComponent::Preview
    # Renders a playlist
    #
    # @display padding 10px
    def default
      component = Six::Explorer::PlaylistVideoCardComponent.new(video: Video.first)
      render ViewComponentContrib::WrapperComponent.new(component) do |wrapper|
        wrapper.content_tag(:div, style: '--video-card-hover-background: #e1f5fe;') do
          wrapper.component
        end
      end
    end
  end
end
