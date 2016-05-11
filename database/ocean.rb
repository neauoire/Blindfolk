#!/bin/env ruby
# encoding: utf-8

class Oscean
  
  def initialize
    
  end
	
  def connect

  	$quest = Mysql.real_connect("localhost", "<USER>", "<PASS>", "<DB>")
	
  end
  
  def leaderboard

    array = []
    query = $quest.query("SELECT id,kills,deaths,streaks,isAlive,book FROM PHL_Blind WHERE kills>0 OR deaths>0 ORDER BY kills DESC")
    while row = query.fetch_row do
      array.push({"id" => row[0].to_i, "kills" => row[1].to_i, "deaths" => row[2].to_i, "streaks" => row[3].to_i, "isAlive" => row[4].to_i, "ratio" => row[1].to_i-row[2].to_i, "book" => row[5] })
    end
    return array.sort_by { |k| k["ratio"] }.reverse

  end

  # Player

  def playerWithToken token

    # Load Player
    query = $quest.query("SELECT id,token,script,kills,deaths,streaks,isAlive,book FROM PHL_Blind WHERE token='#{token}'")
    while row = query.fetch_row do
      return {"id" => row[0],"token" => row[1],"script" => row[2],"kills" => row[3],"deaths" => row[4],"streaks" => row[5],"isAlive" => row[6],"book" => row[7]}
    end

    # Create new player
    $quest.query("INSERT INTO PHL_Blind (token,script) VALUES ('#{token}','#{defaultScript}')")

    # Load Player
    query = $quest.query("SELECT id,token,script,kills,deaths,streaks,isAlive,book FROM PHL_Blind WHERE token='#{token}'")
    while row = query.fetch_row do
      return {"id" => row[0],"token" => row[1],"script" => row[2],"kills" => row[3],"deaths" => row[4],"streaks" => row[5],"isAlive" => row[6],"book" => row[7]}
    end

    return nil

  end
  
  def players

    array = []
    query = $quest.query("SELECT id,script,book FROM PHL_Blind WHERE isAlive=1")
    while row = query.fetch_row do
      array.push(Blindfolk.new(row[0],row[1],row[2]))
    end
    return array

  end

  def createPlayer token

    $quest.query("INSERT INTO PHL_Blind (token,script) VALUES ('#{token}','#{defaultScript}')")

  end

  def updatePlayer player

    if player.isAlive == 1
      $quest.query("UPDATE PHL_Blind SET isAlive=1,kills=kills+#{player.score},book='#{player.book}',streaks=streaks+1 WHERE id='#{player.id}'")
    else
      $quest.query("UPDATE PHL_Blind SET isAlive=0,kills=kills+#{player.score},book='#{player.book}',streaks=0,deaths=deaths+1 WHERE id='#{player.id}'")
    end

  end

  def loadPlayer token

    query = $quest.query("SELECT id FROM PHL_Blind WHERE token='#{token}'")
    while row = query.fetch_row do
      return row
    end
    return nil

  end
  
  # Logs

  def log

    query = $quest.query("SELECT id,message FROM PHL_BlindLogs ORDER BY id DESC LIMIT 0,1")
    while row = query.fetch_row do
      return row
    end
    return nil

  end

  def saveLogs message

    $quest.query("INSERT INTO PHL_BlindLogs (message) VALUES ('"+message+"')")

  end
  
  # Scripts

  def saveScript token,script

    $quest.query("UPDATE PHL_Blind SET script='#{script}' WHERE token='#{token}'")

  end

  def respawn token

    $quest.query("UPDATE PHL_Blind SET isAlive=1 WHERE token='#{token}'")

  end

  def defaultScript

    return "case attack.forward

  step.right
  move.forward
  turn.left
  attack.forward

case kill

  say you never stood a chance

case default

  move.backward
  attack.forward
  step.left
  turn.right"

  end
  
end