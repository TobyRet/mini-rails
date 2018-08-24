require 'spec_helper'
require 'active_record'
require 'muffin_blog/app/models/application_record'
require 'muffin_blog/app/models/post'

RSpec.describe 'ActiveRecord' do
  before(:each) do
    Post.establish_connection(
      database: "#{__dir__}/muffin_blog/db/development.sqlite3"
    )
  end

  it '#initialize' do
    post = Post.new(id: 1, title: 'My first post')
    expect(post.id).to eq(1)
    expect(post.title).to eq('My first post')
  end

  it '#find' do
    post = Post.find(1)

    expect(post).to be_a_kind_of(Post)
    expect(post.id).to eq(1)
    expect(post.title).to eq('Blueberry Muffins')
  end

  it '#all' do
    post = Post.all.first

    expect(post).to be_a_kind_of(Post)
    expect(post.id).to eq(1)
    expect(post.title).to eq('Blueberry Muffins')
  end

  describe '#connection' do
    it 'executes SQL' do
      rows = Post.connection.execute("SELECT * FROM posts")

      expect(rows).to be_kind_of(Array)

      row = rows.first

      expect(row).to be_kind_of(Hash)
      expect(row.keys).to eq([:id, :title, :body, :created_at, :updated_at])
    end
  end
end


