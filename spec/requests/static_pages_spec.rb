require 'spec_helper'

describe "Static pages" do
  subject { page }
  let(:title_prefix) {"Topic Post"}

  describe "GET home page" do
    before { visit root_path }

    it { should have_selector('h1', :text => 'Sample App') }
    it { should have_selector('title', :text => "#{title_prefix} | Home") }
  end

  describe "GET help page" do
    before { visit help_path }

  	it { should have_selector('h1', :text => 'Help') }
    it { should have_selector('title', :text => "#{title_prefix} | Help") }
  end

  describe "GET about page" do
    before { visit about_path }

  	it { should have_selector('h1', :text => 'About') }
    it { should have_selector('title', :text => "#{title_prefix} | About") }
  end
end
