require 'spec_helper'
require 'active_record'
require 'active_support'

RSpec.describe ActiveRecord do
  before(:each) do
    ActiveSupport::Dependencies.autoload_paths = Dir["#{__dir__}/muffin_blog/app/*"]

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

  it '#where' do
    relation = Post.where('id = 2').where('title IS NOT NULL')
    expect(relation.to_sql).to eq('SELECT * FROM posts WHERE id = 2 AND title IS NOT NULL')

    post = relation.first
    expect(post.id).to eq(2)
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


