require 'yaml'

config = YAML.load_file('./config.yml')


class App
# initialize data
  def initialize(data)
    @accountsInfo = data['accounts']
    @banknotes = data['banknotes']
  end
# check User Number and Pass
  def checkInfo
    puts "Please Enter Your Account Number:"
    id = gets.chomp
    puts "Enter Your Password:"
    pass = gets.chomp
    @user = @accountsInfo[id.to_i]
    @balance = @user['balance']
    if @user && @user['password'] == pass
      puts "Hello, #{@user['name']}!"
      option
    else
      puts 'ERROR: ACCOUNT NUMBER AND PASSWORD DONT MATCH'
      checkInfo
    end
  end

  def checkBanknotes(withdrawMoney)
    @correctSumm = false
    banknotesSumm = 0
    @banknotes.each {|key,val|
      allThisBanknotes = (key * val)
      if val > 0 
        if banknotesSumm  == withdrawMoney
          @correctSumm = true
        elsif withdrawMoney < key
          banknotesSumm = banknotesSumm
        elsif banknotesSumm < withdrawMoney
          diferentValue = ((withdrawMoney - banknotesSumm)/key).round(0)
          if  val >= diferentValue
            banknotesSumm +=  key*diferentValue
          else
            banknotesSumm +=  key*val
          end
        end
      end
    }
  end
# Withdraw option
  def withdraw
    summ = 0

    @banknotes.each {|key,val|
      if val > 0
        summ = summ + (key * val)
      end
    }

    puts 'Enter Amount You Wish to Withdraw:'
    withdrawValue = (gets.chomp).to_i

    if withdrawValue > 5000 || withdrawValue < 1
      puts 'ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:'
      withdraw
    elsif (withdrawValue < 5000 && withdrawValue  > summ) || withdrawValue > @balance
      puts "ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS ₴#{summ}. PLEASE ENTER A DIFFERENT AMOUNT:"
      withdraw
    else
      checkBanknotes(withdrawValue)
      if @correctSumm
        @balance = @balance - withdrawValue
        puts "Your New Balance is ₴#{@balance}"
        option
      else
        puts 'ERROR: THE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT:'
        option
      end
    end
  end
# Option
  def option
    puts 'Please Choose From the Following Options:'
    puts '1. Display Balance'
    puts '2. Withdraw'
    puts "3. Log Out"

    choice = gets.chomp.downcase
    case choice
    when '1'
      puts "Your Current Balance is ₴#{@balance}"
      option
    when '2'
      withdraw
    when '3'
      puts "#{@user['name']}, Thank You For Using Our ATM. Good-Bye!"
      checkInfo
    else
      puts "Sorry, I didn't understand you."
      option
    end

  end
end

myApp = App.new(config)

myApp.checkInfo


