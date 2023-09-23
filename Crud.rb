# myapp.rb

# Carrega a gem Rails
require 'rails'

# Define uma classe de aplicativo Rails
class MyApp < Rails::Application
  # Configuração do aplicativo
  config.root = File.dirname(__FILE__)
  config.secret_key_base = 'your_secret_key_base'
  config.eager_load = false
end

# Define um modelo Produto
class Produto < ActiveRecord::Base
end

# Define uma migração para criar a tabela de produtos
class CreateProdutos < ActiveRecord::Migration[7.0]
  def change
    create_table :produtos do |t|
      t.string :nome
      t.text :descricao
      t.decimal :preco

      t.timestamps
    end
  end
end

# Cria a tabela no banco de dados
CreateProdutos.new.change

# Define um controlador ProdutosController
class ProdutosController < ActionController::Base
  def index
    @produtos = Produto.all
  end
end

# Configura as rotas
Rails.application.routes.draw do
  get '/produtos', to: 'produtos#index'
end

# Define uma vista para listar os produtos (app/views/produtos/index.html.erb)
File.write('app/views/produtos/index.html.erb', <<~HTML)
  <h1>Lista de Produtos</h1>
  <ul>
    <% @produtos.each do |produto| %>
      <li><%= produto.nome %> - <%= produto.descricao %> - <%= produto.preco %></li>
    <% end %>
  </ul>
HTML

# Inicializa o servidor
MyApp.initialize!

# Inicia o servidor em uma porta específica
Rack::Handler::WEBrick.run Rails.application, Port: 3000
