namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") { %x(rails db:drop:_unsafe) }
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      %x(rails dev:add_coins) 
      %x(rails dev:add_mining_types) 
    else
      puts "Voce nao esta em ambiente de desenvolvimento"
    end
  end
  
  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins=[
              {
                description: "Bitcoin",
                acronym: "BTC",
                url_image: "https://w7.pngwing.com/pngs/450/133/png-transparent-bitcoin-cryptocurrency-virtual-currency-decal-blockchain-info-bitcoin-text-trademark-logo.png"
              },
              {
                description: "Ethereum",
                acronym: "ETH",
                url_image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Ethereum-icon-purple.svg/1200px-Ethereum-icon-purple.svg.png",
              },
              {
                description: "Dash",
                acronym: "DASH",
                url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/131.png",
              },
              { 
                description: "Iota",
                acronym: "IOT",
                url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1720.png",
              },
              { 
                description: "ZCash",
                acronym: "ZEC",
                url_image: "https://www.cryptocompare.com/media/351360/zec.png",
              }
      ]
      
      coins.each do |coin|
          Coin.find_or_create_by!(coin)
      end
    end
  end
  
  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipo de mineração...") do
      mining_types = [
        {name: "Proof of Work", acronym: "PoW"},
        {name: "Proof of Stake", acronym: "PoS"},
        {name: "Proof of Capacity", acronym: "PoC"}
      ]
    
      mining_types.each do |mining_types|
        MiningType.find_or_create_by!(mining_types)
      end
    end
  end
    
  private
  
  def show_spinner(msg_start, msg_end = "Concluido")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin 
    yield
    spinner.success("(#{msg_end})")  
  end
end