require 'rails_helper'

RSpec.feature "Playlists", type: :feature do
  context 'listing playlists' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
    end
    
    it 'should be success' do
      visit playlists_path
      expect(page).to have_http_status :success
    end
    
    it 'should list playlists title' do
      visit playlists_path
      expect(page).to have_content @playlist.title
    end
  end
  
  context 'showing playlist page' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @video = FactoryGirl.create(:video, playlist: @playlist, duration: 83)
    end
    
    it 'should be success' do
      visit playlist_path @playlist
      expect(page).to have_http_status :success
    end
    
    it 'should list playlist title' do
      visit playlist_path @playlist
      expect(page).to have_content @playlist.title
    end
    
    it 'should list playlist description' do
      visit playlist_path @playlist
      expect(page).to have_content @playlist.description
    end
    
    it 'should list video title' do
      visit playlist_path @playlist
      expect(page).to have_content @video.title
    end
    
    it 'should list video description' do
      visit playlist_path @playlist
      expect(page).to have_content @video.description
    end
    
    it 'should display video length' do
      visit playlist_path @playlist
      expect(page).to have_content '1:23'
    end
  end

  context 'creating a playlist' do
    it 'should be success' do
      visit new_playlist_path
      expect(page).to have_http_status :success
    end

    scenario 'user should create a playlist' do
      visit playlists_path
      click_link I18n.t('playlists.index.new')
      fill_in Playlist.human_attribute_name(:title), with: "My test playlist"
      fill_in Playlist.human_attribute_name(:description), with: "This is a sample playlist"
      fill_in Playlist.human_attribute_name(:youtube_id), with: "1928374098120379"
      attach_file I18n.t('playlists.form.search'), Rails.root + "spec/fixtures/playlist.jpg", visible: false
      click_button I18n.t('playlists.form.save')
      expect(page).to have_content "My test playlist"
    end

    scenario 'user should not create a wrong playlist' do
      visit playlists_path
      click_link I18n.t('playlists.index.new')
      fill_in Playlist.human_attribute_name(:description), with: "I forgot the title"
      click_button I18n.t('playlists.form.save')
      expect(page).to have_content I18n.t('playlists.form.errors')
    end
  end

  context 'updating a playlist' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
    end

    it 'should be success' do
      visit edit_playlist_path(@playlist)
      expect(page).to have_http_status :success
    end

    scenario 'user should edit a playlist' do
      visit playlist_path(@playlist)
      click_link I18n.t('playlists.show.edit')
      fill_in Playlist.human_attribute_name(:title), with: 'My new test playlist'
      click_button I18n.t('playlists.form.save')
      expect(page).to have_current_path playlist_path(@playlist)
    end

    scenario 'user cannot edit wrong a playlist' do
      visit playlist_path(@playlist)
      click_link I18n.t('playlists.show.edit')
      fill_in Playlist.human_attribute_name(:title), with: ''
      click_button I18n.t('playlists.form.save')
      expect(page).to have_content I18n.t('playlists.form.errors')
    end
  end

  context 'deleting a playlist' do
    before(:each) do
      @playlist = FactoryGirl.create(:playlist)
      @title = @playlist.title
    end

    it 'should appear on the index page' do
      visit playlists_path
      expect(page).to have_content @title
    end

    it 'should be deleted' do
      visit playlist_path(@playlist)
      click_button I18n.t('playlists.show.delete')
      expect(page).to have_current_path playlists_path
      expect(page).not_to have_content @title
    end
  end
end
